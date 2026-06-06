import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPage extends StatelessWidget {
  const LocationPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Exact store coordinates for Taman Universiti / Pura Kencana area
    const LatLng storeLocation = LatLng(1.852276, 103.074121);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Store Location', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: storeLocation,
                zoom: 15,
              ),
              markers: {
                const Marker(
                  markerId: MarkerId('store'),
                  position: storeLocation,
                  infoWindow: InfoWindow(
                    title: 'FluffyFriend Pet Store',
                    snippet: 'Pura Kencana, Johor',
                  ),
                ),
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.15),
                  blurRadius: 10,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FluffyFriend Pet Store',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Address:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text('Taman Universiti, Pura Kencana, Batu Pahat, Johor'),
                SizedBox(height: 12),
                Text(
                  'Operating Hours:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                ),
                Text('Monday - Sunday: 9:00 AM - 8:00 PM'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}