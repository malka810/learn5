import 'package:flutter/material.dart';
import 'package:learn5/theme.dart';
import 'package:video_player/video_player.dart';
import 'home_screen.dart';
import 'signup_screen.dart';
import 'forgot_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/login_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.setLooping(true);
        _controller.play();
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

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
                  child: _controller.value.isInitialized
                      ? Container(
                          width: 152,
                          height: 152,
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.transparent,
                            border: Border.all(
                              color: const Color.fromARGB(255, 255, 255, 250),
                              width: 2.0,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 8,
                                offset: const Offset(4, 4),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: SizedBox(
                              width: 150,
                              height: 150,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        )
                      : const CircularProgressIndicator(),
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
                  obscureText: true,
                  decoration: _inputDecoration("Password"),
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
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const HomeScreen()),
                      );
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
                    onTap: () {
                      debugPrint("Google Sign-In clicked");
                    },
                    child: Container(
                      width: 250,
                      height: 45,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
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
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              'assets/images/google.png',
                              height: 24,
                              width: 24,
                            ),
                          ),
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
