import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';

class BookSessionScreen extends StatefulWidget {
  const BookSessionScreen({super.key});

  @override
  State<BookSessionScreen> createState() => _BookSessionScreenState();
}

class _BookSessionScreenState extends State<BookSessionScreen>
    with SingleTickerProviderStateMixin {
  int _selectedDateIndex = 2;
  int _selectedTimeIndex = 2;
  String _selectedTopic = AppStrings.careerGuidance;
  String _selectedDuration = AppStrings.sixtyMin;

  late AnimationController _animController;
  late Animation<double> _fade;

  final List<Map<String, String>> _dates = [
    {'day': 'Mon', 'date': '3'},
    {'day': 'Tue', 'date': '4'},
    {'day': 'Wed', 'date': '5'},
    {'day': 'Thu', 'date': '6'},
    {'day': 'Fri', 'date': '7'},
    {'day': 'Sat', 'date': '8'},
    {'day': 'Sun', 'date': '9'},
  ];

  final List<String> _times = [
    '9:00 AM',
    '10:00 AM',
    '11:00 AM',
    '1:00 PM',
    '2:00 PM',
    '3:00 PM',
    '4:00 PM',
    '5:00 PM',
  ];

  final List<int> _unavailableTimes = [0, 5]; // indices of unavailable slots

  final List<String> _topics = [
    AppStrings.careerGuidance,
    AppStrings.portfolioReview,
    AppStrings.designFeedback,
    AppStrings.mockInterview,
    AppStrings.generalMentoring,
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fade = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

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
              color: AppColors.primary.withValues(alpha: 0.07),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top bar
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
                      const SizedBox(width: 4),
                      Text(
                        AppStrings.bookSession,
                        style: tt.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppColors.slate900,
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: FadeTransition(
                    opacity: _fade,
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),

                          // Mentor info card
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.slate800
                                  : AppColors.slate50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.slate700
                                    : AppColors.slate200,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: const LinearGradient(
                                      colors: [
                                        AppColors.primary,
                                        Color(0xFF6C3FEC),
                                      ],
                                    ),
                                  ),
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Sarah Jenkins',
                                        style: tt.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.w700,
                                          color: isDark
                                              ? Colors.white
                                              : AppColors.slate900,
                                        ),
                                      ),
                                      Text(
                                        'Product Designer',
                                        style: tt.labelSmall?.copyWith(
                                          color: AppColors.slate500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: AppColors.warning,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '4.9',
                                      style: tt.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: isDark
                                            ? Colors.white
                                            : AppColors.slate900,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Select Date
                          _SectionTitle(
                            title: AppStrings.selectDate,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          SizedBox(
                            height: 76,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: _dates.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 10),
                              itemBuilder: (_, i) {
                                final d = _dates[i];
                                final isSelected = i == _selectedDateIndex;
                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => _selectedDateIndex = i),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    width: 52,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary
                                          : isDark
                                          ? AppColors.slate800
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : isDark
                                            ? AppColors.slate700
                                            : AppColors.slate200,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          d['day']!,
                                          style: tt.labelSmall?.copyWith(
                                            color: isSelected
                                                ? Colors.white.withValues(
                                                    alpha: 0.8,
                                                  )
                                                : AppColors.slate500,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          d['date']!,
                                          style: tt.titleMedium?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: isSelected
                                                ? Colors.white
                                                : isDark
                                                ? Colors.white
                                                : AppColors.slate900,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Select Time
                          _SectionTitle(
                            title: AppStrings.selectTime,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: List.generate(_times.length, (i) {
                              final isSelected = i == _selectedTimeIndex;
                              final isUnavailable = _unavailableTimes.contains(
                                i,
                              );
                              return GestureDetector(
                                onTap: isUnavailable
                                    ? null
                                    : () => setState(
                                        () => _selectedTimeIndex = i,
                                      ),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : isUnavailable
                                        ? (isDark
                                              ? AppColors.slate800
                                              : AppColors.slate100)
                                        : isDark
                                        ? AppColors.slate800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : isDark
                                          ? AppColors.slate700
                                          : AppColors.slate200,
                                    ),
                                  ),
                                  child: Text(
                                    _times[i],
                                    style: tt.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : isUnavailable
                                          ? AppColors.slate400
                                          : isDark
                                          ? Colors.white
                                          : AppColors.slate700,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),

                          const SizedBox(height: 28),

                          // Session Topic
                          _SectionTitle(
                            title: AppStrings.sessionTopic,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: _topics.map((t) {
                              final isSelected = t == _selectedTopic;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedTopic = t),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? AppColors.primary
                                        : isDark
                                        ? AppColors.slate800
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : isDark
                                          ? AppColors.slate700
                                          : AppColors.slate200,
                                    ),
                                  ),
                                  child: Text(
                                    t,
                                    style: tt.bodySmall?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color: isSelected
                                          ? Colors.white
                                          : isDark
                                          ? Colors.white.withValues(alpha: 0.7)
                                          : AppColors.slate700,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),

                          const SizedBox(height: 28),

                          // Duration
                          _SectionTitle(
                            title: AppStrings.sessionDuration,
                            isDark: isDark,
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _DurationBtn(
                                  label: AppStrings.thirtyMin,
                                  isSelected:
                                      _selectedDuration == AppStrings.thirtyMin,
                                  isDark: isDark,
                                  onTap: () => setState(
                                    () => _selectedDuration =
                                        AppStrings.thirtyMin,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _DurationBtn(
                                  label: AppStrings.sixtyMin,
                                  isSelected:
                                      _selectedDuration == AppStrings.sixtyMin,
                                  isDark: isDark,
                                  onTap: () => setState(
                                    () =>
                                        _selectedDuration = AppStrings.sixtyMin,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Bottom bar
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
                  Text(
                    '\$50',
                    style: tt.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.slate900,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Session booked successfully!'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(AppStrings.confirmBooking),
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

class _SectionTitle extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionTitle({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: isDark ? Colors.white : AppColors.slate900,
      ),
    );
  }
}

class _DurationBtn extends StatelessWidget {
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _DurationBtn({
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : isDark
              ? AppColors.slate800
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : isDark
                ? AppColors.slate700
                : AppColors.slate200,
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isDark
                ? Colors.white
                : AppColors.slate700,
          ),
        ),
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
