import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../auth/login/login_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';

class EducationCertificationsScreen extends StatefulWidget {
  final Locale locale;
  final String token;

  const EducationCertificationsScreen({
    super.key,
    required this.locale,
    required this.token,
  });

  @override
  State<EducationCertificationsScreen> createState() =>
      _EducationCertificationsScreenState();
}

class _EducationCertificationsScreenState
    extends State<EducationCertificationsScreen> {
  List<Map<String, String>> educationList = [
    {'degree': '', 'institute_name': ''},
  ];

  List<Map<String, String>> certificationList = [
    {'certificate_title': '', 'provider': ''},
  ];

  bool _isLoading = false;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          return Directionality(
            textDirection: widget.locale.languageCode == 'ur'
                ? TextDirection.rtl
                : TextDirection.ltr,
            child: Scaffold(
              extendBodyBehindAppBar: true,
              backgroundColor: AppColors.backgroundWhite,
              body: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gradientBottom,
                          AppColors.gradientTop,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Foreground content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Back Button
                          ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.cardWhite25,
                                  border: Border.all(
                                    color: AppColors.cardWhite50,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.shadowLight,
                                      blurRadius: 10,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: IconButton(
                                  onPressed: () => Navigator.pop(context),
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                  ),
                                  color: AppColors.primaryDarkBlue,
                                  iconSize: 24,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          // Page Title
                          Text(
                            loc.educationCertificationsTitle,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 13),

                          // Glass Card Container
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(25),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 20,
                                  sigmaY: 20,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: AppColors.cardWhite70,
                                    borderRadius: BorderRadius.circular(25),
                                    border: Border.all(
                                      color: AppColors.cardBorderWhite40,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.shadowLight,
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Education Section
                                        _buildSectionTitle(
                                          "🎓 ${loc.educationSectionTitle}",
                                        ),
                                        const SizedBox(height: 7),
                                        ..._buildDynamicSection(
                                          context,
                                          educationList,
                                          [
                                            loc.educationFieldDegree,
                                            loc.educationFieldInstitute,
                                          ],
                                          onAdd: () {
                                            setState(() {
                                              educationList.add({
                                                'degree': '',
                                                'institute_name': '',
                                              });
                                            });
                                          },
                                          onRemove: (index) {
                                            setState(() {
                                              educationList.removeAt(index);
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 5),

                                        // Certifications Section
                                        _buildSectionTitle(
                                          "📜 ${loc.certificationsSectionTitle}",
                                        ),
                                        const SizedBox(height: 10),
                                        ..._buildDynamicSection(
                                          context,
                                          certificationList,
                                          [
                                            loc.certificationFieldTitle,
                                            loc.certificationFieldProvider,
                                          ],
                                          onAdd: () {
                                            setState(() {
                                              certificationList.add({
                                                'certificate_title': '',
                                                'provider': '',
                                              });
                                            });
                                          },
                                          onRemove: (index) {
                                            setState(() {
                                              certificationList.removeAt(index);
                                            });
                                          },
                                        ),
                                        const SizedBox(height: 10),

                                        // Submit Button
                                        _buildSubmitButton(context, loc),
                                        const SizedBox(height: 15),

                                        // Progress Bar
                                        _buildProgressBar(context, 1.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  // ----------------- UI Components -----------------
  Widget _buildSectionTitle(String title) => Text(
        title,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.w600,
          color: AppColors.primaryDarkBlue,
        ),
      );

  List<Widget> _buildDynamicSection(
    BuildContext context,
    List<Map<String, String>> list,
    List<String> fields, {
    required VoidCallback onAdd,
    required Function(int) onRemove,
  }) {
    final loc = AppLocalizations.of(context)!;

    return [
      for (int i = 0; i < list.length; i++) ...[
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.only(bottom: 18),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.cardWhite85,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderGrey300),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (int j = 0; j < fields.length; j++) ...[
                Text(
                  fields[j],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryDarkBlue,
                  ),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: TextEditingController(
                    text: list[i][list[i].keys.elementAt(j)] ?? '',
                  ),
                  onChanged: (val) =>
                      list[i][list[i].keys.elementAt(j)] = val,
                  decoration: InputDecoration(
                    hintText: "${loc.addDialogHint} ${fields[j].toLowerCase()}",
                    filled: true,
                    fillColor: AppColors.backgroundWhite.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.borderGrey300),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
              ],
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () => onRemove(i),
                  icon: const Icon(
                    Icons.delete_outline,
                    color: AppColors.errorRed,
                  ),
                  label: Text(
                    loc.removeButton,
                    style: const TextStyle(color: AppColors.errorRed),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
      GestureDetector(
        onTap: onAdd,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(Icons.add_circle, color: AppColors.primary),
            const SizedBox(width: 6),
            Text(
              loc.addMoreButton,
              style: const TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    ];
  }

  Widget _buildSubmitButton(BuildContext context, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : () => _submitProfile(context, loc),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: _isSubmitting
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.white,
                ),
              )
            : Text(
                "Submit Profile",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context, double progress) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: LinearProgressIndicator(
        value: progress,
        backgroundColor: AppColors.progressBackground,
        color: AppColors.progressPrimary,
        minHeight: 5,
      ),
    );
  }

  Future<void> _submitProfile(
      BuildContext context, AppLocalizations loc) async {
    setState(() => _isSubmitting = true);

    try {
      // Get cached basic info
      final prefs = await SharedPreferences.getInstance();
      final basicInfoJson = prefs.getString('specialist_basic_info');

      if (basicInfoJson == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Basic information not found. Please go back and fill the form.'),
              backgroundColor: AppColors.errorRed,
            ),
          );
        }
        setState(() => _isSubmitting = false);
        return;
      }

      final basicInfoMap = jsonDecode(basicInfoJson) as Map<String, dynamic>;

      // Prepare education list (filter out empty entries)
      final education = educationList
          .where((edu) =>
              (edu['degree']?.trim().isNotEmpty ?? false) &&
              (edu['institute_name']?.trim().isNotEmpty ?? false))
          .map((edu) => <String, dynamic>{
                'degree': edu['degree']?.trim() ?? '',
                'institute_name': edu['institute_name']?.trim() ?? '',
              })
          .toList();

      // Prepare certifications list (filter out empty entries)
      final certifications = certificationList
          .where((cert) =>
              (cert['certificate_title']?.trim().isNotEmpty ?? false) &&
              (cert['provider']?.trim().isNotEmpty ?? false))
          .map((cert) => <String, dynamic>{
                'certificate_title': cert['certificate_title']?.trim() ?? '',
                'provider': cert['provider']?.trim() ?? '',
              })
          .toList();

      // Prepare basic_info payload
      final basicInfo = {
        'full_name': basicInfoMap['full_name'] ?? '',
        'designation': basicInfoMap['designation'] ?? '',
        'location': basicInfoMap['location'] ?? '',
        'hourly_rate': basicInfoMap['hourly_rate'] ?? 500,
        'currency': basicInfoMap['currency'] ?? 'PKR',
        'specializations': basicInfoMap['specializations'] ?? [],
        'languages': basicInfoMap['languages'] ?? [],
        'categories': basicInfoMap['categories'] ?? [],
        'experience_years': basicInfoMap['experience_years'] ?? 0,
        // For now, send empty string for profile_photo URL
        // If backend requires image upload first, we'll need to handle that separately
        'profile_photo': basicInfoMap['profile_photo_base64']?.toString().isNotEmpty == true
            ? 'data:image/jpeg;base64,${basicInfoMap['profile_photo_base64']}'
            : '',
      };

      // Make API call
      final response = await SpecialistApiService.createSpecialistProfile(
        basicInfo: basicInfo,
        education: education.isNotEmpty ? education : null,
        certifications: certifications.isNotEmpty ? certifications : null,
        token: widget.token,
      );

      setState(() => _isSubmitting = false);

      if (response != null && response['error'] == null) {
        // Clear cached data
        await prefs.remove('specialist_basic_info');

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile created successfully!'),
              backgroundColor: AppColors.successGreen,
              duration: Duration(seconds: 2),
            ),
          );

          // Navigate to login screen
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(locale: widget.locale),
            ),
            (route) => false,
          );
        }
      } else {
        String errorMessage = 'Failed to create profile. Please try again.';
        if (response != null && response['error'] != null) {
          try {
            final errorData = jsonDecode(response['error']);
            errorMessage = errorData['message'] ?? errorData['error'] ?? errorMessage;
          } catch (e) {
            errorMessage = response['error'].toString();
          }
        }
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: AppColors.errorRed,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }
}
