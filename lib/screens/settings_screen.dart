// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();
    final language = context.watch<LanguageProvider>();
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // ── Appearance ─────────────────────────────────────────────
          _SectionHeader(title: 'Appearance'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.dark_mode_rounded,
                iconColor: const Color(0xFF6C63FF),
                title: 'Dark Mode',
                subtitle: theme.isDarkMode ? 'Currently dark' : 'Currently light',
                trailing: Switch.adaptive(
                  value: theme.isDarkMode,
                  onChanged: (_) => theme.toggleTheme(),
                  activeColor: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── Language ───────────────────────────────────────────────
          _SectionHeader(title: 'Language'),
          _SettingsCard(
            children: [
              _LanguageTile(
                langCode: 'en',
                label: 'English',
                emoji: '🇬🇧',
                isSelected: language.languageCode == 'en',
                onTap: () => language.setLanguage('en'),
              ),
              Divider(height: 1, indent: 56, color: Colors.grey.withOpacity(0.2)),
              _LanguageTile(
                langCode: 'hi',
                label: 'हिंदी (Hindi)',
                emoji: '🇮🇳',
                isSelected: language.languageCode == 'hi',
                onTap: () => language.setLanguage('hi'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // ── About ──────────────────────────────────────────────────
          _SectionHeader(title: 'About'),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.info_outline_rounded,
                iconColor: Colors.blue,
                title: 'Version',
                subtitle: '1.0.0',
                trailing: const SizedBox.shrink(),
              ),
              // Divider(height: 1, indent: 56, color: Colors.grey.withOpacity(0.2)),
              // _SettingsTile(
              //   icon: Icons.code_rounded,
              //   iconColor: Colors.green,
              //   title: 'Built with Flutter',
              //   subtitle: 'Open source & free',
              //   trailing: const Icon(Icons.open_in_new_rounded, size: 18),
              // ),
              // Divider(height: 1, indent: 56, color: Colors.grey.withOpacity(0.2)),
              // _SettingsTile(
              //   icon: Icons.privacy_tip_outlined,
              //   iconColor: Colors.orange,
              //   title: 'Privacy Policy',
              //   subtitle: 'Learn how we use your data',
              //   trailing: const Icon(Icons.chevron_right_rounded),
              //   onTap: () {},
              // ),
              // Divider(height: 1, indent: 56, color: Colors.grey.withOpacity(0.2)),
              // _SettingsTile(
              //   icon: Icons.star_outline_rounded,
              //   iconColor: Colors.amber,
              //   title: 'Rate the App',
              //   subtitle: 'Your feedback matters',
              //   trailing: const Icon(Icons.chevron_right_rounded),
              //   onTap: () {},
              // ),
            ],
          ),
          const SizedBox(height: 32),

          // App logo / footer
          Center(
            child: Column(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Center(
                    child: Text('📖', style: TextStyle(fontSize: 32)),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'QuoteNest',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Wisdom in Every Word',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          if (!isDark)
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(children: children),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        subtitle,
        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
      ),
      trailing: trailing,
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String langCode;
  final String label;
  final String emoji;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.langCode,
    required this.label,
    required this.emoji,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
      leading: Text(emoji, style: const TextStyle(fontSize: 28)),
      title: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          color: isSelected ? primary : null,
        ),
      ),
      trailing: isSelected
          ? Icon(Icons.check_circle_rounded, color: primary)
          : Icon(Icons.radio_button_unchecked_rounded, color: Colors.grey.shade400),
    );
  }
}
