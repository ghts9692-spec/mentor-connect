import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import 'mentor_profile_screen.dart';

class DiscoverScreen extends StatefulWidget {
  final bool showNav;
  const DiscoverScreen({super.key, this.showNav = true});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  String _selectedFilter = AppStrings.all;
  final _searchController = TextEditingController();

  final List<String> _filters = [
    AppStrings.all,
    ...AppStrings.interestCategories,
  ];

  final List<Map<String, dynamic>> _mentors = [
    {
      'name': 'Alex Rivera',
      'expertise': 'UX Design',
      'rating': 4.8,
      'reviews': 24,
    },
    {
      'name': 'Sarah Jenkins',
      'expertise': 'Product Design',
      'rating': 4.9,
      'reviews': 42,
    },
    {
      'name': 'David Chen',
      'expertise': 'Engineering',
      'rating': 4.8,
      'reviews': 31,
    },
    {
      'name': 'Emily Watson',
      'expertise': 'Marketing',
      'rating': 4.7,
      'reviews': 18,
    },
    {
      'name': 'Michael Kim',
      'expertise': 'Data Science',
      'rating': 4.9,
      'reviews': 56,
    },
    {
      'name': 'Lisa Thompson',
      'expertise': 'Leadership',
      'rating': 4.6,
      'reviews': 22,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _GlowCircle(
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    AppStrings.discoverMentors,
                    style: tt.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Search bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isDark ? AppColors.slate700 : AppColors.slate200,
                      ),
                    ),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: AppStrings.searchHint,
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: isDark
                              ? AppColors.slate500
                              : AppColors.slate400,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Filter chips
                SizedBox(
                  height: 40,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _filters.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (_, i) {
                      final filter = _filters[i];
                      final isSelected = filter == _selectedFilter;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedFilter = filter),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 18),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : isDark
                                ? AppColors.slate800
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : isDark
                                  ? AppColors.slate700
                                  : AppColors.slate200,
                            ),
                          ),
                          child: Text(
                            filter,
                            style: tt.labelMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? Colors.white
                                  : isDark
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : AppColors.slate600,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // Mentor grid
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 0.78,
                        ),
                    itemCount: _mentors.length,
                    itemBuilder: (_, i) {
                      final m = _mentors[i];
                      return _MentorGridCard(
                        name: m['name'],
                        expertise: m['expertise'],
                        rating: m['rating'],
                        reviews: m['reviews'],
                        isDark: isDark,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MentorProfileScreen(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MentorGridCard extends StatelessWidget {
  final String name;
  final String expertise;
  final double rating;
  final int reviews;
  final bool isDark;
  final VoidCallback onTap;

  const _MentorGridCard({
    required this.name,
    required this.expertise,
    required this.rating,
    required this.reviews,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate100,
          ),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.primary, Color(0xFF6C3FEC)],
                ),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.slate900,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              expertise,
              style: tt.labelSmall?.copyWith(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.5)
                    : AppColors.slate500,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.star_rounded,
                  color: AppColors.warning,
                  size: 14,
                ),
                const SizedBox(width: 3),
                Text(
                  '$rating ($reviews)',
                  style: tt.labelSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.white : AppColors.slate700,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              AppStrings.viewProfile,
              style: tt.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlowCircle extends StatelessWidget {
  final Color color;
  const _GlowCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
      child: Container(
        width: 260,
        height: 260,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      ),
    );
  }
}
