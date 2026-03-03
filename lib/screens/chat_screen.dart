import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../widgets/glow_circle.dart';

class ChatScreen extends StatelessWidget {
  final bool showNav;
  const ChatScreen({super.key, this.showNav = true});

  static final List<Map<String, dynamic>> _conversations = [
    {
      'name': 'Sarah Jenkins',
      'message': "Let's schedule our next session...",
      'time': '2m',
      'unread': 2,
      'online': true,
    },
    {
      'name': 'David Chen',
      'message': 'Thanks for the feedback on my...',
      'time': '1h',
      'unread': 0,
      'online': true,
    },
    {
      'name': 'Emily Watson',
      'message': 'The design review went well!',
      'time': 'Yesterday',
      'unread': 0,
      'online': false,
    },
    {
      'name': 'Michael Kim',
      'message': 'Can we discuss the data pipeline?',
      'time': 'Yesterday',
      'unread': 1,
      'online': false,
    },
    {
      'name': 'Lisa Thompson',
      'message': 'Great leadership workshop today!',
      'time': '2d',
      'unread': 0,
      'online': false,
    },
  ];

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
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.07)),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Text(
                    AppStrings.messages,
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
                      decoration: InputDecoration(
                        hintText: AppStrings.searchConversations,
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

                // Conversation list
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: _conversations.length,
                    separatorBuilder: (_, _) => Divider(
                      height: 1,
                      color: isDark ? AppColors.slate700 : AppColors.slate100,
                    ),
                    itemBuilder: (_, i) {
                      final c = _conversations[i];
                      return _ChatTile(
                        name: c['name'],
                        message: c['message'],
                        time: c['time'],
                        unread: c['unread'],
                        isOnline: c['online'],
                        isDark: isDark,
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

class _ChatTile extends StatelessWidget {
  final String name;
  final String message;
  final String time;
  final int unread;
  final bool isOnline;
  final bool isDark;

  const _ChatTile({
    required this.name,
    required this.message,
    required this.time,
    required this.unread,
    required this.isOnline,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          // Avatar with online indicator
          Stack(
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.1),
                ),
                child: const Icon(
                  Icons.person,
                  color: AppColors.primary,
                  size: 26,
                ),
              ),
              if (isOnline)
                Positioned(
                  bottom: 2,
                  right: 2,
                  child: Container(
                    height: 13,
                    width: 13,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? AppColors.backgroundDark : Colors.white,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: unread > 0 ? FontWeight.w700 : FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.slate900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: tt.bodySmall?.copyWith(
                    color: unread > 0
                        ? (isDark
                              ? Colors.white.withValues(alpha: 0.7)
                              : AppColors.slate700)
                        : (isDark
                              ? Colors.white.withValues(alpha: 0.4)
                              : AppColors.slate400),
                    fontWeight: unread > 0 ? FontWeight.w500 : FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                time,
                style: tt.labelSmall?.copyWith(
                  color: unread > 0
                      ? AppColors.primary
                      : (isDark ? AppColors.slate500 : AppColors.slate400),
                  fontWeight: unread > 0 ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
              if (unread > 0) ...[
                const SizedBox(height: 6),
                Container(
                  height: 20,
                  width: 20,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      unread.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
