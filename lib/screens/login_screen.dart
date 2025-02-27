import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicklogin/screens/forgot_screen.dart';
import 'package:quicklogin/screens/home_screen.dart';
import 'package:quicklogin/screens/signup_screen.dart';
import 'package:quicklogin/utils/auth_service.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quicklogin/widgets/custom_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    debugPrint('Email: $email, Password: $password');

    if (email.isEmpty) {
      showCustomToast("Please enter email");
    } else if (password.isEmpty) {
      showCustomToast("Please enter password");
    }

    User? user = await _authService.signInWithEmail(
      email: email,
      password: password,
    );

    if (user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        (route) => false,
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Background Shape
          Positioned(
            top: -100,
            left: -50,
            child: Container(
              width: size.width / 1.1,
              height: size.height / 1.8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withOpacity(0.03),
              ),
            ),
          ),
          // Main Content
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: size.height * 0.1),

                  // Login Heading
                  Text(
                    "Login here",
                    style: TextStyle(
                      fontSize: size.width * 0.1,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Subtext
                  Text(
                    "Welcome Back!\nSecure & Simple Login",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: size.width * 0.05,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: size.height * 0.08),

                  _customTextField(
                    "Email",
                    _emailController,
                    TextInputType.emailAddress,
                  ),

                  SizedBox(height: size.height * 0.02),

                  _customTextField(
                    "Password",
                    _passwordController,
                    TextInputType.text,
                    isPassword: true
                  ),
                  SizedBox(height: size.height * 0.02),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot your password?",
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),

                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: size.height * 0.07,
                    child: ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        "Sign in",
                        style: TextStyle(
                          fontSize: size.width * 0.06,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Create New Account
                  TextButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SignupScreen()),
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Create new account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  // OR Continue With
                  Text(
                    "Or continue with",
                    style: TextStyle(fontSize: 14, color: Colors.purple),
                  ),
                  SizedBox(height: size.height * 0.03),

                  // Social Media Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _socialIcon(
                        FontAwesomeIcons.google,
                        Colors.red,
                        () async {
                          User? user = await _authService.signInWithGoogle();
                          if (user != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(user: user),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      SizedBox(width: size.width * 0.03),
                      _socialIcon(
                        FontAwesomeIcons.facebook,
                        Colors.blue,
                        () async {
                          User? user = await _authService.signInWithFacebook();
                          if (user != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(user: user),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                      SizedBox(width: size.width * 0.03),
                      _socialIcon(
                        FontAwesomeIcons.twitter,
                        Colors.lightBlue,
                        () async {
                          User? user = await _authService.signInWithTwitter();
                          if (user != null) {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeScreen(user: user),
                              ),
                              (route) => false,
                            );
                          }
                        },
                      ),
                    ],
                  ),

                  SizedBox(width: size.width * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom TextField Widget
  Widget _customTextField(
    String label,
    TextEditingController controller,
    TextInputType inputType, {
    bool isPassword = false,
  }) {
    return TextField(
      keyboardType: inputType,
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.purple[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // Social Media Icon Widget
  Widget _socialIcon(IconData icon, Color color, VoidCallback tapFunction) {
    return GestureDetector(
      onTap: tapFunction,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
