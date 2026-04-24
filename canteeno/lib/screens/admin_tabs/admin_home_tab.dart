import 'package:flutter/material.dart';

class AdminHomeTab extends StatelessWidget {
  final Function(int) onNavigate;

  const AdminHomeTab({super.key, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "System Overview 🛠️",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // 📊 STATS
          Row(
            children: [
              Expanded(child: _buildCard("Users", "1,250", Icons.people, Colors.blue)),
              Expanded(child: _buildCard("Canteens", "12", Icons.store, Colors.green)),
            ],
          ),
          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(child: _buildCard("Orders", "3,540", Icons.shopping_cart, Colors.orange)),
              Expanded(child: _buildCard("Issues", "4", Icons.warning, Colors.red)),
            ],
          ),
          const SizedBox(height: 30),

          // 🔘 ACTIONS
          Expanded(
            child: ListView(
              children: [
                _buildButton("Home Page", Icons.home, Colors.blue, 0),
                const SizedBox(height: 15),
                _buildButton("Cafeteria Manager", Icons.store, Colors.green, 1),
                const SizedBox(height: 15),
                _buildButton("Staff Manager", Icons.people, Colors.purple, 2),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String title, IconData icon, Color color, int targetIndex) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: () => onNavigate(targetIndex),
        icon: Icon(icon, color: Colors.white),
        label: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      ),
    );
  }
}

