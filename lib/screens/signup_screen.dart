import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';
import 'login_screen.dart';
import 'package:learn5/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // ----------------------------
  // CONTROLLERS
  // ----------------------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // ----------------------------
  // SERVICE + STATE
  // ----------------------------
  final AuthService _authService = AuthService();
  bool _loading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ----------------------------
  // REGISTER FUNCTION
  // ----------------------------
  Future<void> _registerUser() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final pass = passwordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || pass.isEmpty || confirmPass.isEmpty) {
      return _showError("All fields are required");
    }

    if (pass != confirmPass) {
      return _showError("Passwords do not match");
    }

    setState(() => _loading = true);

    try {
      await _authService.registerWithEmail(
        email: email,
        password: pass,
        fullName: name,
      );

      // Go to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      _showError(e.message ?? "Registration failed");
    } catch (e) {
      _showError("Unknown error: $e");
    } finally {
      setState(() => _loading = false);
    }
  }

  // ----------------------------
  // ERROR MESSAGE HANDLER
  // ----------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
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

                // ---------------------- FULL NAME ----------------------
                Text("Full Name", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: nameController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                // ---------------------- EMAIL ----------------------
                Text("Email", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: emailController,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                // ---------------------- PASSWORD ----------------------
                Text("Password", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                ),
                const SizedBox(height: 18),

                // ---------------------- CONFIRM PASSWORD ----------------------
                Text("Confirm Password", style: AppTheme.labelStyle),
                const SizedBox(height: 4),
                TextField(
                  controller: confirmPasswordController,
                  obscureText: true,
                  decoration: _inputDecoration(),
                ),

                const SizedBox(height: 18),

                // ---------------------- LOGIN LINK ----------------------
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

                // ---------------------- REGISTER BUTTON ----------------------
                Center(
                  child: ElevatedButton(
                    style: AppTheme.mainButton,
                    onPressed: _loading ? null : _registerUser,
                    child: Text(
                      _loading ? "Registering..." : "Register",
                      style: const TextStyle(color: Colors.white, fontSize: 18),
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

  // ----------------------
  // INPUT DECORATION UI
  // ----------------------
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
