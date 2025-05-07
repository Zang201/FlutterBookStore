import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final _formatter = DateFormat('dd/MM/yyyy HH:mm');

  Stream<QuerySnapshot> _getOrdersStream() {
    return FirebaseFirestore.instance
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> _changeOrderStatus(String oid, String currentStatus) async {
    List<String> statusOptions = ['pending', 'shipped', 'cancelled'];

    final newStatus = await showDialog<String>(
      context: context,
      builder:
          (_) => SimpleDialog(
            title: const Text('Cập nhật trạng thái'),
            children:
                statusOptions
                    .where((status) => status != currentStatus)
                    .map(
                      (status) => SimpleDialogOption(
                        child: Text(status.toUpperCase()),
                        onPressed: () => Navigator.pop(context, status),
                      ),
                    )
                    .toList(),
          ),
    );

    if (newStatus != null) {
      await FirebaseFirestore.instance.collection('orders').doc(oid).update({
        'status': newStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trạng thái cập nhật thành "$newStatus"')),
      );
    }
  }

  Future<void> _deleteOrder(String oid) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Xác nhận xóa đơn hàng'),
            content: const Text('Bạn có chắc chắn muốn xóa đơn hàng này?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Xóa'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      await FirebaseFirestore.instance.collection('orders').doc(oid).delete();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa đơn hàng.')));
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'shipped':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý đơn hàng'),
        backgroundColor: Colors.orange,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getOrdersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final orders = snapshot.data?.docs ?? [];

          if (orders.isEmpty) {
            return const Center(child: Text('Không có đơn hàng.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final oid = order.id;
              final uid = order['uid'];
              final status = order['status'] ?? 'pending';
              final total = order['total'] ?? 0;
              final createdAt =
                  order['createdAt'] != null
                      ? (order['createdAt'] as Timestamp).toDate()
                      : null;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text('Mã đơn: $oid'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Khách hàng: $uid'),
                      Text(
                        'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(total)}',
                      ),
                      if (createdAt != null)
                        Text('Ngày tạo: ${_formatter.format(createdAt)}'),
                      Text(
                        'Trạng thái: ${status.toUpperCase()}',
                        style: TextStyle(
                          color: _getStatusColor(status),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'change') {
                        _changeOrderStatus(oid, status);
                      } else if (value == 'delete') {
                        _deleteOrder(oid);
                      }
                    },
                    itemBuilder:
                        (_) => [
                          const PopupMenuItem(
                            value: 'change',
                            child: Text('Cập nhật trạng thái'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text(
                              'Xóa đơn hàng',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
