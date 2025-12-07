import 'package:flutter/material.dart';
import 'package:habit_tracker_app/screens/auth/signup_screen.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            children: [
              // ------------------ LOGO ------------------
              Image.asset(
                "assets/icons/icon.png",
                width: 120,
                height: 120,
              ),
              const SizedBox(height: 20),

              Text(
                "Welcome Back!",
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),

              // ------------------ EMAIL FIELD ------------------
              TextField(
                controller: email,
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 16),

              // ------------------ PASSWORD FIELD ------------------
              TextField(
                controller: password,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 20),

              if (errorMessage != null)
                Text(
                  errorMessage!,
                  style: const TextStyle(color: Colors.red),
                ),

              const SizedBox(height: 10),

              // ------------------ LOGIN BUTTON ------------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    final error =
                    await auth.login(email.text.trim(), password.text.trim());
                    if (error == null) {
                      Navigator.pushReplacementNamed(context, "/home");
                    } else {
                      setState(() => errorMessage = error);
                    }
                  },
                  child: const Text("Login"),
                ),
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const SignupScreen()),
                  );
                },
                child: const Text("Create an Account"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
