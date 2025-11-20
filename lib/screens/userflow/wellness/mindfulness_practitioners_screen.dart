import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/app_colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../services/api_service.dart';
import '../../../services/auth_cache_service.dart';
import '../../../services/image_cache_service.dart';
import '../social/individual_chat_screen.dart';

class MindfulnessPractitionersScreen extends StatefulWidget {
  final Locale locale;
  final String? title; // Optional title override (e.g., "Specialist" from main screen)

  const MindfulnessPractitionersScreen({
    super.key,
    required this.locale,
    this.title,
  });

  @override
  State<MindfulnessPractitionersScreen> createState() =>
      _MindfulnessPractitionersScreenState();
}

class _MindfulnessPractitionersScreenState
    extends State<MindfulnessPractitionersScreen> {
  List<Map<String, dynamic>> _specialists = [];
  List<String> _categories = [];
  List<String> _specializations = [];
  
  // Filters
  bool? _verifiedFilter;
  String? _selectedCategory;
  String? _selectedSpecialization;
  double? _minRating;
  int? _minExperience;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // Pagination
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isLoading = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _loadSpecialists(reset: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (_hasMore && !_isLoading) {
        _loadMoreSpecialists();
      }
    }
  }

  Future<void> _loadSpecialists({bool reset = false}) async {
    if (reset) {
      setState(() {
        _currentPage = 1;
        _specialists = [];
        _hasMore = true;
      });
    }

    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    final token = await AuthCacheService.getAuthToken();
    
    final result = await SpecialistApiService.getAllSpecialists(
      verified: _verifiedFilter,
      specialization: _selectedSpecialization,
      category: _selectedCategory,
      search: _searchQuery.isNotEmpty ? _searchQuery : null,
      minRating: _minRating,
      minExperience: _minExperience,
      page: _currentPage,
      limit: _limit,
      token: token,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      
      if (result != null && result['success'] == true) {
        final data = result['data'] as List?;
        final pagination = result['pagination'] as Map<String, dynamic>?;
        
        if (data != null) {
          if (reset) {
            _specialists = List<Map<String, dynamic>>.from(data);
          } else {
            _specialists.addAll(List<Map<String, dynamic>>.from(data));
          }
          
          // Extract unique categories and specializations from results
          _extractFiltersFromResults(data);
          
          // Check pagination
          if (pagination != null) {
            final currentPage = pagination['page'] as int? ?? 1;
            final totalPages = pagination['total_pages'] as int? ?? 1;
            _hasMore = currentPage < totalPages;
            if (_hasMore) {
              _currentPage = currentPage + 1;
            }
          } else {
            _hasMore = data.length >= _limit;
            if (_hasMore) {
              _currentPage++;
            }
          }
        }
      }
    });
  }

  void _extractFiltersFromResults(List<dynamic> data) {
    final Set<String> categories = {};
    final Set<String> specializations = {};
    
    for (final specialist in data) {
      if (specialist is Map<String, dynamic>) {
        final basicInfo = specialist['basic_info'] as Map<String, dynamic>?;
        final cats = basicInfo?['categories'] as List? ?? specialist['categories'] as List?;
        final specs = basicInfo?['specializations'] as List? ?? specialist['specializations'] as List?;
        
        if (cats != null) {
          for (final cat in cats) {
            if (cat is String) categories.add(cat);
          }
        }
        
        if (specs != null) {
          for (final spec in specs) {
            if (spec is String) specializations.add(spec);
          }
        }
      }
    }
    
    setState(() {
      _categories = categories.toList()..sort();
      _specializations = specializations.toList()..sort();
    });
  }

  Future<void> _loadMoreSpecialists() async {
    if (!_hasMore || _isLoading) return;
    await _loadSpecialists(reset: false);
  }

  void _applyFilters() {
    _loadSpecialists(reset: true);
  }

  void _clearFilters() {
    setState(() {
      _verifiedFilter = null;
      _selectedCategory = null;
      _selectedSpecialization = null;
      _minRating = null;
      _minExperience = null;
      _searchQuery = '';
      _searchController.clear();
    });
    _loadSpecialists(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;
    final title = widget.title ?? AppLocalizations.of(context)!.mindfulnessPractitioners;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: true,
        child: Column(
          children: [
            _buildHeader(title),
            _buildSearchBar(),
            _buildFilters(),
            Expanded(
              child: _isLoading && _specialists.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _specialists.isEmpty
                      ? Center(
                          child: Text(
                            AppLocalizations.of(context)!.noPractitionersAvailable,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(bottom: bottomPadding),
                          child: RefreshIndicator(
                            onRefresh: () => _loadSpecialists(reset: true),
                            child: ListView.builder(
                              controller: _scrollController,
                              padding: const EdgeInsets.all(20),
                              itemCount: _specialists.length + (_hasMore ? 1 : 0),
                              itemBuilder: (context, index) {
                                if (index == _specialists.length) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    ),
                                  );
                                }
                                return _buildSpecialistCard(_specialists[index]);
                              },
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    final statusBarHeight = MediaQuery.of(context).padding.top;

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
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search specialists...',
          border: InputBorder.none,
          icon: const Icon(Icons.search, color: AppColors.textSecondary),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear, color: AppColors.textSecondary),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                      _searchController.clear();
                    });
                    _loadSpecialists(reset: true);
                  },
                )
              : null,
        ),
        onSubmitted: (value) {
          setState(() {
            _searchQuery = value;
          });
          _loadSpecialists(reset: true);
        },
        onChanged: (value) {
          setState(() {
            _searchQuery = value;
          });
        },
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(
                        label: 'Verified',
                        isSelected: _verifiedFilter == true,
                        onTap: () {
                          setState(() {
                            _verifiedFilter = _verifiedFilter == true ? null : true;
                          });
                          _applyFilters();
                        },
                      ),
                      if (_categories.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        ..._categories.map((cat) => _buildFilterChip(
                              label: cat,
                              isSelected: _selectedCategory == cat,
                              onTap: () {
                                setState(() {
                                  _selectedCategory = _selectedCategory == cat ? null : cat;
                                });
                                _applyFilters();
                              },
                            )),
                      ],
                      if (_specializations.isNotEmpty) ...[
                        const SizedBox(width: 8),
                        ..._specializations.map((spec) => _buildFilterChip(
                              label: spec,
                              isSelected: _selectedSpecialization == spec,
                              onTap: () {
                                setState(() {
                                  _selectedSpecialization = _selectedSpecialization == spec ? null : spec;
                                });
                                _applyFilters();
                              },
                            )),
                      ],
                      _buildFilterChip(
                        label: 'Rating 4+',
                        isSelected: _minRating == 4.0,
                        onTap: () {
                          setState(() {
                            _minRating = _minRating == 4.0 ? null : 4.0;
                          });
                          _applyFilters();
                        },
                      ),
                      _buildFilterChip(
                        label: '5+ Years',
                        isSelected: _minExperience == 5,
                        onTap: () {
                          setState(() {
                            _minExperience = _minExperience == 5 ? null : 5;
                          });
                          _applyFilters();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              if (_verifiedFilter != null ||
                  _selectedCategory != null ||
                  _selectedSpecialization != null ||
                  _minRating != null ||
                  _minExperience != null)
                TextButton(
                  onPressed: _clearFilters,
                  child: Text(
                    'Clear',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.accentTeal,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accentTeal : AppColors.white,
          border: Border.all(
            color: isSelected ? AppColors.accentTeal : AppColors.borderLight,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialistCard(Map<String, dynamic> specialist) {
    final basicInfo = specialist['basic_info'] as Map<String, dynamic>? ?? specialist;
    final fullName = basicInfo['full_name'] as String? ?? specialist['full_name'] as String? ?? 'Unknown';
    final designation = basicInfo['designation'] as String? ?? specialist['designation'] as String? ?? '';
    final location = basicInfo['location'] as String? ?? specialist['location'] as String? ?? '';
    final hourlyRate = basicInfo['hourly_rate'] as int? ?? specialist['hourly_rate'] as int? ?? 0;
    final currency = basicInfo['currency'] as String? ?? specialist['currency'] as String? ?? 'PKR';
    final rating = (basicInfo['rating'] as num? ?? specialist['rating'] as num? ?? 0).toDouble();
    final totalReviews = basicInfo['total_reviews'] as int? ?? specialist['total_reviews'] as int? ?? 0;
    final experienceYears = basicInfo['experience_years'] as int? ?? specialist['experience_years'] as int? ?? 0;
    final isVerified = specialist['is_verified'] as bool? ?? false;
    final profilePhoto = basicInfo['profile_photo'] as String? ?? specialist['profile_photo'] as String?;
    final categories = (basicInfo['categories'] as List? ?? specialist['categories'] as List? ?? [])
        .map((e) => e.toString())
        .toList();
    final specializations = (basicInfo['specializations'] as List? ?? specialist['specializations'] as List? ?? [])
        .map((e) => e.toString())
        .toList();

    // Get specialist ID for caching
    final specialistId = specialist['_id']?.toString() ?? 
                         specialist['id']?.toString() ?? 
                         specialist['specialist_id']?.toString() ?? '';
    
    // Cache image to file if available (async, non-blocking)
    if (profilePhoto != null && profilePhoto.isNotEmpty && specialistId.isNotEmpty) {
      ImageCacheService.saveImageFromBase64(
        userId: specialistId,
        base64Image: profilePhoto,
      ).catchError((e) {
        print('Error caching specialist image: $e');
      });
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                    ),
                    child: specialistId.isNotEmpty
                        ? FutureBuilder<String?>(
                            future: ImageCacheService.getImagePath(specialistId),
                            builder: (context, imageSnapshot) {
                              final imagePath = imageSnapshot.data;
                              
                              if (imagePath != null) {
                                return ClipOval(
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppColors.textSecondary,
                                      );
                                    },
                                  ),
                                );
                              }
                              
                              return const Icon(
                                Icons.person,
                                size: 40,
                                color: AppColors.textSecondary,
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            size: 40,
                            color: AppColors.textSecondary,
                          ),
                  ),
                  if (isVerified)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Image.asset(
                        'assets/images/home_directory/verified.png',
                        width: 20,
                        height: 20,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check,
                              color: AppColors.white,
                              size: 12,
                            ),
                          );
                        },
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            fullName,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (designation.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        designation,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (location.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location,
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (rating > 0) ...[
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toStringAsFixed(1),
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          if (totalReviews > 0) ...[
                            const SizedBox(width: 4),
                            Text(
                              '($totalReviews)',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                          const SizedBox(width: 12),
                        ],
                        if (experienceYears > 0) ...[
                          const Icon(
                            Icons.work_outline,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$experienceYears years',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                    if (specializations.isNotEmpty || categories.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          ...specializations.take(3).map((spec) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.icyWhite,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  spec,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.accentTeal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                          ...categories.take(2).map((cat) => Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  cat,
                                  style: GoogleFonts.poppins(
                                    fontSize: 10,
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$currency $hourlyRate/hour',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.accentTeal,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  // Navigate to chat screen
                  final specialistId = specialist['user_id']?.toString() ??
                                      specialist['id']?.toString() ?? 
                                      specialist['specialist_id']?.toString();
                  
                  if (specialistId != null) {
                    // Get cached image path if available
                    ImageCacheService.getImagePath(specialistId).then((imagePath) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IndividualChatScreen(
                            locale: widget.locale,
                            specialistId: specialistId,
                            specialistName: fullName,
                            specialistImagePath: imagePath,
                            specialization: specializations.isNotEmpty 
                                ? specializations.first 
                                : null,
                          ),
                        ),
                      );
                    }).catchError((e) {
                      // Navigate even if image path fails
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => IndividualChatScreen(
                            locale: widget.locale,
                            specialistId: specialistId,
                            specialistName: fullName,
                            specialistImagePath: null,
                            specialization: specializations.isNotEmpty 
                                ? specializations.first 
                                : null,
                          ),
                        ),
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Unable to start chat. Specialist ID not found.'),
                        backgroundColor: AppColors.errorRed,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accentTeal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppLocalizations.of(context)!.bookASession,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
