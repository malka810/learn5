import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';
import 'forgot_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:learn5/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthService _authService = AuthService();

  bool _loading = false;
  String? _errorMessage;

  bool _obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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

                Center(
                  child: Container(
                    width: 155,
                    height: 155,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      border: Border.all(
                        color: const Color.fromARGB(
                          255,
                          4,
                          4,
                          0,
                        ).withOpacity(0.5),
                        width: 4.0,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromARGB(
                            255,
                            247,
                            255,
                            160,
                          ).withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/login_image.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                Text("Login", style: AppTheme.heading),
                const SizedBox(height: 20),

                TextField(
                  controller: emailController,
                  decoration: _inputDecoration("Email"),
                ),
                const SizedBox(height: 18),

                TextField(
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  decoration: _inputDecoration(
                    "Password",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "New Here? Register",
                        style: AppTheme.bodyText.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: AppTheme.bodyText.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Center(
                  child: ElevatedButton(
                    style: AppTheme.mainButton,
                    onPressed: _loading
                        ? null
                        : () async {
                            setState(() {
                              _loading = true;
                              _errorMessage = null;
                            });

                            try {
                              await _authService.signInWithEmail(
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const HomeScreen(),
                                ),
                              );
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                _errorMessage =
                                    e.message ?? 'Authentication failed';
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(_errorMessage!)),
                              );
                            } finally {
                              if (mounted) {
                                setState(() {
                                  _loading = false;
                                });
                              }
                            }
                          },
                    child: const Text(
                      "Let's Learn",
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Expanded(
                      child: Divider(thickness: 1, color: Color(0xFF202200)),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        "OR",
                        style: TextStyle(
                          color: Color(0xFF202200),
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(thickness: 1, color: Color(0xFF202200)),
                    ),
                  ],
                ),

                const SizedBox(height: 25),

                Center(
                  child: GestureDetector(
                    onTap: () async {
                      UserCredential result = await _authService
                          .signInWithGoogle();

                      if (result.user != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const HomeScreen()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Google Sign-In failed"),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: 230,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 2,
                            offset: const Offset(3, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/google.png',
                            height: 24,
                            width: 24,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            "Sign in with Google",
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

  InputDecoration _inputDecoration(String label, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white.withOpacity(0.9),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
      suffixIcon: suffixIcon,
    );
  }
}
