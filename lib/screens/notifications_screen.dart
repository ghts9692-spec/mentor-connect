import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';

class NotificationsScreen extends StatelessWidget {
  final bool showNav;
  const NotificationsScreen({super.key, this.showNav = true});

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
                // Title row
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    children: [
                      Text(
                        AppStrings.notifications,
                        style: tt.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          AppStrings.markAllRead,
                          style: tt.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    children: [
                      // Today
                      _GroupHeader(title: AppStrings.today, isDark: isDark),
                      const SizedBox(height: 12),
                      _NotifCard(
                        icon: Icons.event_available_rounded,
                        iconColor: AppColors.primary,
                        title: 'Session Confirmed',
                        body:
                            'Your session with Sarah Jenkins is confirmed for tomorrow at 10 AM.',
                        time: '2 hours ago',
                        isUnread: true,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _NotifCard(
                        icon: Icons.check_circle_rounded,
                        iconColor: AppColors.success,
                        title: 'New Mentor Match',
                        body:
                            'David Chen matches your interests in Product Design.',
                        time: '5 hours ago',
                        isUnread: false,
                        isDark: isDark,
                      ),

                      const SizedBox(height: 24),

                      // Earlier
                      _GroupHeader(title: AppStrings.earlier, isDark: isDark),
                      const SizedBox(height: 12),
                      _NotifCard(
                        icon: Icons.notifications_active_rounded,
                        iconColor: AppColors.warning,
                        title: 'Session Reminder',
                        body:
                            "Don't forget your session with Emily Watson today at 3 PM.",
                        time: 'Yesterday',
                        isUnread: false,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _NotifCard(
                        icon: Icons.chat_bubble_rounded,
                        iconColor: AppColors.primary,
                        title: 'New Message',
                        body: 'Sarah Jenkins sent you a message.',
                        time: '2 days ago',
                        isUnread: false,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 10),
                      _NotifCard(
                        icon: Icons.star_rounded,
                        iconColor: const Color(0xFF8B5CF6),
                        title: 'Leave a Review',
                        body: 'How was your session with Alex Rivera?',
                        time: '3 days ago',
                        isUnread: false,
                        isDark: isDark,
                      ),
                    ],
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

class _GroupHeader extends StatelessWidget {
  final String title;
  final bool isDark;
  const _GroupHeader({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: isDark
            ? Colors.white.withValues(alpha: 0.5)
            : AppColors.slate500,
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String body;
  final String time;
  final bool isUnread;
  final bool isDark;

  const _NotifCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: tt.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                    ),
                    if (isUnread)
                      Container(
                        height: 8,
                        width: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: tt.bodySmall?.copyWith(
                    height: 1.4,
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.6)
                        : AppColors.slate500,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  time,
                  style: tt.labelSmall?.copyWith(
                    color: isDark ? AppColors.slate500 : AppColors.slate400,
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
