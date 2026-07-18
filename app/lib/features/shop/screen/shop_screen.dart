import 'dart:ui';
import 'package:flutter/material.dart';

import '../model/shop_product.dart';
import '../services/product_service.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_container.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_textfield.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_button.dart';
import '../../../utiles/widgets/glass/glass_kit.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  String _selectedCategory = 'All';
  String _query = '';
  late final Future<List<ShopProduct>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.instance.fetchProducts();
  }

  List<ShopProduct> _filterProducts(List<ShopProduct> products) {
    return products
        .where((product) => product.matchesCategory(_selectedCategory))
        .where((product) => product.matchesQuery(_query))
        .toList();
  }

  void _openPaymentSheet(BuildContext context, ShopProduct product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _PaymentSheet(product: product);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom + 120;

    return GlassBackground(
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    pinned: true,
                    floating: true,
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    surfaceTintColor: Colors.transparent,
                    titleSpacing: 16,
                    title: Row(
                      children: [
                        const Icon(
                          Icons.sports_esports_rounded,
                          color: shopPrimaryColor,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Shop',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(16, 16, 16, bottomPadding),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          NeumorphicTextField(
                            onChanged: (value) {
                              setState(() {
                                _query = value;
                              });
                            },
                            hintText: 'Search for gear...',
                            prefix: const Icon(Icons.search_rounded),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 42,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: shopCategories.length,
                              separatorBuilder: (_, __) =>
                              const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final category = shopCategories[index];
                                final isSelected =
                                    category == _selectedCategory;

                                return GestureDetector(
                                  onTap: () => setState(
                                          () => _selectedCategory = category),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? shopPrimaryColor.withOpacity(0.24)
                                          : const Color(0x1217B7FF),
                                      borderRadius: BorderRadius.circular(999),
                                      border: Border.all(
                                        color: isSelected
                                            ? shopPrimaryColor
                                            : const Color(0x3317B7FF),
                                      ),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected
                                            ? const Color(0xFFECF7FF)
                                            : shopMutedTextColor,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            'Shop Picks',
                            style: TextStyle(
                              color: Color(0xFFECF7FF),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 14),
                          FutureBuilder<List<ShopProduct>>(
                            future: _productsFuture,
                            builder: (context, snapshot) {
                              final products =
                                  snapshot.data ?? shopProducts;
                              final filtered = _filterProducts(products);

                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }

                              if (filtered.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No products found",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                );
                              }

                              return GridView.builder(
                                itemCount: filtered.length,
                                shrinkWrap: true,
                                physics:
                                const NeverScrollableScrollPhysics(),
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.66,
                                ),
                                itemBuilder: (context, index) {
                                  return _ProductCard(
                                    product: filtered[index],
                                    onBuy: () => _openPaymentSheet(
                                        context, filtered[index]),
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ShopProduct product;
  final VoidCallback onBuy;

  const _ProductCard({
    required this.product,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return NeumorphicContainer(
      borderRadius: 20,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(20)),
              child: product.hasDataUrlImage &&
                  product.imageBytes != null
                  ? Image.memory(product.imageBytes!, width: double.infinity, height: double.infinity, fit: BoxFit.cover)
                  : Image.network(product.imageUrl, width: double.infinity, height: double.infinity, fit: BoxFit.cover),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        color: Color(0xFFECF7FF),
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(
                  product.formattedPrice,
                  style: const TextStyle(
                    color: shopPrimaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                NeumorphicButton(
                  onPressed: onBuy,
                  child: const Text('Buy Now'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentSheet extends StatelessWidget {
  final ShopProduct product;

  const _PaymentSheet({required this.product});

  Widget _row(String t, String v) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t,
            style: const TextStyle(
              color: Color(0xFFA6C9EA),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            v,
            style: const TextStyle(
              color: Color(0xFFECF7FF),
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: const Color(0x2217B7FF)),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Center(
                child: Text(
                  "Payment Details",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                "Product: ${product.name}",
                style: const TextStyle(color: Colors.white70),
              ),
              Text(
                "Price: ${product.formattedPrice}",
                style: const TextStyle(color: Colors.white70),
              ),

              const SizedBox(height: 18),

              const Divider(color: Color(0x2217B7FF)),

              const SizedBox(height: 12),

              // 🔥 BANK DETAILS (ADDED HERE)
              _row("Name", "Muhammad Fardan Mohsin"),
              _row("Account Number", "2678346203949"),
              _row("IBAN Number", "PK93UNIL0109000346203949"),
              _row("Bank", "UBL"),

              const SizedBox(height: 16),

              const Text(
                "Send payment & screenshot on WhatsApp:",
                style: TextStyle(color: Colors.white),
              ),

              const SizedBox(height: 8),

              const Text(
                "0334 2862602",
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                "After payment, send screenshot to confirm order.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}