import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  bool loading = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);

    nameController.text = auth.user?.displayName ?? "";
    emailController.text = auth.user?.email ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: Colors.teal.shade100,
              child: Icon(Icons.person, size: 50, color: Colors.teal.shade700),
            ),

            const SizedBox(height: 24),

            _inputField(
              controller: nameController,
              hint: "Full Name",
              icon: Icons.person_outline,
            ),

            const SizedBox(height: 15),

            _inputField(
              controller: emailController,
              hint: "Email Address",
              icon: Icons.email_outlined,
            ),

            const SizedBox(height: 15),

            if (errorMessage != null)
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),

            const SizedBox(height: 20),

            _primaryButton(
              text: loading ? "Saving..." : "Save Changes",
              onTap: loading ? null : _saveChanges,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final error = await auth.updateProfile(
      nameController.text.trim(),
      emailController.text.trim(),
    );

    if (error != null) {
      setState(() {
        loading = false;
        errorMessage = error;
      });
    } else {
      Navigator.pop(context, true); // Return success to Profile page
    }
  }

  /// Transparent glass field UI (same as login/signup)
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          border: InputBorder.none,
          hintText: hint,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Gradient Save button
  Widget _primaryButton({required String text, required VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1ABC9C), Color(0xFF16A085)],
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
