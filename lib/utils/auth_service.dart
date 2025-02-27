import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quicklogin/utils/constants.dart';
import 'package:quicklogin/utils/local_storage_service.dart';
import 'package:quicklogin/widgets/custom_toast.dart';
import 'package:twitter_login/twitter_login.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create a new account with email and password(SignUp)
  Future<User?> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await LocalStorageService.saveUserData(
        userCredential.user!.uid,
        userCredential.user!.email!,
      );
      showCustomToast("Account created please login!");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        showCustomToast("The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        showCustomToast("The account already exists for that email.");
      } 
      showCustomToast("Error ${e.message}");
      return null;
    } catch (e) {
      showCustomToast("Error Occured");
      debugPrint("Error $e :: signUpWithEmail() AuthService");
      return null;
    }
  }

  // Signin with email and password (Login)
  Future<User?> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      if (await LocalStorageService.isUserLoggedIn()) {
        debugPrint("You are already loggedin");
        return null;
      }
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await LocalStorageService.saveUserData(
        userCredential.user!.uid,
        userCredential.user!.email!,
      );
      showCustomToast("You are loggedin: ${userCredential.user!.displayName ?? "User"}");

      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showCustomToast("User not found!");
      } else if (e.code == 'wrong-password') {
        showCustomToast("Wrong crendentials");
      } 
      showCustomToast("Error ${e.message}");
      return null;
    } catch (e) {
      showCustomToast("Error Occured");
      debugPrint("Error $e :: signInWithEmail() AuthService");
      return null;
    }
  }

  // SignIn With Google Account
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        showCustomToast("Cancelled the request try again!");
        debugPrint("Google User does not connect");
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(credential);

      LocalStorageService.saveUserData(
        userCredential.user!.uid,
        userCredential.user!.email!,
      );
      showCustomToast("You are loggedin: ${userCredential.user!.displayName}");

      return userCredential.user;
    } catch (e) {
      showCustomToast("Error $e");  
      debugPrint("Error $e :: signInWithGoogle() AuthService");
      return null;
    }
  }

  // SignIn With Facebook Account
  Future<User?> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final OAuthCredential credential = FacebookAuthProvider.credential(
          result.accessToken!.tokenString,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        await LocalStorageService.saveUserData(
          userCredential.user!.uid,
          userCredential.user!.email!,
        );
        return userCredential.user;
      } else {
        showCustomToast("Request denied try again!");
        return null;
      }
    } catch (e) {
      showCustomToast("Error $e");
      debugPrint("Error $e :: signInWithFacebook() AuthService");
      return null;
    }
  }

  // SignIn With Twitter Account
  Future<User?> signInWithTwitter() async {
    try {
      final twitterLogin = TwitterLogin(
        apiKey: QuickLoginConstants.twitterApiKey,
        apiSecretKey: QuickLoginConstants.twitterApiSecretKey,
        redirectURI: QuickLoginConstants.twitterRedirectUrl,
      );
      final authResult = await twitterLogin.login();

      if (authResult.status == TwitterLoginStatus.loggedIn) {
        final session = authResult.authToken;
        final tokenSecret = authResult.authTokenSecret;
        final credential = TwitterAuthProvider.credential(
          accessToken: session!,
          secret: tokenSecret!,
        );
        final userCredential = await _auth.signInWithCredential(credential);
        await LocalStorageService.saveUserData(
          userCredential.user!.uid,
          userCredential.user!.email!,
        );
        return userCredential.user;
      } else {
        showCustomToast("Request denied");
        return null;
      }
    } catch (e) {
      showCustomToast("Error $e");
      debugPrint("Error $e :: signInWithTwitter() AuthService");
      return null;
    }
  }

  // Logout
  Future<void> signOut() async {
    await _auth.signOut();
    await LocalStorageService.clearUserData();
    showCustomToast("Logout");
  }
}
