import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'education_certification.dart';
import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';

class BasicInformationScreen extends StatefulWidget {
  final Locale locale;
  final String token;

  const BasicInformationScreen({
    super.key,
    required this.locale,
    required this.token,
  });

  @override
  State<BasicInformationScreen> createState() => _BasicInformationScreenState();
}

class _BasicInformationScreenState extends State<BasicInformationScreen> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController hourlyRateController = TextEditingController(
    text: "500",
  );
  final TextEditingController experienceYearsController = TextEditingController();

  String? selectedLocation = "Karachi, Pakistan";
  String? selectedCurrency = "PKR";
  List<String> specializations = ["CBT"];
  List<String> languages = ["English"];
  List<String> selectedCategories = [];
  String? profilePhotoBase64;
  File? profilePhotoFile;
  final ImagePicker _imagePicker = ImagePicker();

  // Available categories for specialists
  final List<String> availableCategories = [
    "Mindfulness & Meditation",
    "Life Coaching",
    "Cognitive Behavioral Therapy (CBT)",
    "Anxiety & Stress Management",
    "Depression Support",
    "Trauma Therapy",
    "Relationship Counseling",
    "Addiction Recovery",
    "Child & Adolescent Therapy",
    "Family Therapy",
    "Career Counseling",
    "Grief & Loss Counseling",
    "Eating Disorders",
    "Sleep Disorders",
    "Anger Management",
  ];

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
                          AppColors.gradientTop,
                          AppColors.gradientBottom,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),

                  // Main Content
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.basicInformationTitle,
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryDarkBlue,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Glass Card
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
                                        // Profile Photo
                                        _buildLabel("Profile Photo"),
                                        const SizedBox(height: 8),
                                        _buildProfilePhotoPicker(),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.fullNameLabel),
                                        _buildTextField(
                                          fullNameController,
                                          loc.fullNameHint,
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.designationLabel),
                                        _buildTextField(
                                          designationController,
                                          loc.designationHint,
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.locationLabel),
                                        _buildDropdown<String>(
                                          value: selectedLocation,
                                          items: loc.locationOptions,
                                          onChanged: (val) => setState(
                                            () => selectedLocation = val,
                                          ),
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.hourlyRateLabel),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: _buildTextField(
                                                hourlyRateController,
                                                loc.hourlyRateHint,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            _buildDropdown<String>(
                                              value: selectedCurrency,
                                              items: loc.currencyOptions,
                                              onChanged: (val) => setState(
                                                () => selectedCurrency = val,
                                              ),
                                              width: 90,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel("Experience (Years)"),
                                        _buildTextField(
                                          experienceYearsController,
                                          "Enter years of experience",
                                          keyboardType: TextInputType.number,
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.specializationLabel),
                                        _buildTagSection(
                                          specializations,
                                          loc.addSpecialization,
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel(loc.languagesLabel),
                                        _buildTagSection(
                                          languages,
                                          loc.addLanguage,
                                        ),
                                        const SizedBox(height: 16),

                                        _buildLabel("Categories"),
                                        _buildCategoriesMultiSelect(),
                                        const SizedBox(height: 30),

                                        // Next Button
                                        _buildNextButton(context, loc),
                                        const SizedBox(height: 20),

                                        // Progress Bar
                                        _buildProgressBar(context, 0.5),
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

  // ---------------- UI Components ----------------
  Widget _buildLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.primaryDarkBlue,
          ),
        ),
      );

  Widget _buildTextField(
    TextEditingController controller,
    String hint, {
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: AppColors.backgroundWhite.withOpacity(0.8),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderGrey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.borderGrey300),
        ),
      ),
    );
  }

  Widget _buildDropdown<T>({
    required T? value,
    required List<T> items,
    required ValueChanged<T?> onChanged,
    double? width,
  }) {
    final dropdown = DropdownButtonHideUnderline(
      child: DropdownButton<T>(
        isExpanded: true,
        value: value,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items
            .map(
              (item) =>
                  DropdownMenuItem(value: item, child: Text(item.toString())),
            )
            .toList(),
        onChanged: onChanged,
      ),
    );

    return Container(
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withOpacity(0.8),
        border: Border.all(color: AppColors.borderGrey300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: dropdown,
    );
  }

  Widget _buildProfilePhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 120,
        height: 120,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.borderGrey300,
            width: 2,
          ),
          color: AppColors.backgroundWhite.withOpacity(0.8),
        ),
        child: profilePhotoFile != null
            ? ClipOval(
                child: Image.file(
                  profilePhotoFile!,
                  fit: BoxFit.cover,
                ),
              )
            : const Icon(
                Icons.add_a_photo,
                size: 40,
                color: AppColors.primaryDarkBlue,
              ),
      ),
    );
  }

  Future<void> _pickImage() async {
    try {
      // Request permission
      if (Platform.isAndroid) {
        if (!await Permission.photos.isGranted) {
          final status = await Permission.photos.request();
          if (!status.isGranted) {
            if (!await Permission.storage.isGranted) {
              final storageStatus = await Permission.storage.request();
              if (!storageStatus.isGranted) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Permission denied. Please grant photo access in settings.'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
                return;
              }
            }
          }
        }
      } else if (Platform.isIOS) {
        if (!await Permission.photos.isGranted) {
          final status = await Permission.photos.request();
          if (!status.isGranted) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Permission denied. Please grant photo access in settings.'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
            return;
          }
        }
      }

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          profilePhotoFile = File(pickedFile.path);
        });

        // Convert to base64
        final bytes = await pickedFile.readAsBytes();
        profilePhotoBase64 = base64Encode(bytes);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    }
  }

  Widget _buildTagSection(List<String> tags, String addLabel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGrey300),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        children: [
          ...tags.map(
            (tag) => Chip(
              label: Text(tag),
              deleteIconColor: AppColors.errorRed,
              onDeleted: () => setState(() => tags.remove(tag)),
              backgroundColor: AppColors.chipBlue,
            ),
          ),
          GestureDetector(
            onTap: () async {
              final newTag = await _showAddDialog(addLabel);
              if (newTag != null && newTag.trim().isNotEmpty) {
                setState(() => tags.add(newTag.trim()));
              }
            },
            child: Chip(
              label: Text("+ ${addLabel}"),
              backgroundColor: AppColors.chipAddGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesMultiSelect() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.backgroundWhite.withOpacity(0.8),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderGrey300),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: availableCategories.map((category) {
          final isSelected = selectedCategories.contains(category);
          return FilterChip(
            label: Text(category),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedCategories.add(category);
                } else {
                  selectedCategories.remove(category);
                }
              });
            },
            selectedColor: AppColors.chipBlue,
            checkmarkColor: AppColors.primaryDarkBlue,
            backgroundColor: AppColors.backgroundWhite,
          );
        }).toList(),
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

  Widget _buildNextButton(BuildContext context, AppLocalizations loc) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () async {
          // Validate required fields
          if (fullNameController.text.trim().isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please enter your full name'),
                backgroundColor: AppColors.errorRed,
              ),
            );
            return;
          }

          // Save data to cache
          await _saveDataToCache();

          // Navigate to next screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EducationCertificationsScreen(
                locale: widget.locale,
                token: widget.token,
              ),
            ),
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
          loc.nextButton,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }

  Future<void> _saveDataToCache() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Save basic info as JSON
    final basicInfo = {
      'full_name': fullNameController.text.trim(),
      'designation': designationController.text.trim(),
      'location': selectedLocation ?? '',
      'hourly_rate': int.tryParse(hourlyRateController.text.trim()) ?? 500,
      'currency': selectedCurrency ?? 'PKR',
      'specializations': specializations,
      'languages': languages,
      'categories': selectedCategories,
      'experience_years': int.tryParse(experienceYearsController.text.trim()) ?? 0,
      'profile_photo_base64': profilePhotoBase64 ?? '',
    };

    await prefs.setString('specialist_basic_info', jsonEncode(basicInfo));
  }

  Future<String?> _showAddDialog(String title) {
    final TextEditingController tagController = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: tagController,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.addDialogHint,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppLocalizations.of(context)!.cancelButton),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, tagController.text),
            child: Text(AppLocalizations.of(context)!.addButton),
          ),
        ],
      ),
    );
  }
}
