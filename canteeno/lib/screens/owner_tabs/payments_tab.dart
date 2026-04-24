import 'package:flutter/material.dart';

class PaymentItem {
  final String id;
  final String orderId;
  final String customer;
  final String amount;
  final String method;
  final String date;
  final String status;

  PaymentItem({required this.id, required this.orderId, required this.customer, required this.amount, required this.method, required this.date, required this.status});
}

class PaymentsTab extends StatefulWidget {
  const PaymentsTab({super.key});
  @override
  State<PaymentsTab> createState() => _PaymentsTabState();
}

class _PaymentsTabState extends State<PaymentsTab> {
  String _filter = "All";
  final List<PaymentItem> _payments = [
    PaymentItem(id: 'P001', orderId: '#101', customer: 'John Smith', amount: 'Rs. 1,250', method: 'Card', date: 'Mar 27, 2026', status: 'Completed'),
    PaymentItem(id: 'P002', orderId: '#102', customer: 'Emily Clark', amount: 'Rs. 850', method: 'Cash', date: 'Mar 27, 2026', status: 'Completed'),
    PaymentItem(id: 'P003', orderId: '#103', customer: 'Mike Johnson', amount: 'Rs. 1,500', method: 'Card', date: 'Mar 27, 2026', status: 'Pending'),
    PaymentItem(id: 'P004', orderId: '#104', customer: 'Sara Lee', amount: 'Rs. 700', method: 'Online', date: 'Mar 26, 2026', status: 'Completed'),
    PaymentItem(id: 'P005', orderId: '#105', customer: 'David Brown', amount: 'Rs. 950', method: 'Cash', date: 'Mar 26, 2026', status: 'Refunded'),
  ];

  List<PaymentItem> get _filtered => _filter == "All" ? _payments : _payments.where((p) => p.status == _filter).toList();
  String get _totalRevenue => "Rs. 5,250";
  int get _totalTransactions => _payments.length;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Revenue Stats
          Row(
            children: [
              _revenueCard("Today's Revenue", _totalRevenue, Icons.trending_up, Colors.green),
              const SizedBox(width: 10),
              _revenueCard("Transactions", "$_totalTransactions", Icons.receipt_long, const Color(0xFF1565C0)),
            ],
          ),
          const SizedBox(height: 20),

          /// Section Title
          const Row(
            children: [
              Icon(Icons.payment, color: Color(0xFF9B1C1C), size: 22),
              SizedBox(width: 8),
              Text("Payment History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            ],
          ),
          const SizedBox(height: 12),

          /// Filter Chips
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ["All", "Completed", "Pending", "Refunded"].map((f) {
                bool sel = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _filter = f),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: sel ? const Color(0xFF9B1C1C) : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: sel ? const Color(0xFF9B1C1C) : Colors.grey[300]!),
                      ),
                      child: Text(f, style: TextStyle(color: sel ? Colors.white : Colors.grey[700], fontWeight: sel ? FontWeight.bold : FontWeight.w500, fontSize: 13)),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 14),

          /// Payment Cards
          ..._filtered.map((p) => _paymentCard(p)),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _revenueCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _paymentCard(PaymentItem p) {
    Color statusColor = p.status == "Completed" ? Colors.green : p.status == "Pending" ? Colors.orange : Colors.red;
    IconData methodIcon = p.method == "Card" ? Icons.credit_card : p.method == "Cash" ? Icons.money : Icons.phone_android;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFF9B1C1C).withOpacity(0.08), borderRadius: BorderRadius.circular(10)),
            child: Icon(methodIcon, color: const Color(0xFF9B1C1C), size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.customer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 2),
                Text("Order ${p.orderId} · ${p.method} · ${p.date}", style: TextStyle(color: Colors.grey[500], fontSize: 11)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(p.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1A1A2E))),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(p.status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
