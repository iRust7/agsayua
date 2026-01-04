import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/state/auth_state.dart';
import '../../../core/theme/spacing.dart';
import '../../../core/widgets/empty_state.dart';
import '../data/account_service.dart';
import '../data/address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AccountService _service = AccountService();
  late Future<List<Address>> _future;

  @override
  void initState() {
    super.initState();
    _future = _load();
  }

  Future<List<Address>> _load() async {
    final userId = context.read<AuthState>().user?.id ?? 0;
    return _service.fetchAddresses(userId);
  }

  Future<void> _addAddress() async {
    final formKey = GlobalKey<FormState>();
    final label = TextEditingController(text: 'Rumah');
    final recipient = TextEditingController();
    final phone = TextEditingController();
    final street = TextEditingController();
    final city = TextEditingController();
    final state = TextEditingController();
    final postal = TextEditingController();
    bool isDefault = false;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text('Tambah Alamat'),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: label,
                        decoration: const InputDecoration(labelText: 'Label (Rumah/Kantor)'),
                      ),
                      TextFormField(
                        controller: recipient,
                        decoration: const InputDecoration(labelText: 'Nama penerima'),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      TextFormField(
                        controller: phone,
                        decoration: const InputDecoration(labelText: 'Nomor telepon'),
                      ),
                      TextFormField(
                        controller: street,
                        decoration: const InputDecoration(labelText: 'Alamat lengkap'),
                        validator: (v) => v == null || v.isEmpty ? 'Wajib diisi' : null,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: city,
                              decoration: const InputDecoration(labelText: 'Kota'),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: TextFormField(
                              controller: state,
                              decoration: const InputDecoration(labelText: 'Provinsi'),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        controller: postal,
                        decoration: const InputDecoration(labelText: 'Kode pos'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Jadikan default'),
                        value: isDefault,
                        onChanged: (v) => setStateDialog(() {
                          isDefault = v;
                        }),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Batal'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState?.validate() ?? false) {
                      Navigator.pop(context, true);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );

    if (result == true) {
      final userId = context.read<AuthState>().user?.id ?? 0;
      final newAddress = Address(
        id: 0,
        userId: userId,
        label: label.text,
        recipientName: recipient.text,
        phone: phone.text,
        street: street.text,
        city: city.text,
        state: state.text,
        postalCode: postal.text,
        isDefault: isDefault,
      );
      await _service.addAddress(userId, newAddress);
      setState(() {
        _future = _load();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alamat Tersimpan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAddress,
          ),
        ],
      ),
      body: FutureBuilder<List<Address>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return EmptyState(
              icon: Icons.home_work_outlined,
              title: 'Belum ada alamat',
              message: 'Tambahkan alamat pengiriman supaya checkout lebih cepat.',
              actionLabel: 'Tambah alamat',
              onAction: _addAddress,
            );
          }

          final addresses = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemBuilder: (context, index) {
              final a = addresses[index];
              return Card(
                child: ListTile(
                  leading: Icon(
                    a.isDefault ? Icons.star : Icons.location_on_outlined,
                    color: a.isDefault ? Colors.orange : null,
                  ),
                  title: Text('${a.label} • ${a.recipientName}'),
                  subtitle: Text('${a.street}\n${a.city}, ${a.state} ${a.postalCode}\n${a.phone}'),
                  isThreeLine: true,
                  trailing: a.isDefault ? const Text('Default') : null,
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
            itemCount: addresses.length,
          );
        },
      ),
    );
  }
}
