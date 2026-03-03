import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../widgets/glow_circle.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  late AnimationController _animController;
  late Animation<double> _headerFade;
  late Animation<double> _formFade;
  late Animation<Offset> _formSlide;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _headerFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );
    _formFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
    );
    _formSlide = Tween<Offset>(begin: const Offset(0, 0.08), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.3, 0.8, curve: Curves.easeOut),
          ),
        );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _onSendResetLink() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset link sent! Check your email.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Decorative glow
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.08)),
          ),
          Positioned(
            bottom: -80,
            left: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.08)),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Top bar
                SliverToBoxAdapter(
                  child: Padding(
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
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.resetPassword,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppColors.slate900,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      children: [
                        const SizedBox(height: 48),

                        // Lock icon
                        FadeTransition(
                          opacity: _headerFade,
                          child: Container(
                            height: 88,
                            width: 88,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.lock_reset_rounded,
                              color: AppColors.primary,
                              size: 44,
                            ),
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Headline
                        FadeTransition(
                          opacity: _headerFade,
                          child: Column(
                            children: [
                              Text(
                                AppStrings.forgotPasswordHeadline,
                                textAlign: TextAlign.center,
                                style: tt.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.slate900,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                AppStrings.forgotPasswordSubtitle,
                                textAlign: TextAlign.center,
                                style: tt.bodyMedium?.copyWith(
                                  height: 1.5,
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : AppColors.slate500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Form
                        FadeTransition(
                          opacity: _formFade,
                          child: SlideTransition(
                            position: _formSlide,
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: AppStrings.emailHint,
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: isDark
                                            ? AppColors.slate500
                                            : AppColors.slate400,
                                        size: 20,
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Please enter your email';
                                      }
                                      if (!v.contains('@')) {
                                        return 'Please enter a valid email';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 28),

                                  ElevatedButton(
                                    onPressed: _onSendResetLink,
                                    child: const Text(AppStrings.sendResetLink),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        // Bottom link
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 32),
                            child: GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: Text.rich(
                                TextSpan(
                                  text: AppStrings.rememberPassword,
                                  style: tt.bodySmall?.copyWith(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : AppColors.slate500,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.logIn,
                                      style: const TextStyle(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
