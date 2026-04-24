import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';

class CafeteriaDetailScreen extends StatefulWidget {
  final String cafeteriaName;
  final int cafeteriaIndex;

  const CafeteriaDetailScreen({
    super.key,
    required this.cafeteriaName,
    required this.cafeteriaIndex,
  });

  @override
  State<CafeteriaDetailScreen> createState() => _CafeteriaDetailScreenState();
}

class _CafeteriaDetailScreenState extends State<CafeteriaDetailScreen> {
  String _selectedCategory = "All";

  final List<String> _categories = [
    "All", "Veg", "Non-Veg", "Halal", "Lunch", "Breakfast", "Dinner"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          /// ─── SLIVER APP BAR ───
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: const Color(0xFF9B1C1C),
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                widget.cafeteriaName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/food/food_banner.jpeg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        const Color(0xFF9B1C1C).withOpacity(0.85),
                      ],
                    ),
                  ),
                child: Stack(
                  children: [
                    Positioned(
                      right: 20,
                      top: 50,
                      child: Icon(Icons.restaurant, size: 100, color: Colors.white.withOpacity(0.1)),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 60,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.green.withOpacity(0.5)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.circle, color: Colors.green, size: 8),
                                SizedBox(width: 6),
                                Text("Open Now", style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "⭐ 4.${widget.cafeteriaIndex + 2}  •  ☕ ${10 + widget.cafeteriaIndex * 5}+ items",
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
               ),
              ),
            ),
          ),

          /// ─── CATEGORY TABS (Veg, Non-Veg, Halal, etc.) ───
          SliverToBoxAdapter(child: _buildCategoryChips()),

          /// ─── QUEUE & TIME SLOT INFO ───
          SliverToBoxAdapter(child: _buildInfoCards()),

          /// ─── FOOD ITEMS SECTION ───
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.restaurant_menu, color: Color(0xFF9B1C1C), size: 20),
                  const SizedBox(width: 8),
                  const Text("Available Items", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  Text("${_getFilteredItems(context).length} items", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                ],
              ),
            ),
          ),

          /// ─── HALAL BANNER ───
          if (_selectedCategory == "Halal")
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: const DecorationImage(
                    image: AssetImage('assets/food/halal_diet.jpeg'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
              ),
            ),

          /// ─── FOOD LIST ───
          _buildFoodList(),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  /// ─── CATEGORY CHIPS ───
  Widget _buildCategoryChips() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Categories", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                String cat = _categories[index];
                bool sel = _selectedCategory == cat;
                IconData icon = _getCategoryIcon(cat);
                return GestureDetector(
                  onTap: () => setState(() => _selectedCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: sel ? const Color(0xFF9B1C1C) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: sel ? const Color(0xFF9B1C1C) : Colors.grey[300]!),
                      boxShadow: sel ? [BoxShadow(color: const Color(0xFF9B1C1C).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : [],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(icon, size: 16, color: sel ? Colors.white : Colors.grey[600]),
                        const SizedBox(width: 6),
                        Text(cat, style: TextStyle(
                          color: sel ? Colors.white : Colors.grey[700],
                          fontWeight: sel ? FontWeight.bold : FontWeight.w500,
                          fontSize: 13,
                        )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String cat) {
    switch (cat) {
      case "Veg": return Icons.eco;
      case "Non-Veg": return Icons.kebab_dining;
      case "Halal": return Icons.verified;
      case "Lunch": return Icons.lunch_dining;
      case "Breakfast": return Icons.free_breakfast;
      case "Dinner": return Icons.dinner_dining;
      default: return Icons.restaurant;
    }
  }

  /// ─── INFO CARDS (Queue + Time Slot) ───
  Widget _buildInfoCards() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9B1C1C),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Icon(Icons.people_outline, color: Colors.white70, size: 22),
                  const SizedBox(height: 6),
                  Text("${widget.cafeteriaIndex * 3}", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  const Text("In Queue", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF9B1C1C),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 22),
                  const SizedBox(height: 6),
                  Text("${5 + widget.cafeteriaIndex * 3} min", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 2),
                  const Text("Est. Wait", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF008080),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Column(
                children: [
                  Icon(Icons.schedule, color: Colors.white70, size: 22),
                  SizedBox(height: 6),
                  Text("Slots", style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                  SizedBox(height: 2),
                  Text("Available", style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ─── FILTERED FOOD ITEMS ───
  List<FoodItem> _getFilteredItems(BuildContext context) {
    final provider = Provider.of<FoodProvider>(context, listen: false);
    var items = provider.availableFoodItems;

    if (_selectedCategory != "All") {
      // Map category chips to food categories
      Map<String, List<String>> categoryMap = {
        "Veg": ["Veg", "Snacks", "Beverages"],
        "Non-Veg": ["Lunch"],
        "Halal": ["Halal"],
        "Lunch": ["Lunch"],
        "Breakfast": ["Breakfast"],
        "Dinner": ["Lunch", "Snacks", "Dinner"],
      };
      List<String> mapped = categoryMap[_selectedCategory] ?? [];
      items = items.where((i) => mapped.contains(i.category)).toList();
    }
    return items;
  }

  /// ─── FOOD LIST ───
  SliverList _buildFoodList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final items = _getFilteredItems(context);
          if (items.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  Icon(Icons.no_food_outlined, size: 50, color: Colors.grey[300]),
                  const SizedBox(height: 10),
                  Text("No items in this category", style: TextStyle(color: Colors.grey[400], fontSize: 15)),
                ],
              ),
            );
          }
          if (index >= items.length) return null;
          final item = items[index];
          return _buildFoodItemCard(item);
        },
        childCount: _getFilteredItems(context).isEmpty ? 1 : _getFilteredItems(context).length,
      ),
    );
  }

  Widget _buildFoodItemCard(FoodItem item) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            /// Food Image
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFF9B1C1C).withOpacity(0.08),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(item.imagePath, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood, color: Color(0xFF9B1C1C), size: 30),
                ),
              ),
            ),
            const SizedBox(width: 14),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(6)),
                        child: Text(item.category, style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w600)),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 8, height: 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: item.stockStatus == StockStatus.inStock ? Colors.green :
                                 item.stockStatus == StockStatus.limitedStock ? Colors.orange : Colors.red,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        item.stockStatus == StockStatus.inStock ? "Available" :
                        item.stockStatus == StockStatus.limitedStock ? "Limited" : "Sold Out",
                        style: TextStyle(
                          fontSize: 11,
                          color: item.stockStatus == StockStatus.inStock ? Colors.green :
                                 item.stockStatus == StockStatus.limitedStock ? Colors.orange : Colors.red,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (item.specialOffer != "None") ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.teal.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                      child: Text("🔥 ${item.specialOffer}", style: const TextStyle(color: Colors.teal, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ],
              ),
            ),

            /// Price & Add Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text("Rs. ${item.price}", style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF9B1C1C))),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showPaymentPrompt(context, item),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF9B1C1C),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("ADD", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showPaymentPrompt(BuildContext context, FoodItem item) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 5,
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10)),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF9B1C1C).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.shopping_cart_checkout, color: Color(0xFF9B1C1C), size: 40),
              ),
              const SizedBox(height: 16),
              const Text("Confirm Order", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text(
                "You are about to purchase ${item.name} for Rs. ${item.price}. Proceed to payment?",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.grey[600], height: 1.4),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF9B1C1C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Close the popup
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Row(
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white),
                            const SizedBox(width: 12),
                            Expanded(child: Text("Payment successful! ${item.name} ordered.", style: const TextStyle(fontWeight: FontWeight.bold))),
                          ],
                        ),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.all(16),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  child: Text("Pay Rs. ${item.price}", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel", style: TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
