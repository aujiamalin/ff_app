import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';
import 'editprofilepage.dart';
import 'myorderspage.dart';
import 'mypetspage.dart';
import 'subscriptionpage.dart';
// import 'membershipage.dart';
import 'shoppage.dart';
import 'cart_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String firstName = "John";
  String lastName = "Doe";
  String email = "john.doe@example.com";
  String phone = "0123456789";
  String address = "Johor Bahru, Johor";

  File? profileImage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('firstName', firstName);
    await prefs.setString('lastName', lastName);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);
    await prefs.setString('address', address);
    if (profileImage != null) {
      await prefs.setString('profileImage', profileImage!.path);
    }
  }

  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString('firstName') ?? "John";
      lastName = prefs.getString('lastName') ?? "Doe";
      email = prefs.getString('email') ?? "john.doe@example.com";
      phone = prefs.getString('phone') ?? "0123456789";
      address = prefs.getString('address') ?? "Johor Bahru, Johor";
      String? imagePath = prefs.getString('profileImage');
      if (imagePath != null && File(imagePath).existsSync()) {
        profileImage = File(imagePath);
      }
    });
  }

  void updateProfile(
    String newFirstName,
    String newLastName,
    String newEmail,
    String newPhone,
    String newAddress,
  ) {
    setState(() {
      firstName = newFirstName;
      lastName = newLastName;
      email = newEmail;
      phone = newPhone;
      address = newAddress;
    });
    saveProfile();
  }

  Future<void> pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );
      if (pickedFile == null) return;
      setState(() {
        profileImage = File(pickedFile.path);
      });
      await saveProfile();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error selecting image: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      // ✅ body is now just the SingleChildScrollView with no invalid params
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),

            GestureDetector(
              onTap: pickImage,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.orange,
                  border: Border.all(color: Colors.orange, width: 3),
                  image: profileImage != null
                      ? DecorationImage(
                          image: FileImage(profileImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: profileImage == null
                    ? const Icon(
                        Icons.camera_alt,
                        size: 45,
                        color: Colors.white,
                      )
                    : null,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Tap image to change profile picture",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),

            const SizedBox(height: 15),

            Text(
              "$firstName $lastName",
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),
            Text(email, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(phone, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 5),
            Text(address, style: const TextStyle(color: Colors.grey)),

            const SizedBox(height: 25),

            buildMenuTile(
              icon: Icons.edit,
              title: "Edit Profile",
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EditProfilePage(
                      firstName: firstName,
                      lastName: lastName,
                      email: email,
                      phone: phone,
                      address: address,
                    ),
                  ),
                );
                if (result != null) {
                  updateProfile(
                    result['firstName'],
                    result['lastName'],
                    result['email'],
                    result['phone'],
                    result['address'],
                  );
                }
              },
            ),

            buildMenuTile(
              icon: Icons.shopping_bag,
              title: "My Orders",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyOrdersPage()),
                );
              },
            ),

            buildMenuTile(
              icon: Icons.pets,
              title: "My Pets",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyPetsPage()),
                );
              },
            ),

            // buildMenuTile(
            //   icon: Icons.star_border,
            //   title: "Reward Points",
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const SubscriptionPage()),
            //     );
            //   },
            // ),
            buildMenuTile(
              icon: Icons.calendar_month,
              title: "Subscriptions",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SubscriptionPage()),
                );
              },
            ),

            // buildMenuTile(
            //   icon: Icons.workspace_premium,
            //   title: "Membership",
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (_) => const MembershipPage()),
            //     );
            //   },
            // ),
            const SizedBox(height: 25),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("Logout"),
                      content: const Text("Are you sure you want to logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                              (route) => false,
                            );
                          },
                          child: const Text("Logout"),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.logout),
                label: const Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildMenuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
