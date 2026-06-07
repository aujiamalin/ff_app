import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  Future signUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstNameController.text.trim());
      await prefs.setString('lastName', _lastNameController.text.trim());
      await prefs.setString('email', _emailController.text.trim());
      await prefs.setString('phone', _phoneController.text.trim());
      await prefs.setString('address', _addressController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Akaun berjaya didaftarkan!')),
      );
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainLayout()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? 'Ralat berlaku')));
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: const Color(0xfff1f3f6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(icon, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xfff5f5f5,
      ), // Warna background luar kelabu lembut
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              // --- DESIGN KAD PUTIH (Macam dalam gambar image_0c82e6.png) ---
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  32,
                ), // Bucu melengkung comel
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 40.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 1. Logo / Nama App
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.pets,
                        color: Colors.orange,
                        size: 28,
                      ), // Ikon ganti placeholder gambar
                      const SizedBox(width: 8),
                      Text(
                        'Fluffy Friend',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueGrey[900],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // 2. Tajuk Welcome
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign up to start your journey',
                    style: TextStyle(fontSize: 15, color: Colors.blueGrey[400]),
                  ),
                  const SizedBox(height: 32),

                  // 3. Input Email
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Email',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'you@example.com',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      filled: true,
                      fillColor: const Color(
                        0xfff1f3f6,
                      ), // Warna kotak input kelabu cair
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                   // 4. Input Password
                   Align(
                     alignment: Alignment.centerLeft,
                     child: const Text(
                       'Password',
                       style: TextStyle(
                         fontWeight: FontWeight.bold,
                         fontSize: 15,
                       ),
                     ),
                   ),
                   const SizedBox(height: 8),
                   TextField(
                     controller: _passwordController,
                     obscureText: true,
                     decoration: InputDecoration(
                       hintText: '••••••••',
                       hintStyle: TextStyle(color: Colors.grey[400]),
                       filled: true,
                       fillColor: const Color(0xfff1f3f6),
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(12),
                         borderSide: BorderSide.none,
                       ),
                     ),
                   ),
                   const SizedBox(height: 20),

                   const Text(
                     'Personal Info',
                     style: TextStyle(
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                     ),
                   ),
                   const SizedBox(height: 12),

                   buildTextField(
                     controller: _firstNameController,
                     label: 'First Name',
                     icon: Icons.person,
                     hint: 'John',
                   ),
                   const SizedBox(height: 16),
                   buildTextField(
                     controller: _lastNameController,
                     label: 'Last Name',
                     icon: Icons.person_outline,
                     hint: 'Doe',
                   ),
                   const SizedBox(height: 16),
                   buildTextField(
                     controller: _phoneController,
                     label: 'Phone Number',
                     icon: Icons.phone,
                     hint: '0123456789',
                     keyboardType: TextInputType.phone,
                   ),
                   const SizedBox(height: 16),
                   buildTextField(
                     controller: _addressController,
                     label: 'Address',
                     icon: Icons.location_on,
                     hint: 'Johor Bahru, Johor',
                   ),
                   const SizedBox(height: 32),

                  // 5. Butang Sign Up (Warna Orange Macam Gambar)
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: signUp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.orange[400], // Warna oren terang
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 6. Teks Tukar ke Login Page
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: TextStyle(color: Colors.orange[300]),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Letak code untuk patah balik ke Login Page kat sini nanti
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Sign in',
                          style: TextStyle(
                            color: Colors.orange[400],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
