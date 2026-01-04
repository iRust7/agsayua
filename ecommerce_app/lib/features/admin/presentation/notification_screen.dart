import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/theme/colors.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../data/account_service.dart';
import '../data/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final AccountService _service = AccountService();
  late Future<List<AppNotification>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<AppNotification>> _load() async {
    final userId = context.read<AuthState>().user?.id ?? 0;
    return _service.fetchNotifications(userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifikasi'),
      ),
      body: FutureBuilder<List<AppNotification>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const EmptyState(
              icon: Icons.notifications_none,
              title: 'Belum ada notifikasi',
              message: 'Notifikasi promo dan status pesanan akan tampil di sini.',
            );
          }

          final items = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemBuilder: (context, index) {
              final n = items[index];
              return Card(
                color: n.isRead ? AppColors.surface : AppColors.primary.withOpacity(0.05),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: _badgeColor(n.type),
                    child: Icon(
                      _badgeIcon(n.type),
                      color: Colors.white,
                    ),
                  ),
                  title: Text(n.title),
                  subtitle: Text(n.body),
                  trailing: n.isRead ? null : TextButton(
                    onPressed: () async {
                      final userId = context.read<AuthState>().user?.id ?? 0;
                      await _service.markNotificationRead(userId, n.id);
                      setState(() {
                        _future = _load();
                      });
                    },
                    child: const Text('Tandai dibaca'),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemCount: items.length,
          );
        },
      ),
    );
  }

  Color _badgeColor(String type) {
    switch (type) {
      case 'promo':
        return Colors.purple;
      case 'order':
        return Colors.green;
      default:
        return Colors.blueGrey;
    }
  }

  IconData _badgeIcon(String type) {
    switch (type) {
      case 'promo':
        return Icons.local_offer;
      case 'order':
        return Icons.receipt_long;
      default:
        return Icons.notifications;
    }
  }
}
