import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;

  const EditProfilePage({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();

    firstNameController = TextEditingController(
      text: widget.firstName,
    );

    lastNameController = TextEditingController(
      text: widget.lastName,
    );

    emailController = TextEditingController(
      text: widget.email,
    );

    phoneController = TextEditingController(
      text: widget.phone,
    );

    addressController = TextEditingController(
      text: widget.address,
    );
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  void saveProfile() {
    Navigator.pop(
      context,
      {
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'email': emailController.text,
        'phone': phoneController.text,
        'address': addressController.text,
      },
    );
  }

  Widget buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 55,
              backgroundColor: Colors.orange,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            buildTextField(
              label: "First Name",
              controller: firstNameController,
              icon: Icons.person,
            ),

            buildTextField(
              label: "Last Name",
              controller: lastNameController,
              icon: Icons.person_outline,
            ),

            buildTextField(
              label: "Email",
              controller: emailController,
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),

            buildTextField(
              label: "Phone Number",
              controller: phoneController,
              icon: Icons.phone,
              keyboardType: TextInputType.phone,
            ),

            buildTextField(
              label: "Address",
              controller: addressController,
              icon: Icons.location_on,
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}