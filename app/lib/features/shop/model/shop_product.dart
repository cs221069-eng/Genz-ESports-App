import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class ShopProduct {
  const ShopProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.inventory,
    required this.featured,
  });

  factory ShopProduct.fromJson(Map<String, dynamic> json) {
    return ShopProduct(
      id: json['id'] as String? ?? json['_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      imageUrl: json['imageUrl'] as String? ?? '',
      inventory: (json['inventory'] as num?)?.toInt() ?? 0,
      featured: json['featured'] as bool? ?? false,
    );
  }

  final String id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final int inventory;
  final bool featured;

  bool matchesCategory(String category) {
    return category == 'All' || this.category == category;
  }

  bool matchesQuery(String query) {
    if (query.trim().isEmpty) {
      return true;
    }

    final normalizedQuery = query.trim().toLowerCase();
    return name.toLowerCase().contains(normalizedQuery) ||
        category.toLowerCase().contains(normalizedQuery);
  }

  String get formattedPrice => 'Rs ${price.toStringAsFixed(2)}';

  bool get hasDataUrlImage => imageUrl.startsWith('data:');

  Uint8List? get imageBytes {
    if (!hasDataUrlImage) return null;
    final index = imageUrl.indexOf(',');
    if (index < 0) return null;
    try {
      return base64Decode(imageUrl.substring(index + 1));
    } catch (_) {
      return null;
    }
  }
}

const List<String> shopCategories = [
  'All',
  'PS5',
  'Controllers',
  'Headsets',
  'Accessories',
  'Keyboards',
];

const List<ShopProduct> shopProducts = [
  ShopProduct(
    id: 'P-1',
    name: 'PlayStation 5 Console',
    category: 'PS5',
    price: 499.99,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuDgn8GRDOXqV1ErAyaWnpn_pt6EXLsnk7A_KaQGJPKi9VmeyQv4QYKWUYJl67Y-7GNsiFl4hfILd-eBG9bGJ-8vXSYe2G4URRfb69bG8tGWhp9xfP1KuuWv3_BjIKWoWaTpHIgu0sAwjWcrLiBsPkyzR-y6_qRWPd774_vQhTgy_RZxW5CFjp68LdO5I6W82wU77wg6IjMcZ5do2d5J7OqzN25JV8gx9-vxEqOKiU2Pnn-5xZgB9kPFpquW-5J4W8Kkr-eACCJ4DoOE',
    inventory: 0,
    featured: false,
  ),
  ShopProduct(
    id: 'P-2',
    name: 'DualSense Controller',
    category: 'Controllers',
    price: 69.99,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCf6RrDtDKUCu0-dDuBQrcb6lgqOWahsHQjGwL0iHTopSZrzUaUt21hcbszCUDSIV5hW3DeBj6ikk3XVWjTk75T6u0iz8WgcZ4ozYayYj-Y8X0WZZr9CCaBSKdYBRNKUq5s-YmTs1rwSpgDUbCvQPBz9pTWq0d__RIF1deUmpx0a-1tB99EWkBgDB1oM4_hyW-lMGMohFYT5GmS-tJ0Kx70FkSBwPRJQ6ERrLsowOCbZOj6LccaHS89-hmQMcC-hO0toU1adDFN18BM',
    inventory: 0,
    featured: false,
  ),
  ShopProduct(
    id: 'P-3',
    name: 'Pro Gaming Headset',
    category: 'Headsets',
    price: 129.00,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCfu2t6GbWKB8rZ3VvAm5eZMxpxkesKSDF5JCCJeyktAiSdrCiCAsdcAi3MBT_Xy_PswmiQmt8hdsRq9D5KYtrFuHpyrxr-5xgfLqmamITTZoNQwoKEFfrYr0q0PCNOjU88YDs7GmrbzmvOM3ezv7HuOn1EhIwoCsb14U1W5PPBXj2wgkTASCga8RCbC3q8SV9XyXuunXTmf6GhcD4VFIMZRfpWLRhzRCo9ZtbPPWk5VLG3088PYIVE03Liw6AC2o-0pT_S6mG0RIVg',
    inventory: 0,
    featured: false,
  ),
  ShopProduct(
    id: 'P-4',
    name: 'Mechanical Keyboard',
    category: 'Keyboards',
    price: 159.99,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAfHuWWaGt-Fs03_dyvNon9KHYLfubSixhXpe7wICpgHCFENYj3u1NLO22hHuIhiIBFvU63zROuqRVlJXa_mUGD_Vk5oVjxyFu6j0qP6voL-m1RLKHnyUy8dfHHhA4z6EiQl8YcBVyDsR4hD8jnRhFb_djTvXzCXtlNy6ZBM9G5tKZ_9dSE-JqBaBUZGeK_8lfl8GaHlIcFxLwkn8c5d4W8MRyZJKGmfIaWXAD3tW5unDK_foswya4_hkMZLtQj5Msqh-X4s_UbLebe',
    inventory: 0,
    featured: false,
  ),
  ShopProduct(
    id: 'P-5',
    name: 'Elite Wireless Mouse',
    category: 'Accessories',
    price: 89.00,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuCJbeaMNZ5FSolwqecnH4Lg3L8NbKycjRYkmvbwOfjvx0nhzrJlWlQLsBafUh7tSG1aSX0xqnYyeuJ3mP4aFLsov-olR6NQLNyjHpM428yh8-87O4E306vfnkEhcN6Q-EwmDY390VX4szfvy0fXQtZqjmLVVNLS5781U6l5xl0c_d2pb17VWxob5tGCe8_2NXkz87Bzbatj22J5sO3dGjCMsHDdBMoWMouJt5im_mfg6tE_r3AuIGVvsivW9csvsNvh6ytJk3SsxgVs',
    inventory: 0,
    featured: false,
  ),
  ShopProduct(
    id: 'P-6',
    name: '240Hz Gaming Monitor',
    category: 'Accessories',
    price: 349.00,
    imageUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuA2GWHohEJiwZiTcfT4HWtl7HIyW2dvgB1qpP9NNkNgZZWQpRR4882Kt0BO4T8AGdO2xEeKAbInQv3f6hPKHNa34fjzsZgMC9WEl4N3YasFFPIzxqkXT0lqQ1sYRkHsULmJiAniunK_ubhve224g_PTsZrG0G5PSVnHNM3OET1E1rNGf5sM477JOZF077xmZl3ZnpepZDYFmiW3NDLhWC5qY5z_mOOGVvhdlkZOUarE5qEMOlRywGAOR4iAOf6FqaepFMY8kI4zJ7Kv',
    inventory: 0,
    featured: false,
  ),
];

const Color shopPrimaryColor = Color(0xFF1E88E5);
const Color shopSurfaceColor = Color(0xFFF2F5FA);
const Color shopCardColor = Color(0xFFFFFFFF);
const Color shopMutedTextColor = Color(0xFF5B6B75);
const Color shopOutlineColor = Color(0xFFD9E3F6);
const Color shopSoftBackground = Color(0xFFEFF6FB);
