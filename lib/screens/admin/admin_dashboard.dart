import 'package:flutter/material.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Trang quản trị"),
        backgroundColor: Colors.orange,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        children: [
          _AdminTile(
            title: "📚 Quản lý sách",
            icon: Icons.book,
            color: Colors.deepPurple,
            onTap: () => Navigator.pushNamed(context, '/admin/manage_books'),
          ),
          _AdminTile(
            title: "👤 Quản lý người dùng",
            icon: Icons.people,
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, '/admin/manage_users'),
          ),
          _AdminTile(
            title: "🧾 Quản lý đơn hàng",
            icon: Icons.receipt_long,
            color: Colors.blue,
            onTap: () => Navigator.pushNamed(context, '/admin/manage_orders'),
          ),
        ],
      ),
    );
  }
}

class _AdminTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AdminTile({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
