import 'package:cloud_firestore/cloud_firestore.dart';

class OrderService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;

  static Future<void> createOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double total,
  }) async {
    try {
      await _db.collection('orders').add({
        'userId': userId,
        'items': items,
        'total': total,
        'status': 'processing',
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  static Stream<QuerySnapshot> getUserOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
