import 'dart:ui';
import 'package:flutter/material.dart';
import '../../auth/login/login_screen.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class EducationCertificationsScreen extends StatefulWidget {
  final Locale locale; // ✅ Accept locale from previous screen

  const EducationCertificationsScreen({super.key, required this.locale});

  @override
  State<EducationCertificationsScreen> createState() =>
      _EducationCertificationsScreenState();
}

class _EducationCertificationsScreenState
    extends State<EducationCertificationsScreen> {
  List<Map<String, String>> educationList = [
    {'degree': '', 'institute': ''},
  ];

  List<Map<String, String>> certificationList = [
    {'certTitle': '', 'provider': ''},
  ];

  @override
  Widget build(BuildContext context) {
    // ✅ Override localization using passed locale
    return Localizations.override(
      context: context,
      locale: widget.locale,
      child: Builder(
        builder: (context) {
          final loc = AppLocalizations.of(context)!;

          // ✅ Explicit Directionality for RTL/LTR
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
                                                'institute': '',
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
                                                'certTitle': '',
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

                                        // Login Button
                                        _buildLoginButton(context, loc),
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
                  onChanged: (val) => list[i][list[i].keys.elementAt(j)] = val,
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

  Widget _buildLoginButton(BuildContext context, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginScreen(locale: widget.locale),
            ), // ✅ pass locale
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
        ),
        child: Text(
          loc.loginButton,
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
}
