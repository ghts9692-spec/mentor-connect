import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../widgets/glow_circle.dart';
import 'welcome_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Animation controller for the logo: fade + scale entrance
  late AnimationController _logoController;
  late Animation<double> _logoFade;
  late Animation<double> _logoScale;

  // Animation controller for the bottom text: fade + slide up
  late AnimationController _textController;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  // Animation controller for the pulse bar: looping
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // --- Logo entrance animation ---
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _logoFade = CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOut),
    );
    _logoScale = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 1.0, curve: Curves.elasticOut),
      ),
    );

    // --- Bottom text entrance animation (delayed) ---
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textFade = CurvedAnimation(parent: _textController, curve: Curves.easeOut);
    _textSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeOut));

    // --- Pulsing loading bar ---
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    // Start the sequence
    _logoController.forward().then((_) {
      _textController.forward();
    });

    // Auto-navigate to Welcome after delay
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const WelcomeScreen(),
            transitionsBuilder: (_, anim, _, child) {
              return FadeTransition(
                opacity: CurvedAnimation(parent: anim, curve: Curves.easeOut),
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cs = Theme.of(context).colorScheme;

    // Make status bar transparent & match splash bg
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        systemNavigationBarColor: isDark
            ? AppColors.backgroundDark
            : Colors.white,
      ),
    );

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // ── Decorative soft glow – Top Right ──
          Positioned(
            top: -80,
            right: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.12)),
          ),

          // ── Decorative soft glow – Bottom Left ──
          Positioned(
            bottom: -80,
            left: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.12)),
          ),

          // ── Main content ──
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(flex: 5),

                  // Logo
                  FadeTransition(
                    opacity: _logoFade,
                    child: ScaleTransition(
                      scale: _logoScale,
                      child: _LogoBox(),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Pulse bar
                  AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, _) {
                      return _PulseBar(
                        progress: _pulseAnimation.value,
                        isDark: isDark,
                      );
                    },
                  ),

                  const Spacer(flex: 6),

                  // Bottom text
                  FadeTransition(
                    opacity: _textFade,
                    child: SlideTransition(
                      position: _textSlide,
                      child: _BottomText(isDark: isDark, cs: cs),
                    ),
                  ),

                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════
// Sub-widgets (private, focused, reusable)
// ════════════════════════════════════════════

/// The icon box with gradient shine and shadow.
class _LogoBox extends StatelessWidget {
  const _LogoBox();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      width: 128,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 48,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Inner shine gradient (top-left → transparent)
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: const [0.0, 0.55],
                colors: [
                  Colors.white.withValues(alpha: 0.22),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          const Center(
            child: Icon(
              Icons.diversity_3_rounded,
              color: Colors.white,
              size: 62,
            ),
          ),
        ],
      ),
    );
  }
}

/// Animated horizontal pulse bar.
class _PulseBar extends StatelessWidget {
  final double progress;
  final bool isDark;
  const _PulseBar({required this.progress, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5,
      width: 52,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Stack(
          children: [
            // Track
            Container(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.08)
                  : Colors.black.withValues(alpha: 0.06),
            ),
            // Active fill
            FractionallySizedBox(
              widthFactor: 0.3 + (progress * 0.7),
              child: Container(
                decoration: const BoxDecoration(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// App name, tagline, and version footer.
class _BottomText extends StatelessWidget {
  final bool isDark;
  final ColorScheme cs;
  const _BottomText({required this.isDark, required this.cs});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          AppStrings.appName,
          textAlign: TextAlign.center,
          style: tt.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.8,
            height: 1.15,
            color: isDark ? Colors.white : const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.tagline,
          textAlign: TextAlign.center,
          style: tt.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: isDark
                ? Colors.white.withValues(alpha: 0.55)
                : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 36),
        Text(
          AppStrings.version,
          style: tt.labelSmall?.copyWith(
            fontWeight: FontWeight.w400,
            letterSpacing: 0.4,
            color: isDark
                ? Colors.white.withValues(alpha: 0.25)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
