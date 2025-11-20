import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_cache_service.dart';
import '../../../main.dart';

class SpecialistSettingsScreen extends StatefulWidget {
  final Locale locale;

  const SpecialistSettingsScreen({super.key, required this.locale});

  @override
  State<SpecialistSettingsScreen> createState() => _SpecialistSettingsScreenState();
}

class _SpecialistSettingsScreenState extends State<SpecialistSettingsScreen> {
  bool _emailNotifications = true;
  bool _smsNotifications = false;
  bool _appointmentReminders = true;
  bool _paymentNotifications = false;
  String _licenseNumber = 'PSY - 2024 - 1002345';
  bool _isVerified = true;
  String _selectedLanguage = 'en';

  @override
  void initState() {
    super.initState();
    
    // Set status bar to match header color (teal)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    _loadLanguage();
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
        // Navigate back to refresh UI
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)?.languageChanged ?? 'Language changed'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final statusBarHeight = MediaQuery.of(context).padding.top;
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    // Get current locale from app state (updates when language changes)
    final currentLocale = Localizations.localeOf(context);
    
    return Localizations.override(
      context: context,
      locale: currentLocale,
      child: Directionality(
        textDirection: currentLocale.languageCode == 'ur' ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
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
                        // Notification Settings
                        _buildSection(
                          title: localizations?.notificationSettings ?? 'Notification Settings',
                          children: [
                            _buildSwitchTile(
                              title: localizations?.emailNotifications ?? 'Email notifications',
                              subtitle: localizations?.receiveNotificationsViaEmail ?? 'Receive notifications via email',
                              value: _emailNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _emailNotifications = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              title: localizations?.smsNotifications ?? 'SMS notifications',
                              subtitle: localizations?.receiveNotificationsViaSMS ?? 'Receive notifications via SMS',
                              value: _smsNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _smsNotifications = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              title: localizations?.appointmentReminders ?? 'Appointment reminders',
                              subtitle: localizations?.getRemindersForUpcomingSessions ?? 'Get reminders for upcoming sessions',
                              value: _appointmentReminders,
                              onChanged: (value) {
                                setState(() {
                                  _appointmentReminders = value;
                                });
                              },
                            ),
                            _buildSwitchTile(
                              title: localizations?.paymentNotifications ?? 'Payment notifications',
                              subtitle: localizations?.getNotifiedAboutPaymentsReceived ?? 'Get notified about payments received',
                              value: _paymentNotifications,
                              onChanged: (value) {
                                setState(() {
                                  _paymentNotifications = value;
                                });
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Professional Status
                        _buildSection(
                          title: localizations?.professionalStatus ?? 'Professional Status',
                          children: [
                            _buildInfoTile(
                              title: localizations?.verificationStatus ?? 'Verification Status',
                              subtitle: localizations?.yourProfessionalCredentials ?? 'Your professional credentials',
                              trailing: _isVerified
                                  ? Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.accentTeal,
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(Icons.check, color: AppColors.white, size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            localizations?.verified ?? 'Verified',
                                            style: GoogleFonts.poppins(
                                              color: AppColors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : null,
                            ),
                            _buildInfoTile(
                              title: localizations?.licenseNumber ?? 'License Number',
                              subtitle: _licenseNumber,
                              trailing: null,
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // App Setting
                        _buildSection(
                          title: localizations?.appSetting ?? 'App Setting',
                          children: [
                            _buildLanguageSelector(),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Legal
                        _buildSection(
                          title: localizations?.legal ?? 'Legal',
                          children: [
                            _buildNavigationTile(
                              title: localizations?.privacyPolicy ?? 'Privacy Policy',
                              onTap: () {
                                // TODO: Navigate to privacy policy
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Privacy Policy coming soon')),
                                );
                              },
                            ),
                            _buildNavigationTile(
                              title: localizations?.termsOfUse ?? 'Terms of Use',
                              onTap: () {
                                // TODO: Navigate to terms of use
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Terms of Use coming soon')),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Help and Support
                        _buildSection(
                          title: localizations?.helpAndSupport ?? 'Help and Support',
                          children: [
                            _buildNavigationTile(
                              title: localizations?.customerSupport ?? 'Customer Support',
                              onTap: () {
                                // TODO: Navigate to customer support
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Customer Support coming soon')),
                                );
                              },
                            ),
                            _buildNavigationTile(
                              title: localizations?.faqs ?? 'FAQs',
                              onTap: () {
                                // TODO: Navigate to FAQs
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('FAQs coming soon')),
                                );
                              },
                            ),
                            _buildNavigationTile(
                              title: localizations?.rateUs ?? 'Rate Us',
                              onTap: () {
                                // TODO: Open app store rating
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Rate Us coming soon')),
                                );
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Others
                        _buildSection(
                          title: localizations?.others ?? 'Others',
                          children: [
                            _buildNavigationTile(
                              title: localizations?.deleteMyAccount ?? 'Delete My Account',
                              titleColor: AppColors.errorRed,
                              onTap: () {
                                _showDeleteAccountDialog();
                              },
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppLocalizations? localizations, double statusBarHeight) {
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
                localizations?.settings ?? 'Settings',
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

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Container(
          color: AppColors.white,
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.accentTeal,
      ),
    );
  }

  Widget _buildInfoTile({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
      ),
      trailing: trailing,
    );
  }

  Widget _buildNavigationTile({
    required String title,
    String? subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: titleColor ?? AppColors.textPrimary,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            )
          : null,
      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
      onTap: onTap,
    );
  }

  Widget _buildLanguageSelector() {
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
          'Language',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
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
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            DropdownMenuItem(
              value: 'ur',
              child: Text(
                'Urdu',
                style: GoogleFonts.poppins(
                  fontSize: 14,
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
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
          dropdownColor: AppColors.white,
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Implement account deletion
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Account deletion coming soon')),
              );
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(color: AppColors.errorRed),
            ),
          ),
        ],
      ),
    );
  }
}

