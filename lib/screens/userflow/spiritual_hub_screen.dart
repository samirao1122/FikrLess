import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../../services/api_service.dart';
import '../../services/auth_cache_service.dart';
import 'guided_meditations_screen.dart';

class SpiritualHubScreen extends StatefulWidget {
  final Locale locale;

  const SpiritualHubScreen({super.key, required this.locale});

  @override
  State<SpiritualHubScreen> createState() => _SpiritualHubScreenState();
}

class _SpiritualHubScreenState extends State<SpiritualHubScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  List<Map<String, dynamic>> _sliderImages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    // ✅ Status bar matches header color (teal)
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: AppColors.accentTeal,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
    );

    _loadSliderImages();
  }

  @override
  void dispose() {
    // ✅ Reset status bar when leaving this screen
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadSliderImages() async {
    setState(() {
      _isLoading = true;
    });

    final token = await AuthCacheService.getAuthToken();
    final images = await SpiritualHubApiService.getSliderImages(token: token);

    if (!mounted) return;

    setState(() {
      _sliderImages = images ?? [];
      // Dummy data if API gives nothing
      if (_sliderImages.isEmpty) {
        _sliderImages = [
          {'imageUrl': 'https://picsum.photos/400/300?random=1'},
          {'imageUrl': 'https://picsum.photos/400/300?random=2'},
          {'imageUrl': 'https://picsum.photos/400/300?random=3'},
        ];
      }
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false, // ✅ let header paint behind status bar
        bottom: true,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  20,
                  20,
                  20,
                  bottomPadding > 0 ? bottomPadding : 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Daily Life Reminders Section
                    Text(
                      localizations.dailyLifeReminders,
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Slider Card
                    _buildSliderCard(localizations),
                    const SizedBox(height: 24),
                    // Pagination Dots
                    _buildPaginationDots(),
                    const SizedBox(height: 24),
                    // Guided Meditations Button
                    _buildGuidedMeditationsButton(localizations),
                  ],
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
      height: statusBarHeight + 120, // ✅ covers status bar + header
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
        top: statusBarHeight + 16, // content starts below status bar
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 15),
          child: Row(
            children: [
              // Back Button
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
              // Title - Centered
              Text(
                localizations.spiritualHub,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
              ),
              const Spacer(),
              // Spacer to balance the back button visually
              const SizedBox(width: 48),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderCard(AppLocalizations localizations) {
    if (_isLoading) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.softAqua,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_sliderImages.isEmpty) {
      return Container(
        height: 300,
        decoration: BoxDecoration(
          color: AppColors.softAqua,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Center(
          child: Text(
            localizations.noRemindersAvailable,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 400,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPage = index;
          });
        },
        itemCount: _sliderImages.length,
        itemBuilder: (context, index) {
          final imageUrl = _sliderImages[index]['imageUrl'] as String? ?? '';
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: AppColors.softAqua,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: imageUrl.isNotEmpty
                  ? Image.network(
                imageUrl,
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                cacheWidth: 800,
                cacheHeight: 600,
                errorBuilder: (context, error, stackTrace) {
                  // ignore: avoid_print
                  print('Image load error: $error');
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.softAqua,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Image.asset(
                      'assets/images/home_directory/img.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.softAqua,
                          child: Center(
                            child: Icon(
                              Icons.image,
                              size: 64,
                              color: AppColors.textSecondary
                                  .withOpacity(0.5),
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: AppColors.softAqua,
                    child: Center(
                      child: CircularProgressIndicator(
                        value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              )
                  : Container(
                width: double.infinity,
                height: double.infinity,
                color: AppColors.softAqua,
                child: Center(
                  child: Icon(
                    Icons.image_not_supported,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPaginationDots() {
    if (_sliderImages.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          _sliderImages.length,
              (index) => Container(
            width: _currentPage == index ? 24 : 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: _currentPage == index
                  ? AppColors.accentTeal
                  : AppColors.colorShadow.withOpacity(0.5),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGuidedMeditationsButton(AppLocalizations localizations) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  GuidedMeditationsScreen(locale: widget.locale),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accentTeal,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          localizations.guidedMeditations,
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
