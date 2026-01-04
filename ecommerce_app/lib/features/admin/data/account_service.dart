import '../../../core/network/api_client.dart';
import 'address_model.dart';
import 'notification_model.dart';

class AccountService {
  final ApiClient _client = apiClient;

  Future<List<Address>> fetchAddresses(int userId) async {
    try {
      final response = await _client.get<List<Address>>(
        'users/$userId/addresses',
        fromJson: (data) => (data as List)
            .map((item) => Address.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      return response.data ?? [];
    } catch (_) {
      // Fallback demo data if API not ready
      return _demoAddresses(userId);
    }
  }

  Future<Address> addAddress(int userId, Address address) async {
    final response = await _client.post<Address>(
      'users/$userId/addresses',
      body: {
        'label': address.label,
        'recipient_name': address.recipientName,
        'phone': address.phone,
        'street': address.street,
        'city': address.city,
        'state': address.state,
        'postal_code': address.postalCode,
        'is_default': address.isDefault ? 1 : 0,
      },
      fromJson: (data) => Address.fromJson(data as Map<String, dynamic>),
    );
    return response.data ?? address;
  }

  Future<List<AppNotification>> fetchNotifications(int userId) async {
    try {
      final response = await _client.get<List<AppNotification>>(
        'users/$userId/notifications',
        fromJson: (data) => (data as List)
            .map((item) => AppNotification.fromJson(item as Map<String, dynamic>))
            .toList(),
      );
      return response.data ?? [];
    } catch (_) {
      return _demoNotifications(userId);
    }
  }

  Future<void> markNotificationRead(int userId, int notificationId) async {
    await _client.put(
      'users/$userId/notifications/$notificationId/read',
    );
  }

  List<Address> _demoAddresses(int userId) {
    return [
      Address(
        id: 1,
        userId: userId,
        label: 'Rumah',
        recipientName: 'John Doe',
        phone: '+628111111111',
        street: 'Jl. Melati No. 5',
        city: 'Bandung',
        state: 'Jawa Barat',
        postalCode: '40123',
        isDefault: true,
      ),
    ];
  }

  List<AppNotification> _demoNotifications(int userId) {
    return [
      AppNotification(
        id: 1,
        userId: userId,
        title: 'Pesanan #1001 diproses',
        body: 'Kami sedang menyiapkan pesanan Anda.',
        type: 'order',
        isRead: false,
        createdAt: DateTime.now().toIso8601String(),
      ),
      AppNotification(
        id: 2,
        userId: userId,
        title: 'Promo weekend',
        body: 'Diskon 20% untuk kategori fashion!',
        type: 'promo',
        isRead: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      ),
    ];
  }
}
