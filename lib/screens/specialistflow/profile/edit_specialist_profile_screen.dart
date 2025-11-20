import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_cache_service.dart';

class EditSpecialistProfileScreen extends StatefulWidget {
  final Locale locale;
  final Map<String, dynamic>? profileData;
  final VoidCallback onProfileUpdated;

  const EditSpecialistProfileScreen({
    super.key,
    required this.locale,
    this.profileData,
    required this.onProfileUpdated,
  });

  @override
  State<EditSpecialistProfileScreen> createState() => _EditSpecialistProfileScreenState();
}

class _EditSpecialistProfileScreenState extends State<EditSpecialistProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final ImagePicker _imagePicker = ImagePicker();
  Uint8List? _profileImageBytes;
  String? _profileImageBase64;

  // Form controllers
  late TextEditingController _fullNameController;
  late TextEditingController _designationController;
  late TextEditingController _aboutController;
  late TextEditingController _hourlyRateController;

  // Dropdowns
  String _selectedLocation = 'Karachi, Pakistan';
  String _selectedCurrency = 'PKR';

  // Lists
  List<String> _specializations = [];
  List<String> _languages = [];
  List<Map<String, TextEditingController>> _educationList = [];
  List<Map<String, TextEditingController>> _certificationsList = [];

  // Common locations and currencies
  final List<String> _locations = [
    'Karachi, Pakistan',
    'Lahore, Pakistan',
    'Islamabad, Pakistan',
    'Rawalpindi, Pakistan',
    'Faisalabad, Pakistan',
  ];

  final List<String> _currencies = ['PKR', 'USD', 'EUR', 'GBP'];

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
    final basicInfo = widget.profileData?['basic_info'] as Map<String, dynamic>? ?? {};
    final education = widget.profileData?['education'] as List<dynamic>? ?? [];
    final certifications = widget.profileData?['certifications'] as List<dynamic>? ?? [];

    _fullNameController = TextEditingController(text: basicInfo['full_name'] as String? ?? '');
    _designationController = TextEditingController(text: basicInfo['designation'] as String? ?? '');
    _aboutController = TextEditingController(text: basicInfo['about'] as String? ?? '');
    _hourlyRateController = TextEditingController(text: (basicInfo['hourly_rate'] as int?)?.toString() ?? '');
    _selectedLocation = basicInfo['location'] as String? ?? 'Karachi, Pakistan';
    _selectedCurrency = basicInfo['currency'] as String? ?? 'PKR';
    _specializations = (basicInfo['specializations'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    _languages = (basicInfo['languages'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];

    // Load education
    _educationList = education.map((e) {
      final edu = e as Map<String, dynamic>;
      return {
        'degree': TextEditingController(text: edu['degree']?.toString() ?? ''),
        'institute': TextEditingController(text: edu['institute_name']?.toString() ?? ''),
      };
    }).toList();
    if (_educationList.isEmpty) {
      _educationList.add({
        'degree': TextEditingController(),
        'institute': TextEditingController(),
      });
    }

    // Load certifications
    _certificationsList = certifications.map((e) {
      final cert = e as Map<String, dynamic>;
      return {
        'title': TextEditingController(text: cert['certification']?.toString() ?? cert['name']?.toString() ?? ''),
        'provider': TextEditingController(text: cert['provider']?.toString() ?? ''),
      };
    }).toList();
    if (_certificationsList.isEmpty) {
      _certificationsList.add({
        'title': TextEditingController(),
        'provider': TextEditingController(),
      });
    }

    // Load profile image
    _loadProfileImage(basicInfo['profile_photo'] as String?);
  }

  Future<void> _loadProfileImage(String? imageData) async {
    if (imageData == null || imageData.isEmpty) return;

    try {
      if (imageData.startsWith('data:image')) {
        final base64String = imageData.contains(',') ? imageData.split(',')[1] : imageData;
        final bytes = base64Decode(base64String);
        setState(() {
          _profileImageBytes = bytes;
          _profileImageBase64 = imageData;
        });
      }
    } catch (e) {
      print('Error loading profile image: $e');
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final bytes = await image.readAsBytes();
        final base64String = base64Encode(bytes);
        setState(() {
          _profileImageBytes = bytes;
          _profileImageBase64 = 'data:image/jpeg;base64,$base64String';
        });
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _designationController.dispose();
    _aboutController.dispose();
    _hourlyRateController.dispose();
    for (var edu in _educationList) {
      edu['degree']?.dispose();
      edu['institute']?.dispose();
    }
    for (var cert in _certificationsList) {
      cert['title']?.dispose();
      cert['provider']?.dispose();
    }
    
    // Reset status bar when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    
    super.dispose();
  }

  void _addSpecialization() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Specialization', style: GoogleFonts.poppins()),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Specialization',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _specializations.add(controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add', style: GoogleFonts.poppins(color: AppColors.accentTeal)),
            ),
          ],
        );
      },
    );
  }

  void _removeSpecialization(String spec) {
    setState(() {
      _specializations.remove(spec);
    });
  }

  void _addLanguage() {
    showDialog(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text('Add Language', style: GoogleFonts.poppins()),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Language',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            style: GoogleFonts.poppins(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  setState(() {
                    _languages.add(controller.text.trim());
                  });
                  Navigator.pop(context);
                }
              },
              child: Text('Add', style: GoogleFonts.poppins(color: AppColors.accentTeal)),
            ),
          ],
        );
      },
    );
  }

  void _removeLanguage(String lang) {
    setState(() {
      _languages.remove(lang);
    });
  }

  void _addEducation() {
    setState(() {
      _educationList.add({
        'degree': TextEditingController(),
        'institute': TextEditingController(),
      });
    });
  }

  void _addCertification() {
    setState(() {
      _certificationsList.add({
        'title': TextEditingController(),
        'provider': TextEditingController(),
      });
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final token = await AuthCacheService.getAuthToken();
      if (token == null) {
        _showError('Authentication token not found');
        return;
      }

      // Prepare education list (only include entries with at least one field filled)
      final education = _educationList
          .where((edu) => 
              (edu['degree']?.text.trim().isNotEmpty ?? false) || 
              (edu['institute']?.text.trim().isNotEmpty ?? false))
          .map((edu) => {
                'degree': edu['degree']?.text.trim() ?? '',
                'institute_name': edu['institute']?.text.trim() ?? '',
              })
          .toList();

      // Prepare certifications list (only include entries with at least one field filled)
      final certifications = _certificationsList
          .where((cert) => 
              (cert['title']?.text.trim().isNotEmpty ?? false) || 
              (cert['provider']?.text.trim().isNotEmpty ?? false))
          .map((cert) => {
                'certificate_title': cert['title']?.text.trim() ?? '', // API expects 'certificate_title'
                'provider': cert['provider']?.text.trim() ?? '',
              })
          .toList();

      // Build basic_info matching the API format exactly
      final basicInfo = <String, dynamic>{
        'full_name': _fullNameController.text.trim(),
        'designation': _designationController.text.trim(),
        'location': _selectedLocation,
        'hourly_rate': int.tryParse(_hourlyRateController.text.trim()) ?? 0,
        'currency': _selectedCurrency,
        'specializations': _specializations,
        'languages': _languages,
        'categories': [], // API requires categories as array (can be empty)
      };
      
      // Add optional fields only if they have values
      final aboutText = _aboutController.text.trim();
      if (aboutText.isNotEmpty) {
        basicInfo['about'] = aboutText;
      }
      
      if (_profileImageBase64 != null && _profileImageBase64!.isNotEmpty) {
        basicInfo['profile_photo'] = _profileImageBase64;
      }

      final success = await SpecialistApiService.updateSpecialistProfile(
        basicInfo: basicInfo,
        education: education.isNotEmpty ? education : null,
        certifications: certifications.isNotEmpty ? certifications : null,
        token: token,
      );

      if (success) {
        if (mounted) {
          final localizations = AppLocalizations.of(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(localizations?.profileUpdated ?? 'Profile updated successfully', style: GoogleFonts.poppins()),
              backgroundColor: AppColors.successGreen,
            ),
          );
          widget.onProfileUpdated();
          Navigator.pop(context);
        }
      } else {
        final localizations = AppLocalizations.of(context);
        _showError(localizations?.profileUpdateFailed ?? 'Failed to update profile');
      }
    } catch (e) {
      final localizations = AppLocalizations.of(context);
      _showError('${localizations?.profileUpdateFailed ?? 'Error updating profile'}: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message, style: GoogleFonts.poppins()),
          backgroundColor: AppColors.errorRed,
        ),
      );
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
          appBar: AppBar(
            backgroundColor: AppColors.accentTeal,
            foregroundColor: AppColors.white,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.light,
            ),
            title: Text(
              localizations?.editProfile ?? 'Edit Profile',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
          body: SafeArea(
            top: false,
            child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // Profile Picture Section
                  Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.accentTeal,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
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
                                      _getInitials(_fullNameController.text),
                                      style: GoogleFonts.poppins(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.accentTeal,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
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
                    TextButton.icon(
                      onPressed: _pickImage,
                      icon: const Icon(Icons.camera_alt, color: AppColors.white, size: 18),
                      label: Text(
                        localizations?.changePhoto ?? 'Change Photo',
                        style: GoogleFonts.poppins(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

                  // Form Content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Basic Info Section
                    _buildSectionTitle(localizations?.basicInfo ?? 'Basic Info'),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _fullNameController,
                      label: localizations?.fullNameLabel ?? 'Full Name',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _designationController,
                      label: localizations?.designationLabel ?? 'Designation',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your designation';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _aboutController,
                      label: localizations?.about ?? 'About',
                      hint: localizations?.aboutHint ?? 'Describe your experience',
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _buildDropdownField(
                      label: localizations?.locationLabel ?? 'Location',
                      value: _selectedLocation,
                      items: _locations,
                      onChanged: (value) {
                        setState(() {
                          _selectedLocation = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: _buildTextField(
                            controller: _hourlyRateController,
                            label: localizations?.hourlyRateLabel ?? 'Hourly Rate',
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              if (int.tryParse(value.trim()) == null) {
                                return 'Invalid';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildDropdownField(
                            label: localizations?.currency ?? 'Currency',
                            value: _selectedCurrency,
                            items: _currencies,
                            onChanged: (value) {
                              setState(() {
                                _selectedCurrency = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildChipField(
                      label: localizations?.specializationLabel ?? 'Specialization',
                      chips: _specializations,
                      onAdd: _addSpecialization,
                      onRemove: _removeSpecialization,
                    ),
                    const SizedBox(height: 16),
                    _buildChipField(
                      label: localizations?.languagesLabel ?? 'Languages',
                      chips: _languages,
                      onAdd: _addLanguage,
                      onRemove: _removeLanguage,
                    ),

                    const SizedBox(height: 32),

                    // Education & Certifications Section
                    _buildSectionTitle(localizations?.educationCertificationsTitle ?? 'Education & Certifications'),
                    const SizedBox(height: 16),
                    ..._educationList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final edu = entry.value;
                      return Column(
                        children: [
                          _buildTextField(
                            controller: edu['degree']!,
                            label: localizations?.educationFieldDegree ?? 'Degree',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: edu['institute']!,
                            label: localizations?.educationFieldInstitute ?? 'Institute Name',
                          ),
                          if (index < _educationList.length - 1) const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                    TextButton(
                      onPressed: _addEducation,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: AppColors.accentTeal, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            localizations?.addMoreEducation ?? 'Add More Education',
                            style: GoogleFonts.poppins(
                              color: AppColors.accentTeal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    ..._certificationsList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final cert = entry.value;
                      return Column(
                        children: [
                          _buildTextField(
                            controller: cert['title']!,
                            label: localizations?.certificationFieldTitle ?? 'Certificate Title',
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: cert['provider']!,
                            label: localizations?.certificationFieldProvider ?? 'Provider',
                          ),
                          if (index < _certificationsList.length - 1) const SizedBox(height: 16),
                        ],
                      );
                    }).toList(),
                    TextButton(
                      onPressed: _addCertification,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.add, color: AppColors.accentTeal, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            localizations?.addMoreCertifications ?? 'Add More Certifications',
                            style: GoogleFonts.poppins(
                              color: AppColors.accentTeal,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Save Changes Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accentTeal,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                                ),
                              )
                            : Text(
                                localizations?.saveChanges ?? 'Save Changes',
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ],
                  ),
                ),
                ],
              ),
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
      ),
      style: GoogleFonts.poppins(),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: AppColors.textSecondary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.borderGrey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.accentTeal, width: 2),
        ),
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        );
      }).toList(),
      onChanged: onChanged,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
      dropdownColor: AppColors.white,
      icon: const Icon(Icons.arrow_drop_down, color: AppColors.textSecondary),
      iconSize: 24,
      isExpanded: true,
    );
  }

  Widget _buildChipField({
    required String label,
    required List<String> chips,
    required VoidCallback onAdd,
    required Function(String) onRemove,
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
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ...chips.map((chip) {
              return Chip(
                label: Text(chip, style: GoogleFonts.poppins(fontSize: 12)),
                onDeleted: () => onRemove(chip),
                deleteIcon: const Icon(Icons.close, size: 18),
                backgroundColor: AppColors.icyWhite,
                side: BorderSide(color: AppColors.accentTeal.withOpacity(0.3)),
              );
            }),
            ActionChip(
              label: Text('+ Add', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.accentTeal)),
              onPressed: onAdd,
              backgroundColor: AppColors.chipAddGrey,
              side: BorderSide.none,
            ),
          ],
        ),
      ],
    );
  }
}
