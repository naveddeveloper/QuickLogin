import 'package:flutter/material.dart';
import 'package:quicklogin/screens/home_screen.dart';
import 'package:quicklogin/screens/login_screen.dart';
import 'package:quicklogin/screens/signup_screen.dart';

class OnboardingScreen extends StatefulWidget {
  bool loggedin;
  OnboardingScreen({super.key, required this.loggedin});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return widget.loggedin
        ? HomeScreen()
        : Scaffold(
          body: SafeArea(
            child: Stack(
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
                      SizedBox(height: size.height * 0.05),

                      Image.asset(
                        'assets/auth-onboarding.png',
                        fit: BoxFit.contain,
                      ),

                      SizedBox(height: size.height * 0.05),

                      Text(
                        "Authentication with QuickLogin",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.1,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple,
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      // Subtitle Text
                      Text(
                        "Secure & Seamless Login for Everyone,\nOne-Tap Access with Google, Facebook & More",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: size.width * 0.04,
                          color: Colors.grey[700],
                        ),
                      ),

                      // Spacing before buttons
                      SizedBox(height: size.height * 0.05),

                      // Row of Buttons (Login & Register)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple,
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02,
                                horizontal: size.width * 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 4,
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: size.width * 0.05),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignupScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple.shade100,
                              padding: EdgeInsets.symmetric(
                                vertical: size.height * 0.02,
                                horizontal: size.width * 0.1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 1,
                            ),
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                fontSize: size.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Bottom spacing
                      SizedBox(height: size.height * 0.05),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
  }
}
