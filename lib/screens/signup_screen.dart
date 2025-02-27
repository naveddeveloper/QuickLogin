import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quicklogin/screens/home_screen.dart';
import 'package:quicklogin/screens/login_screen.dart';
import 'package:quicklogin/utils/auth_service.dart';
import 'package:quicklogin/widgets/custom_toast.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _authService = AuthService();

  void _signup() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (password == confirmPassword) {
      debugPrint('Email: $email, Password: $password');

      User? user = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      if (user != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } else {
      showCustomToast("Password do not match");
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
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

          SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: size.width * 0.06,
              vertical: size.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.1),

                // Title
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Subtitle
                Text(
                  "Create an account so you can explore all the\n existing jobs",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.width * 0.04,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.05),

                // Email Field
                _customTextField(
                  "Email",
                  _emailController,
                  TextInputType.emailAddress,
                ),
                SizedBox(height: size.height * 0.02),

                // Password Field
                _customTextField(
                  "Password",
                  _passwordController,
                  TextInputType.text,
                  isPassword: true,
                ),
                SizedBox(height: size.height * 0.02),

                // Confirm Password Field
                _customTextField(
                  "Confirm Password",
                  _confirmPasswordController,
                  TextInputType.visiblePassword,
                  isPassword: true,
                ),
                SizedBox(height: size.height * 0.04),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: size.height * 0.07,
                  child: ElevatedButton(
                    onPressed: _signup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Sign up",
                      style: TextStyle(
                        fontSize: size.width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Already have an account?
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: Text(
                    "Already have an account",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: size.height * 0.03),

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
                    _socialIcon(FontAwesomeIcons.google, Colors.red, () async {
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
                    }),
                    SizedBox(width: size.width * 0.04),
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
                    SizedBox(width: size.width * 0.04),
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

                SizedBox(width: size.width * 0.04),
              ],
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
  Widget _socialIcon(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 24,
        backgroundColor: Colors.grey[200],
        child: Icon(icon, color: color, size: 28),
      ),
    );
  }
}
