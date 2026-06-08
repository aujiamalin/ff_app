import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({Key? key}) : super(key: key);

  Color getStatusColor(String status) {
    final normalized = status.toLowerCase();
    if (normalized.contains('deliver')) return Colors.green;
    if (normalized.contains('process')) return Colors.orange;
    if (normalized.contains('ship')) return Colors.blue;
    if (normalized.contains('paid')) return Colors.green;
    return Colors.grey;
  }

  String _formatDate(dynamic rawDate) {
    try {
      DateTime date;
      if (rawDate is Timestamp) {
        date = rawDate.toDate();
      } else if (rawDate is String) {
        date = DateTime.parse(rawDate).toLocal();
      } else {
        return 'Unknown date';
      }
      return '${date.day}/${date.month}/${date.year} at ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return 'Unknown date';
    }
  }

  Widget _buildOrderItemImage(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return const Icon(Icons.image_not_supported, size: 50);
    }
    if (imageUrl.startsWith('data:image')) {
      final base64Str = imageUrl.split(',').last;
      return Image.memory(base64Decode(base64Str), width: 50, height: 50, fit: BoxFit.cover);
    }
    return Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, o, s) => const Icon(Icons.image_not_supported));
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("My Orders"),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: userId == null
          ? const Center(
              child: Text(
                "Please log in to view your orders.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            )
          : StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .where('userId', isEqualTo: userId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text(
                      "No Orders Yet",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final orders = snapshot.data!.docs;

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final orderData = orders[index].data() as Map<String, dynamic>;
                    final items = orderData['items'] as List<dynamic>? ?? [];
                    final totalAmount = (orderData['totalAmount'] ?? 0.0).toDouble();
                    final status = orderData['status'] ?? 'Unknown';
                    final createdAt = orderData['createdAt'];

                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                      elevation: 3,
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: getStatusColor(status),
                          child: const Icon(
                            Icons.shopping_bag,
                            color: Colors.white,
                          ),
                        ),
                        title: Text(
                          items.isEmpty ? 'Order' : (items.first['name'] ?? 'Order'),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Qty: ${items.fold(0, (sum, i) => sum + ((i['quantity'] ?? 0) as int))}'),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(status),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        trailing: Text(
                          '\$${totalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        children: [
                          if (createdAt != null)
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                              child: Text(_formatDate(createdAt)),
                            ),
                          ...items.map<Widget>((item) {
                            return ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: _buildOrderItemImage(item['image'] as String?),
                              ),
                              title: Text(item['name'] ?? 'Unknown Item', style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Text('Qty: ${item['quantity']}'),
                              trailing: Text('\$${(item['price'] ?? 0).toStringAsFixed(2)}'),
                            );
                          }).toList(),
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
