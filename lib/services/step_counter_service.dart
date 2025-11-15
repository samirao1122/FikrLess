import 'dart:async';
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'auth_cache_service.dart';

/// Service for step counting functionality
class StepCounterService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _steps = 0;
  int _initialSteps = 0; // Store initial steps to calculate daily steps
  int _lastSyncedSteps = 0; // Last synced step count
  int _lastSavedSteps = 0; // Last saved step count (for 25 interval tracking)
  bool _isListening = false;
  Timer? _midnightSyncTimer;
  Timer? _intervalCheckTimer;
  
  static const String _keyInitialSteps = 'initial_steps';
  static const String _keyStepsDate = 'steps_date';
  static const String _keyPendingSteps = 'pending_steps'; // JSON array of unsynced steps
  static const int _syncInterval = 25; // Sync every 25 steps

  StreamSubscription<StepCount>? _stepCountSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;

  /// Initialize step counter
  Future<bool> initialize() async {
    try {
      // Request activity recognition permission
      final status = await Permission.activityRecognition.request();
      if (!status.isGranted) {
        print('Activity recognition permission not granted');
        return false;
      }

      _stepCountStream = Pedometer.stepCountStream;
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;

      // Get or set initial steps for today
      await _initializeDailySteps();

      // Listen to step count stream
      _stepCountSubscription = _stepCountStream.listen(
        _onStepCount,
        onError: _onStepCountError,
      );

      _pedestrianStatusSubscription = _pedestrianStatusStream.listen(
        _onPedestrianStatusChanged,
        onError: _onPedestrianStatusError,
      );

      _isListening = true;
      
      // Start midnight sync timer
      _startMidnightSyncTimer();
      
      // Start interval check timer (check every second for step changes)
      _startIntervalCheckTimer();
      
      return true;
    } catch (e) {
      print('Error initializing step counter: $e');
      return false;
    }
  }

  /// Initialize daily steps by checking if it's a new day
  Future<void> _initializeDailySteps() async {
    final prefs = await SharedPreferences.getInstance();
    final today = DateTime.now();
    final todayKey = '${today.year}-${today.month}-${today.day}';
    final savedDate = prefs.getString(_keyStepsDate);
    final savedInitialSteps = prefs.getInt(_keyInitialSteps) ?? 0;

    // Get current cumulative steps from pedometer
    try {
      final currentStepCount = await _stepCountStream.first.timeout(
        const Duration(seconds: 3),
      );
      
      if (savedDate != todayKey) {
        // New day - reset initial steps
        _initialSteps = currentStepCount.steps;
        await prefs.setInt(_keyInitialSteps, _initialSteps);
        await prefs.setString(_keyStepsDate, todayKey);
        _steps = 0;
        print('New day - Initial steps set to: $_initialSteps');
      } else {
        // Same day - use saved initial steps
        _initialSteps = savedInitialSteps;
        _steps = (currentStepCount.steps - _initialSteps).clamp(0, double.infinity).toInt();
        print('Same day - Steps today: $_steps (cumulative: ${currentStepCount.steps}, initial: $_initialSteps)');
      }
    } catch (e) {
      print('Error getting initial step count: $e');
      _initialSteps = savedInitialSteps;
      _steps = 0;
    }
  }

  void _onStepCount(StepCount event) {
    // Calculate daily steps by subtracting initial steps
    _steps = (event.steps - _initialSteps).clamp(0, double.infinity).toInt();
    print('Steps updated: $_steps (cumulative: ${event.steps}, initial: $_initialSteps)');
  }

  /// Start timer to check for midnight sync
  void _startMidnightSyncTimer() {
    // Cancel existing timer if any
    _midnightSyncTimer?.cancel();
    
    // Calculate time until 11:59 PM
    final now = DateTime.now();
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    final syncTime = DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 23, 59);
    final durationUntilSync = syncTime.difference(now);
    
    _midnightSyncTimer = Timer(durationUntilSync, () async {
      await _syncPendingSteps();
      // Restart timer for next day
      _startMidnightSyncTimer();
    });
    
    print('Midnight sync timer set for: $syncTime');
  }

  /// Start timer to check step intervals
  void _startIntervalCheckTimer() {
    _intervalCheckTimer?.cancel();
    
    _intervalCheckTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      final stepsSinceLastSave = _steps - _lastSavedSteps;
      
      if (stepsSinceLastSave >= _syncInterval) {
        await _saveStepsInterval();
      }
    });
  }

  /// Save steps every 25 intervals
  Future<void> _saveStepsInterval() async {
    if (_steps <= _lastSavedSteps) return;
    
    final stepsToSave = _steps - _lastSavedSteps;
    final timestamp = DateTime.now().toIso8601String();
    
    // Format time as ISO (e.g., "2024-01-15T22:02:24.000Z")
    final timeFormatted = timestamp;
    
    // Save to pending steps
    await _addPendingStep(stepsToSave.toString(), timeFormatted);
    
    _lastSavedSteps = _steps;
    
    print('Saved step interval: $stepsToSave steps at $timeFormatted');
    
    // Try to sync immediately
    await _syncPendingSteps();
  }

  /// Add step entry to pending list
  Future<void> _addPendingStep(String steps, String time) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_keyPendingSteps) ?? '[]';
    final pendingList = (json.decode(pendingJson) as List).cast<Map<String, dynamic>>();
    
    pendingList.add({
      'steps': steps,
      'time': time,
    });
    
    await prefs.setString(_keyPendingSteps, json.encode(pendingList));
  }

  /// Sync all pending steps to API
  Future<void> _syncPendingSteps() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_keyPendingSteps) ?? '[]';
    final pendingList = (json.decode(pendingJson) as List).cast<Map<String, dynamic>>();
    
    if (pendingList.isEmpty) {
      print('No pending steps to sync');
      return;
    }
    
    final token = await AuthCacheService.getAuthToken();
    if (token == null || token.isEmpty) {
      print('No auth token available for step sync');
      return;
    }
    
    // Sync each pending step
    final List<Map<String, dynamic>> failedSyncs = [];
    
    for (final stepEntry in pendingList) {
      final success = await StepsApiService.syncSteps(
        steps: stepEntry['steps'] as String,
        time: stepEntry['time'] as String,
        token: token,
      );
      
      if (!success) {
        failedSyncs.add(stepEntry);
      }
    }
    
    // Update pending list with only failed syncs
    await prefs.setString(_keyPendingSteps, json.encode(failedSyncs));
    
    if (failedSyncs.isEmpty) {
      print('All pending steps synced successfully');
      _lastSyncedSteps = _steps;
    } else {
      print('${failedSyncs.length} step entries failed to sync');
    }
  }

  void _onStepCountError(error) {
    print('Step count error: $error');
  }

  void _onPedestrianStatusChanged(PedestrianStatus event) {
    // Handle pedestrian status changes if needed
  }

  void _onPedestrianStatusError(error) {
    print('Pedestrian status error: $error');
  }

  /// Get current step count
  int getCurrentSteps() {
    return _steps;
  }

  /// Sync all pending steps (can be called manually)
  Future<void> syncAllPendingSteps() async {
    await _syncPendingSteps();
  }

  /// Dispose resources
  void dispose() {
    _isListening = false;
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _midnightSyncTimer?.cancel();
    _intervalCheckTimer?.cancel();
    
    // Sync pending steps before disposing
    _syncPendingSteps();
  }
}

