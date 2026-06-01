import 'package:flutter/material.dart';
import 'main.dart';

class PetCategoryPage extends StatelessWidget {
  final String categoryName;

  const PetCategoryPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, List<Map<String, dynamic>>> allPetProducts = {
      'Dog': [
        {
          'title': 'Premium Dog Food',
          'rating': '4.8',
          'reviews': '(234)',
          'description': 'High-quality nutrition for your furry friend with real chicken and vegetables.',
          'price': '45.99',
        },
        {
          'title': 'Dog Chew Toys Set',
          'rating': '4.7',
          'reviews': '(445)',
          'description': 'Durable rubber toys for aggressive chewers, set of 5.',
          'price': '19.99',
        },
        {
          'title': 'Dog Leash & Collar Set',
          'rating': '4.6',
          'reviews': '(334)',
          'description': 'Stylish and durable nylon leash with matching collar.',
          'price': '24.99',
        },
      ],
      'Cat': [
        {
          'title': 'Premium Cat Salmon Kibbles',
          'rating': '4.9',
          'reviews': '(512)',
          'description': 'Rich in Omega-3 for shiny fur and healthy growth.',
          'price': '39.99',
        },
        {
          'title': 'Interactive Cat Feather Toy',
          'rating': '4.5',
          'reviews': '(180)',
          'description': 'Keep your cat active and entertained for hours.',
          'price': '8.50',
        },
      ],
      'Fish': [
        {
          'title': 'Tropical Fish Flakes Food',
          'rating': '4.4',
          'reviews': '(98)',
          'description': 'Nutritious flakes that promote vibrant colors for your fish.',
          'price': '12.00',
        },
      ],
      'Bird': [
        {
          'title': 'Natural Organic Seed Mix',
          'rating': '4.7',
          'reviews': '(120)',
          'description': 'Perfect blend of seeds and grains for your pet birds.',
          'price': '15.99',
        },
      ],
      'Small Pets': [
        {
          'title': 'Premium Alfalfa Hay 1kg',
          'rating': '4.8',
          'reviews': '(340)',
          'description': 'High fiber organic hay, essential for rabbit digestion.',
          'price': '22.50',
        },
      ],
    };

    final List<Map<String, dynamic>> products = allPetProducts[categoryName] ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () {
            MainLayout.changeTab(context, 0);
          },
        ),
        title: Text(
          categoryName, 
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        shape: const Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      body: products.isEmpty
          ? const Center(child: Text('No products available for this pet.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 40),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['title']!,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  product['rating']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  product['reviews']!,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              product['description']!,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${product['price']!}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFFFF9800),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9800),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () {},
                                  child: const Text('Add', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}