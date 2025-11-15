import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import '../../utils/mood_helper.dart';

class MoodSelectionScreen extends StatefulWidget {
  final Locale locale;

  const MoodSelectionScreen({super.key, required this.locale});

  @override
  State<MoodSelectionScreen> createState() => _MoodSelectionScreenState();
}

class _MoodSelectionScreenState extends State<MoodSelectionScreen> {
  String? _selectedMood;
  bool _isSubmitting = false;

  // Get 6 main mood
  final List<String> _moods = MoodHelper.getAvailableMoods();

  Future<void> _submitMood() async {
    if (_selectedMood == null) return;

    setState(() {
      _isSubmitting = true;
    });

    // Get token from cache
    final token = await AuthCacheService.getAuthToken();
    final success = await MoodApiService.submitMood(
      mood: _selectedMood!,
      token: token,
    );

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.moodSubmitted),
            backgroundColor: AppColors.successGreen,
          ),
        );
        Navigator.pop(context, _selectedMood);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.moodSubmitFailed),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.moodSelection,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.selectMood,
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _moods.length,
              itemBuilder: (context, index) {
                final mood = _moods[index];
                final isSelected = _selectedMood == mood;
                final moodImagePath = MoodHelper.getMoodImagePath(mood);

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedMood = mood;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.accentTeal : AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.accentTeal
                            : AppColors.borderGrey300,
                        width: 2,
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
                                    ? AppColors.white
                                    : AppColors.textPrimary,
                              );
                            },
                          )
                        else
                          Icon(
                            Icons.emoji_emotions_outlined,
                            size: 48,
                            color: isSelected
                                ? AppColors.white
                                : AppColors.textPrimary,
                          ),
                        const SizedBox(height: 8),
                        Text(
                          mood,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
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
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedMood != null && !_isSubmitting
                    ? _submitMood
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTeal,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                        ),
                      )
                    : Text(
                        localizations.submit,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

