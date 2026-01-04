import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? _profilePhotoPath;
  String? _profileName;

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _profilePhotoPath = prefs.getString('profile_photo');
      _profileName = prefs.getString('profile_name');
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthState>();
    
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHeader(context, auth),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildMenuCard(
                  context,
                  items: [
                    _MenuItem(
                      icon: Icons.shopping_bag_outlined,
                      title: 'Pesanan Saya',
                      subtitle: 'Lihat riwayat pesanan',
                      color: AppColors.primary,
                      onTap: () => context.go('/orders'),
                    ),
                    _MenuItem(
                      icon: Icons.location_on_outlined,
                      title: 'Alamat Pengiriman',
                      subtitle: 'Kelola alamat tersimpan',
                      color: AppColors.secondary,
                      onTap: () => context.go('/account/addresses'),
                    ),
                    _MenuItem(
                      icon: Icons.payment_outlined,
                      title: 'Metode Pembayaran',
                      subtitle: 'Kartu & e-wallet',
                      color: AppColors.accent,
                      onTap: () => context.go('/account/payment'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildMenuCard(
                  context,
                  items: [
                    _MenuItem(
                      icon: Icons.notifications_outlined,
                      title: 'Notifikasi',
                      subtitle: 'Pengaturan notifikasi',
                      color: AppColors.warning,
                      onTap: () => context.go('/account/notifications'),
                    ),
                    _MenuItem(
                      icon: Icons.help_outline_rounded,
                      title: 'Bantuan',
                      subtitle: 'FAQ & dukungan',
                      color: AppColors.info,
                      onTap: () => context.go('/account/help'),
                    ),
                    _MenuItem(
                      icon: Icons.settings_outlined,
                      title: 'Pengaturan',
                      subtitle: 'Bahasa, tema, privasi',
                      color: AppColors.neutral600,
                      onTap: () => context.go('/account/settings'),
                    ),
                  ],
                ),
                
                const SizedBox(height: 16),
                
                _buildLogoutButton(context, auth),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AuthState auth) {
    final displayName = _profileName ?? auth.user?.fullName ?? 'Guest User';
    
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: AppColors.primary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30), // Top padding
              // Avatar
              GestureDetector(
                onTap: () async {
                  await context.push('/account/edit');
                  _loadProfileData(); 
                },
                child: Stack(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: _profilePhotoPath != null
                            ? DecorationImage(
                                image: FileImage(File(_profilePhotoPath!)),
                                fit: BoxFit.cover,
                              )
                            : null,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: _profilePhotoPath == null
                          ? const Icon(
                              Icons.person,
                              size: 48,
                              color: AppColors.neutral300,
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.accent,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.edit,
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                displayName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                auth.user?.email ?? 'guest@ecommerce.com',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        collapseMode: CollapseMode.parallax,
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, {required List<_MenuItem> items}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04), // Softer shadow
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final isLast = index == items.length - 1;
          
          return Column(
            children: [
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: item.onTap,
                  borderRadius: BorderRadius.vertical(
                    top: index == 0 ? const Radius.circular(16) : Radius.zero,
                    bottom: isLast ? const Radius.circular(16) : Radius.zero,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(item.icon, color: item.color, size: 22),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              if (item.subtitle.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.neutral300,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Divider(height: 1, indent: 80, endIndent: 20, color: AppColors.neutral100),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context, AuthState auth) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: OutlinedButton(
        onPressed: () {
             auth.logout();
             context.go('/login');
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.error, width: 1.5),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          foregroundColor: AppColors.error,
          backgroundColor: Colors.white,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.logout_rounded, size: 20),
            SizedBox(width: 8),
            Text(
              'Keluar Akun',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });
}
