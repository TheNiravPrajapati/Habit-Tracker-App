import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  bool loading = false;
  String? errorText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              /// LOGO
              Image.asset(
                "assets/icons/icon.png",
                width: 120,
                height: 120,
              ),

              const SizedBox(height: 20),

              Text("Welcome Back!",
                  style: theme.textTheme.headlineMedium!
                      .copyWith(fontWeight: FontWeight.bold)),

              const SizedBox(height: 30),

              /// EMAIL FIELD
              _glassField(
                controller: email,
                hint: "Email",
                icon: Icons.email_outlined,
              ),

              const SizedBox(height: 15),

              /// PASSWORD FIELD
              _glassField(
                controller: password,
                hint: "Password",
                icon: Icons.lock_outline,
                obscure: true,
              ),

              const SizedBox(height: 15),

              if (errorText != null)
                Text(errorText!, style: const TextStyle(color: Colors.red)),

              const SizedBox(height: 20),

              /// LOGIN BUTTON
              _primaryButton(
                text: loading ? "Please wait..." : "Login",
                onTap: loading ? null : _login,
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (_) => const SignupScreen()));
                },
                child: const Text("Create an Account"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      loading = true;
      errorText = null;
    });

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final error = await auth.login(email.text.trim(), password.text.trim());

    if (error != null) {
      setState(() {
        loading = false;
        errorText = error;
      });
    } else {
      Navigator.pushReplacementNamed(context, "/home");
    }
  }

  /// Transparent Glass Input Field
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  /// Gradient button
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
            style:
            const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
