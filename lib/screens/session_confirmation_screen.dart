import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../models/session_model.dart';
import '../widgets/glow_circle.dart';
import 'home_dashboard_screen.dart';
import 'my_sessions_screen.dart';

class SessionConfirmationScreen extends StatefulWidget {
  final Session session;

  const SessionConfirmationScreen({super.key, required this.session});

  @override
  State<SessionConfirmationScreen> createState() =>
      _SessionConfirmationScreenState();
}

class _SessionConfirmationScreenState extends State<SessionConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _scaleAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    );
    _fadeAnim = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _formatDate(DateTime dt) {
    const months = [
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
    final h = dt.hour > 12
        ? dt.hour - 12
        : dt.hour == 0
        ? 12
        : dt.hour;
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final min = dt.minute.toString().padLeft(2, '0');
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year} • $h:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;
    final session = widget.session;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Stack(
        children: [
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(color: AppColors.success.withValues(alpha: 0.08)),
          ),
          Positioned(
            bottom: -60,
            left: -60,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.07)),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated checkmark
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success.withValues(alpha: 0.12),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.3),
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                        size: 52,
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  FadeTransition(
                    opacity: _fadeAnim,
                    child: Column(
                      children: [
                        Text(
                          AppStrings.sessionConfirmed,
                          style: tt.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.slate900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.sessionConfirmedSubtitle,
                          style: tt.bodyMedium?.copyWith(
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.6)
                                : AppColors.slate500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 36),

                        // Session details card
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.slate800
                                : AppColors.slate50,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.slate700
                                  : AppColors.slate200,
                            ),
                          ),
                          child: Column(
                            children: [
                              _DetailRow(
                                icon: Icons.person_rounded,
                                label: 'Mentor',
                                value: session.mentorName,
                                isDark: isDark,
                              ),
                              const Divider(height: 20),
                              _DetailRow(
                                icon: Icons.topic_rounded,
                                label: 'Topic',
                                value: session.topic,
                                isDark: isDark,
                              ),
                              const Divider(height: 20),
                              _DetailRow(
                                icon: Icons.schedule_rounded,
                                label: 'Date & Time',
                                value: _formatDate(session.dateTime),
                                isDark: isDark,
                              ),
                              const Divider(height: 20),
                              _DetailRow(
                                icon: Icons.timer_rounded,
                                label: 'Duration',
                                value: session.duration,
                                isDark: isDark,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // CTA buttons
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const MySessionsScreen(),
                              ),
                              (route) => route.isFirst,
                            );
                          },
                          child: const Text(AppStrings.viewMySessions),
                        ),

                        const SizedBox(height: 12),

                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomeDashboardScreen(),
                              ),
                              (_) => false,
                            );
                          },
                          child: const Text(AppStrings.backToHome),
                        ),
                      ],
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

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: tt.labelSmall?.copyWith(color: AppColors.slate500),
            ),
            Text(
              value,
              style: tt.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.slate900,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
