import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/settings_state.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSection(
            context,
            title: 'Tampilan',
            children: [
              _buildSwitchTile(
                icon: Icons.dark_mode_rounded,
                title: 'Mode Gelap',
                subtitle: 'Gunakan tema gelap',
                value: settings.isDarkMode,
                onChanged: (v) => settings.setDarkMode(v),
              ),
              _buildNavigationTile(
                context,
                icon: Icons.language_rounded,
                title: 'Bahasa',
                value: settings.locale == 'id' ? 'Indonesia' : 'English',
                onTap: () => _showLanguageDialog(context, settings),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildSection(
            context,
            title: 'Notifikasi',
            children: [
              _buildSwitchTile(
                icon: Icons.notifications_rounded,
                title: 'Push Notifications',
                subtitle: 'Terima notifikasi pesanan',
                value: true,
                onChanged: (v) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Pengaturan notifikasi disimpan')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildSection(
            context,
            title: 'Keamanan',
            children: [
              _buildSwitchTile(
                icon: Icons.fingerprint_rounded,
                title: 'Login Biometrik',
                subtitle: 'Gunakan sidik jari/wajah',
                value: settings.isBiometricEnabled,
                onChanged: (v) => settings.setBiometricEnabled(v),
              ),
              _buildNavigationTile(
                context,
                icon: Icons.password_rounded,
                title: 'Ubah Password',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Ubah password - Coming soon!')),
                  );
                },
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildSection(
            context,
            title: 'Lainnya',
            children: [
              _buildNavigationTile(
                context,
                icon: Icons.privacy_tip_rounded,
                title: 'Kebijakan Privasi',
                onTap: () {},
              ),
              _buildNavigationTile(
                context,
                icon: Icons.description_rounded,
                title: 'Syarat & Ketentuan',
                onTap: () {},
              ),
              _buildNavigationTile(
                context,
                icon: Icons.info_rounded,
                title: 'Tentang Aplikasi',
                value: 'v1.0.0',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).textTheme.bodySmall?.color,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.cardShadow,
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      subtitle: subtitle != null ? Text(subtitle, style: const TextStyle(fontSize: 12)) : null,
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildNavigationTile(BuildContext context, {
    required IconData icon,
    required String title,
    String? value,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.primary.withAlpha(25),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppColors.primary, size: 22),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(value, style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color)),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, SettingsState settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Pilih Bahasa'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption(context, settings, 'Indonesia', 'id'),
            _buildLanguageOption(context, settings, 'English', 'en'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(BuildContext context, SettingsState settings, String name, String code) {
    final isSelected = settings.locale == code;
    return ListTile(
      onTap: () {
        settings.setLocale(code);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bahasa diubah ke $name'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      title: Text(name),
      trailing: isSelected
          ? const Icon(Icons.check_circle, color: AppColors.primary)
          : null,
    );
  }
}
