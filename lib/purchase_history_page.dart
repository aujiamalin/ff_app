import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({Key? key}) : super(key: key);

  Widget _buildImage(String imageUrl) {
    if (imageUrl.startsWith('data:image')) {
      final base64Str = imageUrl.split(',').last;
      return Image.memory(
        base64Decode(base64Str),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      );
    } else {
      return Image.network(imageUrl, width: 50, height: 50, fit: BoxFit.cover);
    }
  }

  double _safeDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is int) return value.toDouble();
    if (value is double) return value;
    return double.tryParse(value.toString()) ?? 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Purchase History',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: StreamBuilder<QuerySnapshot>(
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
                'No past purchases yet.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          final orders = snapshot.data!.docs;

          return ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              final data = order.data() as Map<String, dynamic>;

              final double total = _safeDouble(data['totalAmount']);

              final Timestamp? timestamp = data['createdAt'];
              final DateTime date = timestamp != null
                  ? timestamp.toDate()
                  : DateTime.now();

              final List items = data['items'] ?? [];

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ExpansionTile(
                  leading: const Icon(Icons.receipt_long, color: Colors.orange),

                  title: Text(
                    'Order RM ${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  subtitle: Text(
                    '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                  ),

                  children: items.map<Widget>((item) {
                    final map = item as Map<String, dynamic>;

                    return ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: _buildImage(map['image'] ?? ''),
                      ),
                      title: Text(map['name'] ?? 'Unknown'),
                      subtitle: Text('Qty: ${map['quantity'] ?? 1}'),
                      trailing: Text(
                        'RM ${_safeDouble(map['price']).toStringAsFixed(2)}',
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
