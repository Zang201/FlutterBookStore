import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  String _searchQuery = '';

  Stream<QuerySnapshot> _getUsersStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  void _toggleRole(String uid, String currentRole) async {
    String newRole = currentRole == 'admin' ? 'user' : 'admin';

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'role': newRole,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Đã chuyển vai trò thành "$newRole"')),
    );
  }

  void _deleteUser(String uid, String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Xác nhận xóa'),
            content: Text('Bạn có chắc muốn xóa người dùng:\n$email?'),
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
      await FirebaseFirestore.instance.collection('users').doc(uid).delete();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xóa người dùng.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản lý người dùng'),
        backgroundColor: Colors.orange,
      ),
      body: Column(
        children: [
          // 🔍 Thanh tìm kiếm
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Tìm theo tên hoặc email...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          // 📋 Danh sách người dùng
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _getUsersStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('Không có người dùng.'));
                }

                final users =
                    snapshot.data!.docs.where((doc) {
                      final name = (doc['displayName'] ?? '').toLowerCase();
                      final email = (doc['email'] ?? '').toLowerCase();
                      return name.contains(_searchQuery) ||
                          email.contains(_searchQuery);
                    }).toList();

                if (users.isEmpty) {
                  return const Center(
                    child: Text('Không tìm thấy người dùng.'),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.all(12),
                  itemCount: users.length,
                  separatorBuilder: (_, __) => const Divider(),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    final uid = user.id;
                    final displayName = user['displayName'] ?? 'Không rõ';
                    final email = user['email'] ?? '';
                    final role = user['role'] ?? 'user';
                    final createdAt =
                        user['createdAt'] != null
                            ? (user['createdAt'] as Timestamp).toDate()
                            : null;

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            role == 'admin' ? Colors.orange : Colors.grey,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(displayName),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(email),
                          Text(
                            'Vai trò: ${role == 'admin' ? 'Admin 👑' : 'User'}',
                          ),
                          if (createdAt != null)
                            Text(
                              'Ngày tạo: ${createdAt.day}/${createdAt.month}/${createdAt.year}',
                            ),
                        ],
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'toggle') _toggleRole(uid, role);
                          if (value == 'delete') _deleteUser(uid, email);
                        },
                        itemBuilder:
                            (context) => [
                              PopupMenuItem(
                                value: 'toggle',
                                child: Text(
                                  role == 'admin'
                                      ? 'Hạ quyền user'
                                      : 'Nâng thành admin',
                                ),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text(
                                  'Xóa người dùng',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
