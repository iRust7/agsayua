import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Metode Pembayaran'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _buildSection(
            title: 'Kartu Tersimpan',
            icon: Icons.credit_card_rounded,
            children: [
              _buildPaymentCard(
                icon: Icons.credit_card,
                title: 'Visa ****1234',
                subtitle: 'Expires 12/26',
                isSelected: true,
              ),
            ],
          ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
          
          const SizedBox(height: 16),
          
          _buildSection(
            title: 'E-Wallet',
            icon: Icons.account_balance_wallet_rounded,
            children: [
              _buildPaymentCard(
                icon: Icons.wallet,
                title: 'GoPay',
                subtitle: 'Terhubung',
                color: const Color(0xFF00AED6),
              ),
              _buildPaymentCard(
                icon: Icons.wallet,
                title: 'OVO',
                subtitle: 'Terhubung',
                color: const Color(0xFF4C3494),
              ),
              _buildPaymentCard(
                icon: Icons.wallet,
                title: 'DANA',
                subtitle: 'Belum terhubung',
                color: const Color(0xFF108EE9),
              ),
            ],
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          
          const SizedBox(height: 24),
          
          OutlinedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tambah metode pembayaran - Coming soon!')),
              );
            },
            icon: const Icon(Icons.add_rounded),
            label: const Text('Tambah Metode Pembayaran'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ).animate().fadeIn(delay: 300.ms),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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

  Widget _buildPaymentCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? color,
    bool isSelected = false,
  }) {
    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? AppColors.primary),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: isSelected
          ? Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, color: Colors.white, size: 16),
            )
          : const Icon(Icons.chevron_right_rounded, color: AppColors.neutral400),
    );
  }
}
