import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/auth_cache_service.dart';

class PersonalDetailsScreen extends StatefulWidget {
  final Locale locale;

  const PersonalDetailsScreen({super.key, required this.locale});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  String _userId = 'User_Id1234';
  String _email = 'user@email.com';
  String? _cachedImageBase64;
  Uint8List? _cachedImageBytes;

  @override
  void initState() {
    super.initState();
    
    // Set status bar to match header color (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );
    
    _loadUserData();
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

  Future<void> _loadUserData() async {
    final userData = await AuthCacheService.getUserData();
    final cachedImage = await AuthCacheService.getUserImage();
    
    if (mounted) {
      setState(() {
        _userId = userData['userId'] ?? 'User_Id1234';
        _email = userData['email'] ?? 'user@email.com';
        
        if (cachedImage != null && cachedImage != _cachedImageBase64) {
          _cachedImageBase64 = cachedImage;
          try {
            final imageData = cachedImage.contains(',')
                ? cachedImage.split(',')[1]
                : cachedImage;
            _cachedImageBytes = base64Decode(imageData);
          } catch (e) {
            _cachedImageBytes = null;
          }
        }
      });
    }
  }

  String _getInitials(String name) {
    if (name.isEmpty) return 'OR';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return (parts[0][0] + parts[1][0]).toUpperCase();
    } else if (parts.length == 1 && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return 'OR';
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
                padding: EdgeInsets.fromLTRB(16, 24, 16, bottomPadding > 0 ? bottomPadding : 16),
                child: Column(
                  children: [
                    // Profile Avatar Section
                    _buildProfileSection(),
                    const SizedBox(height: 32),
                    
                    // Personal Information Section
                    _buildPersonalInformationSection(localizations),
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
                localizations.personalDetails,
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

  Widget _buildProfileSection() {
    return Column(
      children: [
        // Avatar
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.backgroundGrey100,
          ),
          child: _cachedImageBytes != null
              ? ClipOval(
                  child: Image.memory(
                    _cachedImageBytes!,
                    fit: BoxFit.cover,
                    width: 80,
                    height: 80,
                    errorBuilder: (context, error, stackTrace) {
                      return Center(
                        child: Text(
                          _getInitials(_userId),
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textGrey700,
                          ),
                        ),
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    _getInitials(_userId),
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textGrey700,
                    ),
                  ),
                ),
        ),
        const SizedBox(height: 16),
        // User ID
        Text(
          _userId,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        // Member Since
        Text(
          'Member Since 15 Feb, 2025',
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildPersonalInformationSection(AppLocalizations localizations) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personal Information',
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 16),
        // User ID Field
        _buildInfoField(
          label: 'User ID',
          value: _userId,
        ),
        const SizedBox(height: 16),
        // Email Field
        _buildInfoField(
          label: 'Email',
          value: _email,
        ),
      ],
    );
  }

  Widget _buildInfoField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.backgroundGrey100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.borderGrey300,
              width: 1,
            ),
          ),
          child: Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.textGrey700,
            ),
          ),
        ),
      ],
    );
  }
}

