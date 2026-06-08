import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class StripeService {
  // Your live Render backend URL
  static const String _backendUrl = 'https://ff-app-1zzg.onrender.com';

  static Future<bool> makePayment(BuildContext context, String amount) async {
    try {
      // 1. Create Payment Intent on the Backend
      final paymentIntent = await _createPaymentIntent(
        amount,
        'MYR', // Ringgit Malaysia
      ); 

      if (paymentIntent == null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error: Could not connect to payment server.'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }

      // 2. Initialize the Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Fluffy Friend Store',
        ),
      );

      // 3. Display the Payment Sheet
      await _displayPaymentSheet();

      // Payment Success!
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Successful! 🎉'),
            backgroundColor: Colors.green,
          ),
        );
      }
      return true;

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return false;
    }
  }

  // --- Helper Functions ---

  static Future<Map<String, dynamic>?> _createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$_backendUrl/create-payment-intent'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'amount': amount, 'currency': currency}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to create payment intent');
      }
    } catch (e) {
      debugPrint('Error creating payment intent: $e');
      return null;
    }
  }

  static Future<void> _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e) {
      debugPrint('Stripe Error: $e');
      throw Exception('Payment cancelled or failed');
    }
  }
}