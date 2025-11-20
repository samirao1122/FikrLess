import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_cache_service.dart';
import 'edit_specialist_profile_screen.dart';
import '../settings/specialist_settings_screen.dart';

class SpecialistProfileScreen extends StatefulWidget {
  final Locale locale;

  const SpecialistProfileScreen({super.key, required this.locale});

  @override
  State<SpecialistProfileScreen> createState() => _SpecialistProfileScreenState();
}

class _SpecialistProfileScreenState extends State<SpecialistProfileScreen> {
  Map<String, dynamic>? _profileData;
  bool _isLoading = true;
  String? _error;
  Uint8List? _profileImageBytes;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to match header color (teal)
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    
    _loadProfile();
  }

  @override
  void dispose() {
    // Reset status bar when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) {
        setState(() {
          _error = 'Authentication token not found';
          _isLoading = false;
        });
        return;
      }

      final response = await SpecialistApiService.getSpecialistProfile(token: token);
      
      if (response != null && response['success'] == true) {
        final data = response['data'] as Map<String, dynamic>?;
        if (data != null) {
          setState(() {
            _profileData = data;
            _loadProfileImage(data['profile_photo'] as String?);
            _isLoading = false;
          });
        } else {
          setState(() {
            _error = 'Profile data not found';
            _isLoading = false;
          });
        }
      } else {
        setState(() {
          _error = 'Failed to load profile';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Error loading profile: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _loadProfileImage(String? imageData) async {
    if (imageData == null || imageData.isEmpty) return;

    try {
      if (imageData.startsWith('data:image')) {
        // Base64 image - save to cache
        await AuthCacheService.saveUserImage(imageData);
        final base64String = imageData.contains(',') 
            ? imageData.split(',')[1] 
            : imageData;
        final bytes = base64Decode(base64String);
        setState(() {
          _profileImageBytes = bytes;
        });
      } else if (imageData.startsWith('http')) {
        // URL image - fetch from URL and convert to base64
        try {
          final response = await http.get(Uri.parse(imageData));
          if (response.statusCode == 200) {
            final base64Image = 'data:image/jpeg;base64,${base64Encode(response.bodyBytes)}';
            await AuthCacheService.saveUserImage(base64Image);
            setState(() {
              _profileImageBytes = response.bodyBytes;
            });
          }
        } catch (e) {
          print('Error loading image from URL: $e');
        }
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  String _getInitials(String? name) {
    if (name == null || name.isEmpty) return '??';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[parts.length - 1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '??';
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? _buildErrorState()
                    : _buildProfileContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: AppColors.errorRed),
          const SizedBox(height: 16),
          Text(
            _error ?? 'Unknown error',
            style: GoogleFonts.poppins(color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _loadProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accentTeal,
            ),
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(color: AppColors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    if (_profileData == null) return const SizedBox();

    final basicInfo = _profileData!['basic_info'] as Map<String, dynamic>? ?? {};
    final fullName = basicInfo['full_name'] as String? ?? _profileData!['full_name'] as String? ?? 'Specialist';
    final designation = basicInfo['designation'] as String? ?? _profileData!['designation'] as String? ?? '';
    final location = basicInfo['location'] as String? ?? _profileData!['location'] as String? ?? '--';
    final hourlyRate = basicInfo['hourly_rate'] as int? ?? _profileData!['hourly_rate'] as int?;
    final currency = basicInfo['currency'] as String? ?? _profileData!['currency'] as String? ?? 'PKR';
    
    // Handle rating as both int and double
    double rating = 0.0;
    final ratingValue = basicInfo['rating'] ?? _profileData!['rating'];
    if (ratingValue != null) {
      if (ratingValue is int) {
        rating = ratingValue.toDouble();
      } else if (ratingValue is double) {
        rating = ratingValue;
      }
    }
    final specializations = basicInfo['specializations'] as List<dynamic>? ?? _profileData!['specializations'] as List<dynamic>? ?? [];
    final languages = basicInfo['languages'] as List<dynamic>? ?? _profileData!['languages'] as List<dynamic>? ?? [];
    final education = _profileData!['education'] as List<dynamic>? ?? [];
    final certifications = _profileData!['certifications'] as List<dynamic>? ?? [];
    final isVerified = _profileData!['is_verified'] as bool? ?? false;
    final about = basicInfo['about'] as String? ?? '';

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with teal background
          _buildHeader(fullName, designation, isVerified),
          
          // Main content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overview Section
                _buildOverviewSection(rating, location, hourlyRate, currency),
                const SizedBox(height: 24),
                
                // About Section
                if (about.isNotEmpty) ...[
                  _buildAboutSection(about),
                  const SizedBox(height: 24),
                ],
                
                // Specializations Section
                _buildSpecializationsSection(specializations),
                const SizedBox(height: 24),
                
                // Languages Section
                _buildLanguagesSection(languages),
                const SizedBox(height: 24),
                
                // Education & Certifications Section
                _buildEducationCertificationsSection(education, certifications),
                const SizedBox(height: 24),
                
                // Log out button
                _buildLogoutButton(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(String fullName, String designation, bool isVerified) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.accentTeal,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Column(
        children: [
          // Top bar with back and settings
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () => Navigator.pop(context),
              ),
              Text(
                AppLocalizations.of(context)?.profile ?? 'Profile',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.settings, color: AppColors.white),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SpecialistSettingsScreen(locale: Localizations.localeOf(context)),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Profile picture
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.white, width: 4),
                  color: AppColors.white,
                ),
                child: _profileImageBytes != null
                    ? ClipOval(
                        child: Image.memory(
                          _profileImageBytes!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.white,
                        ),
                        child: Center(
                          child: Text(
                            _getInitials(fullName),
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.w600,
                              color: AppColors.accentTeal,
                            ),
                          ),
                        ),
                      ),
              ),
              if (isVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.fromBorderSide(
                        BorderSide(color: AppColors.white, width: 2),
                      ),
                    ),
                    child: const Icon(
                      Icons.check,
                      color: AppColors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Name and designation
          Text(
            fullName,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          if (designation.isNotEmpty)
            Text(
              designation,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.white,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildOverviewSection(double rating, String location, int? hourlyRate, String currency) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              localizations?.overview ?? 'Overview',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditSpecialistProfileScreen(
                      locale: Localizations.localeOf(context),
                      profileData: _profileData,
                      onProfileUpdated: _loadProfile,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.edit, size: 16, color: AppColors.accentTeal),
              label: Text(
                localizations?.editProfile ?? 'Edit Profile',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.accentTeal,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            children: [
              _buildOverviewRow(localizations?.ratings ?? 'Ratings', rating.toStringAsFixed(1)),
              const Divider(),
              _buildOverviewRow(localizations?.locationLabel ?? 'Location', location),
              const Divider(),
              _buildOverviewRow(
                localizations?.hourlyRate ?? 'Hourly Rate',
                hourlyRate != null ? '$currency $hourlyRate' : '--',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection(String about) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.about ?? 'About',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (about.isEmpty)
          _buildEmptyState(localizations?.addAboutYourself ?? 'Add About Yourself', Icons.edit)
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
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
            child: Text(
              about,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.textPrimary,
                height: 1.5,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSpecializationsSection(List<dynamic> specializations) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.specializations ?? 'Specializations',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (specializations.isEmpty)
          _buildEmptyState(localizations?.addSpecialization ?? 'Add Specializations', Icons.add_circle_outline)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: specializations.map((spec) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.icyWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
                ),
                child: Text(
                  spec.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildLanguagesSection(List<dynamic> languages) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.language ?? 'Languages',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        if (languages.isEmpty)
          _buildEmptyState(localizations?.addLanguage ?? 'Add Languages', Icons.add_circle_outline)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: languages.map((lang) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.icyWhite,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.accentTeal.withOpacity(0.3)),
                ),
                child: Text(
                  lang.toString(),
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildEducationCertificationsSection(List<dynamic> education, List<dynamic> certifications) {
    final localizations = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localizations?.educationCertificationsTitle ?? 'Education & Certifications',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (education.isNotEmpty) ...[
                Text(
                  localizations?.education ?? 'Education',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...education.map((edu) {
                  final eduMap = edu as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                        Expanded(
                          child: Text(
                            '${eduMap['degree'] ?? ''} - ${eduMap['institute_name'] ?? ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                if (certifications.isNotEmpty) const SizedBox(height: 16),
              ],
              if (certifications.isNotEmpty) ...[
                Text(
                  localizations?.certifications ?? 'Certifications',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                ...certifications.map((cert) {
                  final certMap = cert as Map<String, dynamic>;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 16, color: AppColors.textPrimary)),
                        Expanded(
                          child: Text(
                            '${certMap['certificate_title'] ?? certMap['certification'] ?? certMap['name'] ?? ''}${certMap['provider'] != null ? ' - ${certMap['provider']}' : ''}',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
              if (education.isEmpty && certifications.isEmpty)
                _buildEmptyState(localizations?.addEducationCertifications ?? 'Add Education & Certifications', Icons.add_circle_outline),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String text, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(
          color: AppColors.borderGrey300,
          style: BorderStyle.solid,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 20),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    final localizations = AppLocalizations.of(context);
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          final shouldLogout = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                localizations?.logOut ?? 'Log out',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              content: Text(
                localizations?.logoutConfirm ?? 'Are you sure you want to log out?',
                style: GoogleFonts.poppins(),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(localizations?.cancelButton ?? 'Cancel', style: GoogleFonts.poppins()),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(
                    localizations?.yes ?? 'Log out',
                    style: GoogleFonts.poppins(color: AppColors.errorRed),
                  ),
                ),
              ],
            ),
          );

          if (shouldLogout == true) {
            await AuthCacheService.clearLoginData();
            if (mounted) {
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.errorRed,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          localizations?.logOut ?? 'Log out',
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

