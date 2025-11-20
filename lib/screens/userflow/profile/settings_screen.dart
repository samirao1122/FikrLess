import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_cache_service.dart';
import '../../../main.dart';
import '../../../route.dart';
import 'personal_details_screen.dart';
import '../../before_login_signup/get_started_screen.dart' as before_login;

class SettingsScreen extends StatefulWidget {
  final Locale locale;

  const SettingsScreen({super.key, required this.locale});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    _loadLanguage();
    
    // Set status bar to match header color (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
  }

  @override
  void dispose() {
    // Reset status bar when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    super.dispose();
  }

  Future<void> _loadLanguage() async {
    final savedLang = await AuthCacheService.getLanguage();
    setState(() {
      _selectedLanguage = savedLang;
    });
  }

  Future<void> _changeLanguage(String languageCode) async {
    if (_selectedLanguage == languageCode) return;

    await AuthCacheService.saveLanguage(languageCode);
    setState(() {
      _selectedLanguage = languageCode;
    });
    
    // Update locale in main app
    if (mounted) {
      final newLocale = Locale(languageCode);
      final appState = MyAppState.of(context);
      if (appState != null) {
        appState.updateLocale(newLocale);
        // Navigate back to home to see changes
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        // Fallback: show message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.languageChanged),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildHeader(localizations, statusBarHeight),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding > 0 ? bottomPadding : 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSection(
                      localizations.accountSettings,
                      [
                        _buildSettingItem(
                          localizations.personalDetails,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PersonalDetailsScreen(
                                  locale: widget.locale,
                                ),
                              ),
                            );
                          },
                        ),
                        _buildSettingItem(
                          localizations.changePhoneNumber,
                          onTap: () {
                            // TODO: Navigate to change phone number
                          },
                        ),
                        _buildSettingItem(
                          localizations.changePassword,
                          onTap: () {
                            // TODO: Navigate to change password
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildLogoutButton(localizations),
                    const SizedBox(height: 24),
                    _buildSection(
                      localizations.appSetting,
                      [
                        _buildLanguageSelector(localizations),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      localizations.legal,
                      [
                        _buildSettingItem(
                          localizations.privacyPolicy,
                          onTap: () {
                            // TODO: Navigate to privacy policy
                          },
                        ),
                        _buildSettingItem(
                          localizations.termsOfUse,
                          onTap: () {
                            // TODO: Navigate to terms of use
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSection(
                      localizations.helpAndSupport,
                      [
                        _buildSettingItem(
                          localizations.customerSupport,
                          onTap: () {
                            // TODO: Navigate to customer support
                          },
                        ),
                        _buildSettingItem(
                          localizations.faqs,
                          onTap: () {
                            // TODO: Navigate to FAQs
                          },
                        ),
                        _buildSettingItem(
                          localizations.rateUs,
                          onTap: () {
                            // TODO: Navigate to rate us
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations localizations, double statusBarHeight) {
    return Container(
      width: double.infinity,
      height: statusBarHeight + 120,
      decoration: const BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: statusBarHeight + 16,
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
                localizations.settings,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              const SizedBox(width: 48), // Balance the back button
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }

  Widget _buildSettingItem(
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: trailing ?? const Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: AppColors.textSecondary,
        ),
        onTap: onTap,
      ),
    );
  }

  Widget _buildLanguageSelector(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          localizations.language,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.textPrimary,
          ),
        ),
        trailing: DropdownButton<String>(
          value: _selectedLanguage,
          underline: Container(),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColors.textSecondary,
          ),
          items: [
            DropdownMenuItem(
              value: 'en',
              child: Text(
                'English',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'ur',
              child: Text(
                'Urdu',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              _changeLanguage(value);
            }
          },
        ),
      ),
    );
  }

  Widget _buildLogoutButton(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorShadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        title: Text(
          'Logout',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: AppColors.errorRed,
          ),
        ),
        trailing: const Icon(
          Icons.logout,
          size: 20,
          color: AppColors.errorRed,
        ),
        onTap: () async {
          // Show confirmation dialog
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                'Logout',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              content: Text(
                'Are you sure you want to logout?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textSecondary,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    'Logout',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.errorRed,
                    ),
                  ),
                ),
              ],
            ),
          );

          if (shouldLogout == true && mounted) {
            // Clear all cached data
            await AuthCacheService.clearLoginData();
            await AuthCacheService.clearUserImage();
            
            // Navigate to get started screen
            if (mounted) {
              final savedLang = await AuthCacheService.getLanguage();
              final locale = Locale(savedLang);
              
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (_) => before_login.BeforeLogin(locale: locale),
                ),
                (route) => false,
              );
            }
          }
        },
      ),
    );
  }
}

