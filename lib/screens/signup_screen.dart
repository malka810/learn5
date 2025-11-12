import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Text("Learn5", style: AppTheme.titleStyle)),
                const SizedBox(height: 40),

                Text("Register", style: AppTheme.heading),
                const SizedBox(height: 25),

                Text("Full Name", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                Text("Email", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                Text("Password", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                Text("Confirm Password", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 18),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already Member? ",
                      style: TextStyle(color: Colors.black87, fontSize: 14),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFF505000),
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    style: AppTheme.mainButton,
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Input Decoration
  InputDecoration _inputDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: Colors.grey.withOpacity(0.4)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.brown, width: 1.5),
      ),
    );
  }
}
