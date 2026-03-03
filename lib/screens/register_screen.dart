import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import 'profile_setup_screen.dart';
import '../widgets/glow_circle.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _agreedToTerms = false;

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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onRegister() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_agreedToTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please agree to the Terms and Privacy Policy'),
          ),
        );
        return;
      }
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

  void _navigateToLogin() {
    Navigator.of(context).pop();
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
            bottom: -80,
            left: -80,
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
                          AppStrings.register,
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
                                AppStrings.createAccount,
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
                                AppStrings.registerSubtitle,
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
                                  // Full Name
                                  TextFormField(
                                    controller: _nameController,
                                    keyboardType: TextInputType.name,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    decoration: InputDecoration(
                                      hintText: AppStrings.fullNameHint,
                                      prefixIcon: Icon(
                                        Icons.person_outline_rounded,
                                        color: isDark
                                            ? const Color(0xFF64748B)
                                            : const Color(0xFF94A3B8),
                                        size: 20,
                                      ),
                                    ),
                                    validator: (v) {
                                      if (v == null || v.trim().isEmpty) {
                                        return 'Please enter your full name';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 16),

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
                                        return 'Please enter a password';
                                      }
                                      if (v.length < 8) {
                                        return 'Password must be at least 8 characters';
                                      }
                                      return null;
                                    },
                                  ),

                                  const SizedBox(height: 6),

                                  // Password hint
                                  Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Text(
                                      AppStrings.passwordMinHint,
                                      style: tt.labelSmall?.copyWith(
                                        color: isDark
                                            ? Colors.white.withValues(
                                                alpha: 0.35,
                                              )
                                            : const Color(0xFF94A3B8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  // Terms checkbox
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: Checkbox(
                                          value: _agreedToTerms,
                                          onChanged: (v) => setState(
                                            () => _agreedToTerms = v ?? false,
                                          ),
                                          activeColor: AppColors.primary,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                          side: BorderSide(
                                            color: isDark
                                                ? const Color(0xFF475569)
                                                : const Color(0xFFCBD5E1),
                                            width: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Text.rich(
                                          TextSpan(
                                            text: AppStrings.agreeToTerms,
                                            style: tt.bodySmall?.copyWith(
                                              color: isDark
                                                  ? Colors.white.withValues(
                                                      alpha: 0.5,
                                                    )
                                                  : const Color(0xFF64748B),
                                            ),
                                            children: [
                                              TextSpan(
                                                text: AppStrings.termsOfService,
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              TextSpan(
                                                text: AppStrings.andText,
                                              ),
                                              TextSpan(
                                                text: AppStrings.privacyPolicy,
                                                style: TextStyle(
                                                  color: AppColors.primary,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 28),

                                  // Register button
                                  ElevatedButton(
                                    onPressed: _onRegister,
                                    child: const Text(AppStrings.createAccount),
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
                              onTap: _navigateToLogin,
                              child: Text.rich(
                                TextSpan(
                                  text: AppStrings.alreadyHaveAccount,
                                  style: tt.bodySmall?.copyWith(
                                    color: isDark
                                        ? Colors.white.withValues(alpha: 0.5)
                                        : const Color(0xFF64748B),
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppStrings.logIn,
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
