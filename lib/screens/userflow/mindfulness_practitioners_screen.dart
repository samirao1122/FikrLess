import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';

class MindfulnessPractitionersScreen extends StatefulWidget {
  final Locale locale;

  const MindfulnessPractitionersScreen({super.key, required this.locale});

  @override
  State<MindfulnessPractitionersScreen> createState() =>
      _MindfulnessPractitionersScreenState();
}

class _MindfulnessPractitionersScreenState
    extends State<MindfulnessPractitionersScreen> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _practitioners = [];
  String _selectedCategory = 'all';
  bool _isLoadingCategories = true;
  bool _isLoadingPractitioners = true;
  bool _hasMore = true;
  int _currentOffset = 1;
  final int _limit = 10;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // ✅ Set status bar color to match header (teal + light icons)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _loadCategories();
    _loadPractitioners();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    // ✅ Reset status bar to default when leaving screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      if (_hasMore && !_isLoadingPractitioners) {
        _loadMorePractitioners();
      }
    }
  }

  Future<void> _loadCategories() async {
    setState(() {
      _isLoadingCategories = true;
    });

    final token = await AuthCacheService.getAuthToken();
    final categories = await SpiritualHubApiService.getCategories(token: token);

    if (!mounted) return;

    setState(() {
      _categories = categories ?? [];
      // Dummy fallback
      if (_categories.isEmpty) {
        _categories = [
          {'cat_name': 'Meditation', 'cat_id': '1'},
          {'cat_name': 'Mindfulness & Meditation', 'cat_id': '2'},
          {'cat_name': 'Energy Healing', 'cat_id': '3'},
          {'cat_name': 'Life Coaching', 'cat_id': '4'},
        ];
      }
      _isLoadingCategories = false;
    });
  }

  Future<void> _loadPractitioners({bool reset = false}) async {
    if (reset) {
      setState(() {
        _currentOffset = 1;
        _practitioners = [];
        _hasMore = true;
      });
    }

    setState(() {
      _isLoadingPractitioners = true;
    });

    final token = await AuthCacheService.getAuthToken();
    if (token == null || token.isEmpty) {
      setState(() {
        _isLoadingPractitioners = false;
      });
      return;
    }

    final result = await SpiritualHubApiService.getPractitioners(
      limit: _limit,
      offset: _currentOffset,
      category: _selectedCategory,
      token: token,
    );

    if (!mounted) return;

    setState(() {
      if (result != null) {
        final data = result['data'];
        final newPractitioners =
        data is List ? List<Map<String, dynamic>>.from(data) : <Map<String, dynamic>>[];

        _practitioners.addAll(newPractitioners);
        _hasMore = result['hasMore'] as bool? ?? false;
        _currentOffset++;
      }

      // Dummy fallback for first load
      if (_practitioners.isEmpty && reset) {
        _practitioners = [
          {
            'practitioner_name': 'Dr. Sarah Ahmed',
            'Category': 'Meditation Teacher',
            'Exp': '8 years',
            'Practionaer_ID': '111',
            'rating': '4.6',
          },
          {
            'practitioner_name': 'Dr. Sarah Ahmed',
            'Category': 'Spiritual Healer',
            'Exp': '8 years',
            'Practionaer_ID': '112',
            'rating': '4.6',
          },
          {
            'practitioner_name': 'Dr. Sarah Ahmed',
            'Category': 'Life Coach',
            'Exp': '8 years',
            'Practionaer_ID': '113',
            'rating': '4.6',
          },
          {
            'practitioner_name': 'Dr. Sarah Ahmed',
            'Category': 'Mindfulness Training',
            'Exp': '8 years',
            'Practionaer_ID': '114',
            'rating': '4.6',
          },
        ];
        _hasMore = false;
      }

      _isLoadingPractitioners = false;
    });
  }

  Future<void> _loadMorePractitioners() async {
    await _loadPractitioners(reset: false);
  }

  void _onCategorySelected(String category) {
    if (_selectedCategory != category) {
      setState(() {
        _selectedCategory = category;
      });
      _loadPractitioners(reset: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // ✅ Let header go behind status bar
        bottom: true,
        child: Column(
          children: [
            _buildHeader(),
            _buildCategoryFilter(),
            Expanded(
              child: _isLoadingPractitioners && _practitioners.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : _practitioners.isEmpty
                  ? Center(
                child: Text(
                  AppLocalizations.of(context)!
                      .noPractitionersAvailable,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.textSecondary,
                  ),
                ),
              )
                  : Padding(
                padding: EdgeInsets.only(bottom: bottomPadding),
                child: RefreshIndicator(
                  onRefresh: () => _loadPractitioners(reset: true),
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(20),
                    itemCount:
                    _practitioners.length + (_hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _practitioners.length) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return _buildPractitionerCard(
                          _practitioners[index]);
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

  Widget _buildHeader() {
    final localizations = AppLocalizations.of(context)!;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      height: statusBarHeight + 120, // ✅ Covers status bar + header area
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
        top: statusBarHeight + 16, // ✅ Content starts *below* status bar
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15), // 10–15 dp above bottom
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
                  localizations.mindfulnessPractitioners,
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
              const SizedBox(width: 48), // balances back button visually
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilter() {
    if (_isLoadingCategories) {
      return const SizedBox(
        height: 60,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _categories.length + 1, // +1 for "All"
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = _selectedCategory == 'all';
            return _buildCategoryChip('All', 'all', isSelected);
          } else {
            final category = _categories[index - 1];
            final categoryName = category['cat_name'] as String? ?? '';
            final categoryId = category['cat_id'] as String? ?? '';
            final isSelected = _selectedCategory == categoryId;
            return _buildCategoryChip(categoryName, categoryId, isSelected);
          }
        },
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value, bool isSelected) {
    final localizations = AppLocalizations.of(context)!;
    final displayLabel = value == 'all' ? localizations.all : label;

    return GestureDetector(
      onTap: () => _onCategorySelected(value),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.white : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.accentTeal : AppColors.colorShadow,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            displayLabel,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? AppColors.accentTeal : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPractitionerCard(Map<String, dynamic> practitioner) {
    final name = practitioner['practitioner_name'] as String? ?? 'Unknown';
    final category = practitioner['Category'] as String? ?? '';
    final experience = practitioner['Exp'] as String? ?? '';
    final rating = practitioner['rating'] as String? ?? '';
    final practitionerId = practitioner['Practionaer_ID'] as String? ?? '';

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
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.background,
                    child: const Icon(
                      Icons.person,
                      size: 40,
                      color: AppColors.textSecondary,
                    ),
                  ),
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
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 16,
                          color: Colors.amber,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            rating,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            experience,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Navigate to booking screen
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Booking for $name coming soon')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentTeal,
                padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          ),
        ],
      ),
    );
  }
}
