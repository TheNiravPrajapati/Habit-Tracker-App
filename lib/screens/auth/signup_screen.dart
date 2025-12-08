import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool loading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create Account"),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [

              /// LOGO
              Image.asset(
                "assets/icons/icon.png",
                width: 110,
                height: 110,
              ),

              const SizedBox(height: 16),

              Text("Let's get started!",
                  style: theme.textTheme.headlineSmall!
                      .copyWith(fontWeight: FontWeight.bold)),

              const SizedBox(height: 32),

              _glassField(
                controller: name,
                hint: "Full Name",
                icon: Icons.person_outline,
              ),

              const SizedBox(height: 15),

              _glassField(
                controller: email,
                hint: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 15),

              _glassField(
                controller: password,
                hint: "Password",
                obscure: true,
                icon: Icons.lock_outline,
              ),

              const SizedBox(height: 15),

              if (errorText != null)
                Text(errorText!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              _primaryButton(
                text: loading ? "Creating..." : "Sign Up",
                onTap: loading ? null : _signup,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signup() async {
    setState(() {
      loading = true;
      errorText = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);

    final error = await auth.signUp(
      name.text.trim(),
      email.text.trim(),
      password.text.trim(),
    );

    if (error != null) {
      setState(() {
        errorText = error;
        loading = false;
      });
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  Widget _glassField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.teal.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.teal),
          hintText: hint,
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

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
