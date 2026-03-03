import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import 'book_session_screen.dart';

class MentorProfileScreen extends StatelessWidget {
  const MentorProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: _GlowCircle(
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Back button
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 20,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 8),

                        // Avatar
                        Container(
                          height: 96,
                          width: 96,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [AppColors.primary, Color(0xFF6C3FEC)],
                            ),
                            border: Border.all(color: Colors.white, width: 3),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                                blurRadius: 24,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),

                        const SizedBox(height: 16),

                        Text(
                          'Sarah Jenkins',
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Senior Product Designer at Google',
                          style: tt.bodyMedium?.copyWith(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.6)
                                : AppColors.slate500,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Location & availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: isDark
                                  ? AppColors.slate400
                                  : AppColors.slate500,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'San Francisco, CA',
                              style: tt.labelMedium?.copyWith(
                                color: isDark
                                    ? AppColors.slate400
                                    : AppColors.slate500,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(
                                  alpha: 0.12,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppStrings.available,
                                style: tt.labelSmall?.copyWith(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Stats row
                        Row(
                          children: [
                            Expanded(
                              child: _StatPill(
                                value: '4.9 ★',
                                label: AppStrings.rating,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatPill(
                                value: '156',
                                label: AppStrings.sessions,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: _StatPill(
                                value: '5 Yrs',
                                label: AppStrings.experience,
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // About
                        _Section(
                          title: AppStrings.about,
                          isDark: isDark,
                          child: Text(
                            'Passionate product designer with 5+ years of experience at top tech companies. I love helping aspiring designers navigate their career path and build exceptional portfolios.',
                            style: tt.bodyMedium?.copyWith(
                              height: 1.6,
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.7)
                                  : AppColors.slate600,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Expertise
                        _Section(
                          title: AppStrings.expertise,
                          isDark: isDark,
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children:
                                [
                                      'Product Design',
                                      'UX Research',
                                      'Design Systems',
                                      'Prototyping',
                                      'User Testing',
                                    ]
                                    .map(
                                      (s) =>
                                          _SkillChip(label: s, isDark: isDark),
                                    )
                                    .toList(),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Reviews
                        _Section(
                          title: '${AppStrings.reviews} (24)',
                          isDark: isDark,
                          child: Column(
                            children: [
                              _ReviewCard(
                                name: 'Alex Rivera',
                                rating: 5,
                                date: '2 weeks ago',
                                text:
                                    'Sarah is an incredible mentor! Her feedback on my portfolio was detailed and actionable.',
                                isDark: isDark,
                              ),
                              const SizedBox(height: 12),
                              _ReviewCard(
                                name: 'Jordan Lee',
                                rating: 5,
                                date: '1 month ago',
                                text:
                                    'Great session on career planning. Sarah helped me set clear goals.',
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Sticky bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                MediaQuery.of(context).padding.bottom + 16,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.slate800 : Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '\$50',
                        style: tt.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                      Text(
                        AppStrings.perHour,
                        style: tt.labelSmall?.copyWith(
                          color: AppColors.slate500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const BookSessionScreen(),
                          ),
                        );
                      },
                      child: const Text(AppStrings.bookASession),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final bool isDark;

  const _StatPill({
    required this.value,
    required this.label,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : AppColors.slate50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate200,
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: tt.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.slate900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: tt.labelSmall?.copyWith(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppColors.slate500,
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final bool isDark;
  final Widget child;

  const _Section({
    required this.title,
    required this.isDark,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.slate900,
          ),
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}

class _SkillChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _SkillChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.primary,
        ),
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final int rating;
  final String date;
  final String text;
  final bool isDark;

  const _ReviewCard({
    required this.name,
    required this.rating,
    required this.date,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate100,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: tt.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppColors.slate900,
                ),
              ),
              const Spacer(),
              Text(
                date,
                style: tt.labelSmall?.copyWith(color: AppColors.slate400),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: List.generate(
              5,
              (i) => Icon(
                i < rating ? Icons.star_rounded : Icons.star_border_rounded,
                color: AppColors.warning,
                size: 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            text,
            style: tt.bodySmall?.copyWith(
              height: 1.5,
              color: isDark
                  ? Colors.white.withValues(alpha: 0.7)
                  : AppColors.slate600,
            ),
          ),
        ],
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
