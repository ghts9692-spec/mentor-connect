import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/strings.dart';
import '../widgets/glow_circle.dart';

class SettingsScreen extends StatefulWidget {
  final bool showNav;
  const SettingsScreen({super.key, this.showNav = true});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;

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
            bottom: -80,
            left: -80,
            child: GlowCircle(color: AppColors.primary.withValues(alpha: 0.07)),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Text(
                      AppStrings.settings,
                      style: tt.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : AppColors.slate900,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Profile header
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.slate800 : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? AppColors.slate700
                              : AppColors.slate100,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [AppColors.primary, Color(0xFF6C3FEC)],
                              ),
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'John Doe',
                                  style: tt.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.slate900,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'john@example.com',
                                  style: tt.bodySmall?.copyWith(
                                    color: AppColors.slate500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: Text(
                              AppStrings.editProfile,
                              style: tt.labelMedium?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Account section
                  _SectionLabel(title: AppStrings.account, isDark: isDark),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.person_outline_rounded,
                    title: AppStrings.personalInfo,
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    icon: Icons.lock_outline_rounded,
                    title: AppStrings.changePassword,
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    icon: Icons.link_rounded,
                    title: AppStrings.linkedAccounts,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 24),

                  // Preferences section
                  _SectionLabel(title: AppStrings.preferences, isDark: isDark),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.notifications_outlined,
                    title: AppStrings.notifications,
                    isDark: isDark,
                    trailing: Switch.adaptive(
                      value: _notificationsEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (v) =>
                          setState(() => _notificationsEnabled = v),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.dark_mode_outlined,
                    title: AppStrings.darkMode,
                    isDark: isDark,
                    trailing: Switch.adaptive(
                      value: _darkModeEnabled,
                      activeTrackColor: AppColors.primary,
                      onChanged: (v) => setState(() => _darkModeEnabled = v),
                    ),
                  ),
                  _SettingsTile(
                    icon: Icons.language_rounded,
                    title: AppStrings.language,
                    isDark: isDark,
                    trailing: Text(
                      AppStrings.english,
                      style: tt.bodySmall?.copyWith(color: AppColors.slate500),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Support section
                  _SectionLabel(title: AppStrings.support, isDark: isDark),
                  const SizedBox(height: 8),
                  _SettingsTile(
                    icon: Icons.help_outline_rounded,
                    title: AppStrings.helpCenter,
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    icon: Icons.shield_outlined,
                    title: AppStrings.privacyPolicy,
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    icon: Icons.description_outlined,
                    title: AppStrings.termsOfService,
                    isDark: isDark,
                  ),
                  _SettingsTile(
                    icon: Icons.info_outline_rounded,
                    title: AppStrings.aboutApp,
                    isDark: isDark,
                  ),

                  const SizedBox(height: 28),

                  // Log Out button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.logout_rounded,
                          color: AppColors.error,
                          size: 20,
                        ),
                        label: Text(
                          AppStrings.logOut,
                          style: tt.bodyMedium?.copyWith(
                            color: AppColors.error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.error),
                          minimumSize: const Size(double.infinity, 52),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Version
                  Center(
                    child: Text(
                      AppStrings.version,
                      style: tt.labelSmall?.copyWith(color: AppColors.slate400),
                    ),
                  ),

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

class _SectionLabel extends StatelessWidget {
  final String title;
  final bool isDark;
  const _SectionLabel({required this.title, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          color: isDark
              ? Colors.white.withValues(alpha: 0.4)
              : AppColors.slate500,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final Widget? trailing;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.isDark,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 4),
          leading: Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: isDark ? AppColors.slate700 : AppColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.slate500, size: 18),
          ),
          title: Text(
            title,
            style: tt.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white : AppColors.slate900,
            ),
          ),
          trailing:
              trailing ??
              Icon(
                Icons.chevron_right_rounded,
                color: isDark ? AppColors.slate500 : AppColors.slate400,
              ),
          onTap: () {},
        ),
      ),
    );
  }
}
