import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ---------------- LOGO ----------------
                Image.asset("assets/icons/icon.png", width: 100),
                const SizedBox(height: 20),

                Text(
                  "Get Started",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),

                // ---------------- NAME FIELD ----------------
                TextFormField(
                  controller: name,
                  decoration: InputDecoration(
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Name required";
                    if (val.length < 3) return "Enter valid name";
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ---------------- EMAIL FIELD ----------------
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Email required";
                    if (!val.contains("@") || !val.contains(".")) {
                      return "Enter a valid email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // ---------------- PASSWORD FIELD ----------------
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) return "Password required";
                    if (val.length < 6) return "Minimum 6 characters";
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                if (errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                // ---------------- SIGNUP BUTTON ----------------
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final error = await auth.signUp(
                          name.text.trim(),
                          email.text.trim(),
                          password.text.trim(),
                        );

                        if (error == null) {
                          Navigator.pushReplacementNamed(context, "/home");
                        } else {
                          setState(() => errorMessage = error);
                        }
                      }
                    },
                    child: const Text("Sign Up"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
