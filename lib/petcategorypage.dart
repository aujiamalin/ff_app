import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // 1. IMPORT FIRESTORE
import 'main.dart';

class PetCategoryPage extends StatelessWidget {
  final String categoryName;

  const PetCategoryPage({Key? key, required this.categoryName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data statik allPetProducts yang panjang sebelum ini telah dibuang sepenuhnya

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
      // 2. GUNAKAN STREAMBUILDER DENGAN FILTER TERTENTU (.where)
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .where('category', isEqualTo: categoryName) // Tapis ikut kategori secara automatik
            .snapshots(),
        builder: (context, snapshot) {
          // Masa tunggu pangkalan data loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9800)),
            );
          }

          // Jika ada kesilapan teknikal
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong!'));
          }

          // Jika kategori ini tiada produk lagi di Firebase Console
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text(
                'No products available for this pet.',
                style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.w500),
              ),
            );
          }

          // Ambil dokumen dari Firebase
          final products = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: products.length,
            itemBuilder: (context, index) {
              // Tukar setiap dokumen kepada map data
              final product = products[index].data() as Map<String, dynamic>;

              final String title = product['name'] ?? 'No Title';
              final double rating = (product['rating'] ?? 5.0).toDouble();
              final int reviews = product['reviews'] ?? 0;
              final String description = product['description'] ?? 'No description available.';
              final double price = (product['price'] ?? 0.0).toDouble();
              final String imageUrl = product['image'] ?? '';

              return Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0F172A).withOpacity(0.02),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 100,
                                  height: 100,
                                  color: const Color(0xFFF1F5F9),
                                  child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 40),
                                );
                              },
                            )
                          : Container(
                              width: 100,
                              height: 100,
                              color: const Color(0xFFF1F5F9),
                              child: const Icon(Icons.pets, color: Color(0xFF94A3B8), size: 40),
                            ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
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
                                '$rating',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '($reviews)',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            description,
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
                                '\$${price.toStringAsFixed(2)}',
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
          );
        },
      ),
    );
  }
}