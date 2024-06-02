import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Response {
  final User? user;
  final String status;
  const Response({required this.user, required this.status});
}

class AuthService {
  final _auth = FirebaseAuth.instance;

  String exceptionHandler(String e) {
    switch (e) {
      case 'user-not-found':
        return "No user found";
      case 'invalid-credential':
        return "Invalid Login Credentials.";
      case 'weak-password':
        return "Password must be atleast 8 characters";
      case 'email-already-in-use':
        return "Email Already in use.";
    }
    return "Undefined error.";
  }

  Future<void> sendEmailVerificationLink() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Response> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      // final list = await _auth.fetchSignInMethodsForEmail(email);
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return Response(user: cred.user, status: "Success");
    } on FirebaseAuthException catch (e) {
      log(e.code);
      return Response(user: null, status: exceptionHandler(e.code));
    } catch (e) {
      log(e.toString());
    }
    return Response(user: null, status: "Something went wrong.");
  }

  Future<Response> loginUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return Response(user: cred.user, status: "Success");
    } on FirebaseAuthException catch (e) {
      return Response(user: null, status: exceptionHandler(e.code));
    } catch (e) {
      log(e.toString());
    }
    return Response(user: null, status: "Something went wrong.");
  }

  Future<Response> signout() async {
    try {
      await _auth.signOut();
      return Response(user: null, status: "Success");
    } catch (e) {
      log(e.toString());
    }
    return Response(user: null, status: "Logout Error.");
  }

  Future<UserCredential?> loginWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;
      final cred = GoogleAuthProvider.credential(
          idToken: googleAuth?.idToken, accessToken: googleAuth?.accessToken);
      return await _auth.signInWithCredential(cred);
    } catch (e) {
      log(e.toString());
    }
    return null;
  }
}
