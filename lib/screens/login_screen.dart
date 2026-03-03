import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'profile_setup_screen.dart';
import '../widgets/glow_circle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, _, _) => const ProfileSetupScreen(),
          transitionsBuilder: (_, anim, _, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 400),
        ),
        (_) => false,
      );
    }
  }

  void _navigateToRegister() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const RegisterScreen(),
        transitionsBuilder: (_, anim, _, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 350),
      ),
    );
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
          // ── Decorative glow ──
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.08)),
          ),

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // ── Top bar ──
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
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          AppStrings.logIn,
                          style: tt.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F172A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Content ──
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),

                        // Header
                        FadeTransition(
                          opacity: _headerFade,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.welcomeBack,
                                style: tt.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.5,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                AppStrings.loginSubtitle,
                                style: tt.bodyMedium?.copyWith(
                                  color: isDark
                                      ? Colors.white.withValues(alpha: 0.6)
                                      : const Color(0xFF64748B),
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
                                  // Email
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      hintText: AppStrings.emailHint,
                                      prefixIcon: Icon(
                                        Icons.email_outlined,
                                        color: isDark
                                            ? const Color(0xFF64748B)
                                            : const Color(0xFF94A3B8),
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

                                  const SizedBox(height: 16),

                                  // Password
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    decoration: InputDecoration(
                                      hintText: AppStrings.passwordHint,
                                      prefixIcon: Icon(
                                        Icons.lock_outline_rounded,
                                        color: isDark
                                            ? const Color(0xFF64748B)
                                            : const Color(0xFF94A3B8),
                                        size: 20,
                                      ),
                                      suffixIcon: IconButton(
                                        onPressed: () => setState(
                                          () => _obscurePassword =
                                              !_obscurePassword,
                                        ),
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_off_outlined
                                              : Icons.visibility_outlined,
                                          color: isDark
                                              ? const Color(0xFF64748B)
                                              : const Color(0xFF94A3B8),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.isEmpty) {
                                        return 'Please enter your password';
                                      }
                                      if (v.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 12),

                                  // Forgot password
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const ForgotPasswordScreen(),
                                          ),
                                        );
                                      },
                                      style: TextButton.styleFrom(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        tapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text(
                                        AppStrings.forgotPassword,
                                        style: tt.bodySmall?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 28),

                                  // Login button
                                  ElevatedButton(
                                    onPressed: _onLogin,
                                    child: const Text(AppStrings.logIn),
                                  ),

                                  const SizedBox(height: 24),

                                  // OR divider
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Text(
                                          AppStrings.orDivider,
                                          style: tt.labelSmall?.copyWith(
                                            color: isDark
                                                ? Colors.white.withValues(
                                                    alpha: 0.4,
                                                  )
                                                : const Color(0xFF94A3B8),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Divider(
                                          color: isDark
                                              ? const Color(0xFF334155)
                                              : const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 24),

                                  // Google sign-in
                                  OutlinedButton.icon(
                                    onPressed: () {
                                      // TODO: Google sign-in
                                    },
                                    icon: const Text(
                                      'G',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    label: const Text(
                                      AppStrings.continueWithGoogle,
                                    ),
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
                              onTap: _navigateToRegister,
                              child: Text.rich(
                                TextSpan(
                                  text: AppStrings.noAccount,
                                  style: tt.bodySmall?.copyWith(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : const Color(0xFF64748B),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.signUp,
                                      style: TextStyle(
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
