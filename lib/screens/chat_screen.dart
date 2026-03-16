import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../models/conversation_model.dart';
import '../providers/chat_provider.dart';
import '../widgets/glow_circle.dart';
import 'chat_detail_screen.dart';

class ChatScreen extends ConsumerWidget {
  final bool showNav;
  const ChatScreen({super.key, this.showNav = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;
    final conversationsAsync = ref.watch(conversationsProvider);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.backgroundDark
          : AppColors.backgroundLight,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ─── Header ──────────────────────────────────────────────
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

                // ─── Search Bar ───────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.slate800 : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                            isDark ? AppColors.slate700 : AppColors.slate200,
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

                // ─── Conversation List ─────────────────────────────────────
                Expanded(
                  child: conversationsAsync.when(
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    error: (e, _) => Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.wifi_off_rounded,
                            size: 52,
                            color: isDark
                                ? AppColors.slate600
                                : AppColors.slate300,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Could not load messages.',
                            style: tt.bodyMedium?.copyWith(
                              color: isDark
                                  ? AppColors.slate400
                                  : AppColors.slate500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton.icon(
                            onPressed: () =>
                                ref.invalidate(conversationsProvider),
                            icon: const Icon(Icons.refresh_rounded),
                            label: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                    data: (conversations) {
                      if (conversations.isEmpty) {
                        return _EmptyConversations(isDark: isDark);
                      }
                      return ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: conversations.length,
                        separatorBuilder: (_, __) => Divider(
                          height: 1,
                          color:
                              isDark ? AppColors.slate700 : AppColors.slate100,
                        ),
                        itemBuilder: (_, i) {
                          final c = conversations[i];
                          return _ChatTile(
                            conversation: c,
                            isDark: isDark,
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    ChatDetailScreen(conversation: c),
                              ),
                            ),
                          );
                        },
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

// ─── Empty State ──────────────────────────────────────────────────────────────
class _EmptyConversations extends StatelessWidget {
  final bool isDark;
  const _EmptyConversations({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: 42,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No Messages Yet',
            style: tt.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white : AppColors.slate900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Conversations with your mentors\nwill appear here.',
            textAlign: TextAlign.center,
            style: tt.bodySmall?.copyWith(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.5)
                  : AppColors.slate500,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Chat Tile ────────────────────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final Conversation conversation;
  final bool isDark;
  final VoidCallback onTap;

  const _ChatTile({
    required this.conversation,
    required this.isDark,
    required this.onTap,
  });

  /// Format lastMessageTime as relative time label (e.g. "2m", "1h", "Yesterday")
  String _relativeTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d';
    return '${dt.day}/${dt.month}';
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    final unread = conversation.unreadCount;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Avatar with online dot
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
                if (conversation.isOnline)
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
                          color: isDark
                              ? AppColors.backgroundDark
                              : Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Name + last message
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    conversation.participantName,
                    style: tt.bodyMedium?.copyWith(
                      fontWeight:
                          unread > 0 ? FontWeight.w700 : FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    conversation.lastMessage,
                    style: tt.bodySmall?.copyWith(
                      color: unread > 0
                          ? (isDark
                                ? Colors.white.withValues(alpha: 0.7)
                                : AppColors.slate700)
                          : (isDark
                                ? Colors.white.withValues(alpha: 0.4)
                                : AppColors.slate400),
                      fontWeight:
                          unread > 0 ? FontWeight.w500 : FontWeight.w400,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Time + unread badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _relativeTime(conversation.lastMessageTime),
                  style: tt.labelSmall?.copyWith(
                    color: unread > 0
                        ? AppColors.primary
                        : (isDark ? AppColors.slate500 : AppColors.slate400),
                    fontWeight:
                        unread > 0 ? FontWeight.w600 : FontWeight.w400,
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
                        unread > 9 ? '9+' : unread.toString(),
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
      ),
    );
  }
}
