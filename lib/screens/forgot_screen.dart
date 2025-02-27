import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quicklogin/screens/login_screen.dart';
import 'package:quicklogin/widgets/custom_toast.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Send the reset email
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset email sent. Check your inbox.'),
        ),
      );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      // Show error message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: ${e.message}')));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
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
          // Main Content
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
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: size.width * 0.1,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple,
                  ),
                ),
                SizedBox(height: size.height * 0.02),

                // Subtitle
                Text(
                  "Enter your email and we'll send you a link to reset your password.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: size.height * 0.02,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: size.height * 0.04),

                // Email Input Field
                _customTextField("Email"),
                SizedBox(height: size.height * 0.04),

                // Reset Password Button
                _customButton(
                  text: "Reset Password",
                  onPressed: _isLoading ? null : _sendPasswordResetEmail,
                  size: size
                ),
                SizedBox(height: size.height * 0.02),

                // Back to Login
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false,
                    );
                    showCustomToast("Login");
                  },
                  child: Text(
                    "Back to Login",
                    style: TextStyle(fontSize: size.height * 0.02, fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Custom TextField Widget
  Widget _customTextField(String label) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: _emailController,
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

  // Custom Button Widget
  Widget _customButton({
    required String text,
    required Future<void> Function()? onPressed,
    required Size size
  }) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.07,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.purple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child:
            _isLoading
                ? const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
                : Text(
                  text,
                  style: TextStyle(fontSize: size.height * 0.025, color: Colors.white),
                ),
      ),
    );
  }
}
