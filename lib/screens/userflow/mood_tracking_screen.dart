import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import '../../utils/mood_helper.dart';

class MoodTrackingScreen extends StatefulWidget {
  final Locale locale;

  const MoodTrackingScreen({super.key, required this.locale});

  @override
  State<MoodTrackingScreen> createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  final TextEditingController _journalController = TextEditingController();
  final ScrollController _calendarScrollController = ScrollController();
  final ScrollController _recentMoodsScrollController = ScrollController();

  DateTime _selectedDate = DateTime.now();
  String? _selectedMood;
  bool _isJournalExpanded = false;
  bool _isSaving = false;
  bool _isLoadingMoods = false;
  List<Map<String, dynamic>> _recentMoods = [];
  int _currentOffset = 1;
  final int _limit = 5;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();

    // ✅ Status bar color same as header (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _selectedDate = DateTime.now();
    _loadRecentMoods();

    // Scroll to today after first layout
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToToday();
    });
  }

  @override
  void dispose() {
    // ✅ Reset status bar on leaving
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _journalController.dispose();
    _calendarScrollController.dispose();
    _recentMoodsScrollController.dispose();
    super.dispose();
  }

  void _scrollToToday() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _calendarScrollController.hasClients) {
        final screenWidth = MediaQuery.of(context).size.width;
        const itemWidth = 60.0 + 8.0; // item width + margin
        const todayIndex = 3.0;
        final scrollPosition =
            (todayIndex * itemWidth) - (screenWidth / 2) + (itemWidth / 2);

        _calendarScrollController.animateTo(
          scrollPosition.clamp(
            0.0,
            _calendarScrollController.position.maxScrollExtent,
          ),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  List<DateTime> _getDaysFromStart() {
    final now = DateTime.now();
    final days = <DateTime>[];

    for (int i = -3; i <= 3; i++) {
      days.add(now.add(Duration(days: i)));
    }
    return days;
  }

  String _formatMonthYear(DateTime date) {
    return DateFormat('MMM, yyyy', widget.locale.languageCode).format(date);
  }

  String _formatDayAbbreviation(DateTime date) {
    return DateFormat('E', widget.locale.languageCode).format(date);
  }

  String _formatDate(DateTime date) {
    return DateFormat('d MMM', widget.locale.languageCode).format(date);
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.day == now.day &&
        date.month == now.month &&
        date.year == now.year;
  }

  bool _isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.day == yesterday.day &&
        date.month == yesterday.month &&
        date.year == yesterday.year;
  }

  Future<void> _loadRecentMoods() async {
    setState(() {
      _isLoadingMoods = true;
    });

    final token = await AuthCacheService.getAuthToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isLoadingMoods = false;
      });
      return;
    }

    final todayIso = DateTime.now().toIso8601String();
    final result = await MoodApiService.getMoods(
      limit: _limit,
      offset: _currentOffset,
      date: todayIso,
      token: token,
    );

    if (!mounted) return;

    setState(() {
      if (result != null && result['data'] != null) {
        final moods = (result['data'] as List).cast<Map<String, dynamic>>();
        _recentMoods = moods;
        _hasMore = moods.length == _limit;
      }
      _isLoadingMoods = false;
    });
  }

  Future<void> _saveMood() async {
    if (_selectedMood == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.selectMood),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final token = await AuthCacheService.getAuthToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.moodSaveFailed),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    final moodApiFormat = MoodHelper.toApiFormat(_selectedMood!);
    final dateIso = _selectedDate.toIso8601String();
    final journalText = _journalController.text.trim();

    final success = await MoodApiService.updateMood(
      mood: moodApiFormat,
      modeDesc: journalText,
      date: dateIso,
      token: token,
    );

    if (!mounted) return;

    setState(() {
      _isSaving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.moodSaved),
          backgroundColor: AppColors.successGreen,
        ),
      );
      _loadRecentMoods();
      _selectedMood = null;
      _journalController.clear();
      _isJournalExpanded = false;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.moodSaveFailed),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // ✅ header will draw behind status bar
        bottom: true,
        child: Column(
          children: [
            // Header
            _buildHeader(localizations),
            // Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Month Display
                      Text(
                        _formatMonthYear(_selectedDate),
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Calendar Strip
                      _buildCalendarStrip(),
                      const SizedBox(height: 24),
                      // Mood Selection
                      Text(
                        localizations.howAreYouFeelingToday,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildMoodGrid(localizations),
                      const SizedBox(height: 24),
                      // Today's Journal
                      _buildJournalSection(localizations),
                      const SizedBox(height: 24),
                      // Recent Moods (only if there are moods)
                      if (_recentMoods.isNotEmpty) ...[
                        Text(
                          localizations.recentMoods,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildRecentMoodsList(localizations),
                        const SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            // Save Button
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                bottomPadding > 0 ? bottomPadding : 20,
              ),
              child: _buildSaveButton(localizations),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: statusBarHeight + 120, // ✅ covers status bar + header
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: statusBarHeight + 16, // content below status bar
      ),
      decoration: const BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                localizations.moodSelection,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarStrip() {
    final days = _getDaysFromStart();
    return SizedBox(
      height: 80,
      child: ListView.builder(
        controller: _calendarScrollController,
        scrollDirection: Axis.horizontal,
        itemCount: days.length,
        itemBuilder: (context, index) {
          final date = days[index];
          final isSelected = date.day == _selectedDate.day &&
              date.month == _selectedDate.month &&
              date.year == _selectedDate.year;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDate = date;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.only(right: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accentTeal : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected
                    ? null
                    : Border.all(
                  color: AppColors.colorShadow,
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatDayAbbreviation(date),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? AppColors.white
                          : AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildMoodGrid(AppLocalizations localizations) {
    final moods = MoodHelper.getAvailableMoods();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemCount: moods.length,
      itemBuilder: (context, index) {
        final mood = moods[index];
        final isSelected = _selectedMood == mood;
        final moodImagePath = MoodHelper.getMoodImagePath(mood);
        final moodColor = MoodHelper.getMoodColor(mood);
        final moodBorderColor = MoodHelper.getMoodBorderColor(mood);

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedMood = mood;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? moodColor : AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? moodBorderColor : AppColors.colorShadow,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (moodImagePath != null)
                  Image.asset(
                    moodImagePath,
                    width: 48,
                    height: 48,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.emoji_emotions_outlined,
                        size: 48,
                        color: isSelected
                            ? moodBorderColor
                            : AppColors.textPrimary,
                      );
                    },
                  )
                else
                  Icon(
                    Icons.emoji_emotions_outlined,
                    size: 48,
                    color: isSelected
                        ? moodBorderColor
                        : AppColors.textPrimary,
                  ),
                const SizedBox(height: 8),
                Text(
                  mood,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildJournalSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations.todaysJournal,
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            if (_isJournalExpanded)
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isJournalExpanded = false;
                    _journalController.clear();
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.colorShadow,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.close,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localizations.cancel,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isJournalExpanded = true;
                  });
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.accentTeal,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.edit,
                        size: 16,
                        color: AppColors.accentTeal,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localizations.write,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.accentTeal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (_isJournalExpanded)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.colorShadow,
                width: 1,
              ),
            ),
            child: TextField(
              controller: _journalController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: localizations.whatsInYourMindToday,
                hintStyle: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
              ),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textPrimary,
              ),
            ),
          )
        else
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomPaint(
              painter: DashedBorderPainter(),
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.edit,
                      size: 48,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localizations.tapWriteToAdd,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      localizations.expressYourThoughts,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildRecentMoodsList(AppLocalizations localizations) {
    return ListView.builder(
      controller: _recentMoodsScrollController,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _recentMoods.length,
      itemBuilder: (context, index) {
        final moodData = _recentMoods[index];
        final mood = moodData['mood'] as String? ?? '';
        final moodDesc = moodData['mood_desc'] as String? ?? '';
        final dateStr = moodData['date'] as String? ?? '';

        DateTime? date;
        try {
          date = DateTime.parse(dateStr);
        } catch (_) {
          date = null;
        }

        final displayMood = MoodHelper.toDisplayFormat(mood);
        final moodImagePath = MoodHelper.getMoodImagePath(mood);
        final moodColor = MoodHelper.getMoodColor(mood);

        String dateLabel;
        if (date != null && _isToday(date)) {
          dateLabel = localizations.today;
        } else if (date != null && _isYesterday(date)) {
          dateLabel = localizations.yesterday;
        } else if (date != null) {
          dateLabel = _formatDate(date);
        } else {
          dateLabel = dateStr;
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: moodColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              if (moodImagePath != null)
                Image.asset(
                  moodImagePath,
                  width: 40,
                  height: 40,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.emoji_emotions_outlined,
                      size: 40,
                      color: AppColors.textPrimary,
                    );
                  },
                )
              else
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: 40,
                  color: AppColors.textPrimary,
                ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dateLabel,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    if (moodDesc.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        moodDesc,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSaveButton(AppLocalizations localizations) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSaving ? null : _saveMood,
        style: ElevatedButton.styleFrom(
          backgroundColor: _selectedMood != null
              ? AppColors.accentTeal
              : AppColors.colorShadow,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isSaving
            ? const SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
          ),
        )
            : Text(
          localizations.saveTodaysMood,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

/// Custom painter for dashed border with rounded corners
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.colorShadow
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    const radius = 12.0;
    const dashWidth = 5.0;
    const dashSpace = 3.0;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          const Radius.circular(radius),
        ),
      );

    final dashPath = Path();
    final pathMetrics = path.computeMetrics();

    for (final pathMetric in pathMetrics) {
      var distance = 0.0;
      while (distance < pathMetric.length) {
        final remainingLength = pathMetric.length - distance;
        final currentDashLength =
        remainingLength < dashWidth ? remainingLength : dashWidth;

        final extractPath =
        pathMetric.extractPath(distance, distance + currentDashLength);
        dashPath.addPath(extractPath, Offset.zero);

        distance += currentDashLength + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
