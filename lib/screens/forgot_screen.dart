import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';

class ForgotScreen extends StatelessWidget {
  const ForgotScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(gradient: AppTheme.mainGradient),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 60),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Text("Learn5", style: AppTheme.titleStyle)),
              const SizedBox(height: 40),

              Text("Reset Password", style: AppTheme.heading),
              const SizedBox(height: 20),

              TextField(
                controller: emailController,
                decoration: _inputDecoration("Enter your email"),
              ),
              const SizedBox(height: 30),

              Center(
                child: ElevatedButton(
                  style: AppTheme.mainButton,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Password reset link sent to your email.",
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    "Send Reset Link",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
    );
  }
}
