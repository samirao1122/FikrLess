import 'dart:async';
import 'dart:convert';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'auth_cache_service.dart';

/// Service for step counting functionality with batch sync
class StepCounterService {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  int _steps = 0;
  int _initialSteps = 0; // Store initial steps to calculate daily steps
  int _lastRecordedSteps = 0; // Last recorded step count for incremental tracking
  bool _isListening = false;
  Timer? _periodicSyncTimer; // Timer for syncing every 2 minutes
  
  static const String _keyInitialSteps = 'initial_steps';
  static const String _keyStepsDate = 'steps_date';
  static const String _keyPendingSteps = 'pending_steps'; // JSON array of unsynced step entries
  static const Duration _syncInterval = Duration(minutes: 2); // Sync every 2 minutes

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
      
      // Sync any pending steps on app open
      await _syncPendingSteps();
      
      // Start periodic sync timer (every 2 minutes)
      _startPeriodicSyncTimer();
      
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
        _lastRecordedSteps = 0;
        print('New day - Initial steps set to: $_initialSteps');
      } else {
        // Same day - use saved initial steps
        _initialSteps = savedInitialSteps;
        _steps = (currentStepCount.steps - _initialSteps).clamp(0, double.infinity).toInt();
        _lastRecordedSteps = _steps;
        print('Same day - Steps today: $_steps (cumulative: ${currentStepCount.steps}, initial: $_initialSteps)');
      }
    } catch (e) {
      print('Error getting initial step count: $e');
      _initialSteps = savedInitialSteps;
      _steps = 0;
      _lastRecordedSteps = 0;
    }
  }

  void _onStepCount(StepCount event) {
    // Calculate daily steps by subtracting initial steps
    final newSteps = (event.steps - _initialSteps).clamp(0, double.infinity).toInt();
    
    if (newSteps > _steps) {
      // Steps increased - record the increment
      final stepsIncrement = newSteps - _steps;
      _steps = newSteps;
      
      // Save the increment to pending steps
      _recordStepIncrement(stepsIncrement);
    }
    
    print('Steps updated: $_steps (cumulative: ${event.steps}, initial: $_initialSteps)');
  }

  /// Record step increment in the required format
  Future<void> _recordStepIncrement(int stepsIncrement) async {
    if (stepsIncrement <= 0) return;
    
    final now = DateTime.now();
    final date = now.toIso8601String().split('T')[0]; // YYYY-MM-DD
    
    // Format timestamp as ISO 8601 UTC without milliseconds (e.g., "2025-12-17T10:02:24Z")
    final utcNow = now.toUtc();
    final timestamp = '${utcNow.year}-${utcNow.month.toString().padLeft(2, '0')}-${utcNow.day.toString().padLeft(2, '0')}T'
        '${utcNow.hour.toString().padLeft(2, '0')}:${utcNow.minute.toString().padLeft(2, '0')}:${utcNow.second.toString().padLeft(2, '0')}Z';
    
    // Calculate calories and distance (approximate)
    final caloriesBurned = (stepsIncrement * 0.04).round();
    final distanceKm = double.parse((stepsIncrement * 0.0008).toStringAsFixed(2));
    
    // Create entry in the exact format required
    final entry = {
      'steps': stepsIncrement,
      'date': date,
      'timestamp': timestamp,
      'calories_burned': caloriesBurned,
      'distance_km': distanceKm,
    };
    
    // Add to pending steps
    await _addPendingStepEntry(entry);
    
    print('Recorded step increment: $stepsIncrement steps at $timestamp');
  }

  /// Add step entry to pending list (in the exact format)
  Future<void> _addPendingStepEntry(Map<String, dynamic> entry) async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_keyPendingSteps) ?? '[]';
    final pendingList = (json.decode(pendingJson) as List).cast<Map<String, dynamic>>();
    
    pendingList.add(entry);
    
    await prefs.setString(_keyPendingSteps, json.encode(pendingList));
  }

  /// Start periodic sync timer (every 2 minutes)
  void _startPeriodicSyncTimer() {
    _periodicSyncTimer?.cancel();
    
    _periodicSyncTimer = Timer.periodic(_syncInterval, (timer) async {
      if (_isListening) {
        print('Periodic sync triggered (every 2 minutes)');
        await _syncPendingSteps();
      }
    });
    
    print('Periodic sync timer started (every 2 minutes)');
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
    
    // Prepare entries for batch sync (already in correct format)
    final List<Map<String, dynamic>> entries = List.from(pendingList);
    
    print('Syncing ${entries.length} step entries...');
    
    // Batch sync all entries
    final success = await StepsApiService.batchSyncSteps(
      entries: entries,
      token: token,
    );
    
    if (success) {
      // Clear pending steps on successful sync
      await prefs.setString(_keyPendingSteps, '[]');
      print('✅ All ${entries.length} step entries synced successfully');
    } else {
      // Keep failed entries in cache for retry
      print('❌ Failed to sync step entries. Will retry on next sync.');
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

  /// Get pending steps count (for debugging)
  Future<int> getPendingStepsCount() async {
    final prefs = await SharedPreferences.getInstance();
    final pendingJson = prefs.getString(_keyPendingSteps) ?? '[]';
    final pendingList = (json.decode(pendingJson) as List);
    return pendingList.length;
  }

  /// Dispose resources
  void dispose() {
    _isListening = false;
    _stepCountSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _periodicSyncTimer?.cancel();
    
    // Sync pending steps before disposing
    _syncPendingSteps();
  }
}
