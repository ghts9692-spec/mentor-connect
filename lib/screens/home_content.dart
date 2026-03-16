import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../models/mentor_model.dart';
import '../providers/user_provider.dart';
import '../providers/sessions_provider.dart';
import 'mentor_profile_screen.dart';
import '../widgets/glow_circle.dart';

/// The home tab content (shown inside HomeDashboardScreen).
class HomeContent extends ConsumerWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;
    final user = ref.watch(userProvider);
    final displayName = user?.name.split(' ').first ?? 'there';

    // Session calculations
    final sessionsAsync = ref.watch(sessionsProvider);
    final sessions = sessionsAsync.value ?? [];

    final totalSessions = sessions.length;
    final uniqueMentors = sessions.map((s) => s.mentorId).toSet().length;

    int totalMinutes = 0;
    for (final s in sessions) {
      final mins =
          int.tryParse(s.duration.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
      totalMinutes += mins;
    }
    final totalHours = (totalMinutes / 60).round();

    final upcomingSessions =
        sessions
            .where(
              (s) =>
                  s.status == 'upcoming' && s.dateTime.isAfter(DateTime.now()),
            )
            .toList()
          ..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    String formatSessionTime(DateTime dt) {
      final now = DateTime.now();
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final isTomorrow =
          dt.year == tomorrow.year &&
          dt.month == tomorrow.month &&
          dt.day == tomorrow.day;

      final timeStr =
          '${dt.hour > 12
              ? dt.hour - 12
              : dt.hour == 0
              ? 12
              : dt.hour}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';

      if (isTomorrow) return 'Tomorrow, $timeStr';
      final months = [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ];
      return '${months[dt.month - 1]} ${dt.day}, $timeStr';
    }

    // Use first 3 sample mentors for recommendations
    final recommendedMentors = Mentor.sampleMentors.take(3).toList();

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.07)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Greeting Row
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${AppStrings.goodMorning}, $displayName 👋',
                              style: tt.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.slate900,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.readyToLearn,
                              style: tt.bodyMedium?.copyWith(
                                color: isDark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : AppColors.slate500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 48,
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.slate800 : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color: isDark
                                ? AppColors.slate700
                                : AppColors.slate200,
                          ),
                        ),
                        child: Stack(
                          children: [
                            const Center(
                              child: Icon(
                                Icons.notifications_outlined,
                                size: 24,
                                color: AppColors.slate500,
                              ),
                            ),
                            Positioned(
                              top: 10,
                              right: 10,
                              child: Container(
                                height: 10,
                                width: 10,
                                decoration: BoxDecoration(
                                  color: AppColors.error,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.slate800
                                        : Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.videocam_rounded,
                          value: '$totalSessions',
                          label: AppStrings.sessions,
                          color: AppColors.primary,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.people_rounded,
                          value: '$uniqueMentors',
                          label: AppStrings.mentors,
                          color: AppColors.success,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.schedule_rounded,
                          value: '$totalHours',
                          label: AppStrings.hours,
                          color: AppColors.warning,
                          isDark: isDark,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Recommended Mentors
                  _SectionHeader(
                    title: AppStrings.recommendedMentors,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    height: 200,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: recommendedMentors.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 14),
                      itemBuilder: (_, i) {
                        final m = recommendedMentors[i];
                        return _MentorCard(
                          name: m.name,
                          expertise: m.expertise,
                          rating: m.rating,
                          isDark: isDark,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MentorProfileScreen(mentor: m),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Upcoming Sessions
                  _SectionHeader(
                    title: AppStrings.upcomingSessions,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 14),

                  if (upcomingSessions.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Text(
                          'No upcoming sessions yet.',
                          style: tt.bodyMedium?.copyWith(
                            color: isDark ? Colors.white54 : AppColors.slate500,
                          ),
                        ),
                      ),
                    )
                  else ...[
                    if (upcomingSessions.isNotEmpty)
                      _SessionCard(
                        mentorName: upcomingSessions[0].mentorName,
                        topic: upcomingSessions[0].topic,
                        dateTime: formatSessionTime(
                          upcomingSessions[0].dateTime,
                        ),
                        status:
                            upcomingSessions[0].status[0].toUpperCase() +
                            upcomingSessions[0].status.substring(1),
                        statusColor: AppColors.success,
                        isDark: isDark,
                      ),
                    if (upcomingSessions.length > 1)
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: _SessionCard(
                          mentorName: upcomingSessions[1].mentorName,
                          topic: upcomingSessions[1].topic,
                          dateTime: formatSessionTime(
                            upcomingSessions[1].dateTime,
                          ),
                          status:
                              upcomingSessions[1].status[0].toUpperCase() +
                              upcomingSessions[1].status.substring(1),
                          statusColor: AppColors
                              .warning, // Using warning color for the 'Pending' look if desired, or just primary
                          isDark: isDark,
                        ),
                      ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════
// Sub-widgets
// ═══════════════════════════════════════

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;
  final bool isDark;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate100,
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: tt.titleLarge?.copyWith(
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final bool isDark;

  const _SectionHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          title,
          style: tt.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.slate900,
          ),
        ),
        const Spacer(),
        Text(
          AppStrings.seeAll,
          style: tt.bodySmall?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _MentorCard extends StatelessWidget {
  final String name;
  final String expertise;
  final double rating;
  final bool isDark;
  final VoidCallback onTap;

  const _MentorCard({
    required this.name,
    required this.expertise,
    required this.rating,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 160,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.slate800 : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.slate700 : AppColors.slate100,
          ),
        ),
        child: Column(
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
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  rating.toString(),
                  style: tt.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.slate900,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              AppStrings.connect,
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

class _SessionCard extends StatelessWidget {
  final String mentorName;
  final String topic;
  final String dateTime;
  final String status;
  final Color statusColor;
  final bool isDark;

  const _SessionCard({
    required this.mentorName,
    required this.topic,
    required this.dateTime,
    required this.status,
    required this.statusColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.slate800 : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.slate700 : AppColors.slate100,
        ),
      ),
      child: Row(
        children: [
          Container(
            height: 44,
            width: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.1),
            ),
            child: const Icon(Icons.person, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$mentorName • $dateTime',
                  style: tt.labelSmall?.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.5)
                        : AppColors.slate500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: statusColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              status,
              style: tt.labelSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
