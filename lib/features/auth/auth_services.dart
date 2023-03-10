import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medirec/features/firebase/firestore_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/user_class.dart';

enum AuthStatus {
  uninitialized,
  authenticated,
  authenticating,
  unauthenticated,
}

class AuthService with ChangeNotifier {
  // CurrentUser? currentUser;
  bool fully_authenticated = false;

  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthStatus _status = AuthStatus.uninitialized;
  // User? _user;
  CurrentUser? _user;

  AuthService() {
    _auth.authStateChanges().listen((user) async {
      if (user == null) {
        fully_authenticated = false;
        _status = AuthStatus.unauthenticated;
      } else {
        _user = CurrentUser(
            emailId: user.email,
            mobileNumber: user.phoneNumber,
            name: user.displayName,
            photoUrl: user.photoURL);
        final prefs = await SharedPreferences.getInstance();
        if (prefs.getBool('fully_authenticated') == true) {
          fully_authenticated = true;
        } else {
          fully_authenticated = false;
        }

        _status = AuthStatus.authenticated;
      }
      notifyListeners();
    });
  }

  AuthStatus get status => _status;
  CurrentUser? get user => _user;
  bool newUser = false;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      _user = CurrentUser(
          emailId: userCredential.user!.email,
          mobileNumber: userCredential.user!.phoneNumber,
          name: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL);

      _status = AuthStatus.authenticated;
      // ignore: use_build_context_synchronously
      newUser = await _firestoreService.isDocumentPresent(
          context, _user!.emailId ?? "");
      if (newUser) {
        _user = await _firestoreService.getData(_user!.emailId ?? "");
      } else {
        _user = null;
      }

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      if (e.code == 'account-exists-with-different-credential') {
        var snackBar = const SnackBar(
          content:
              Text('The account already exists with a different credential.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'invalid-credential') {
        var snackBar = const SnackBar(
          content: Text('Error validating credential.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      var snackBar = SnackBar(
        content: Text('Error signing in with Google. ' + e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void signOut() async {
    final prefs = await SharedPreferences.getInstance();

    _auth.signOut();
    _googleSignIn.signOut();
    fully_authenticated = false;
    prefs.setBool('fully_authenticated', false);
    _status = AuthStatus.unauthenticated;
    notifyListeners();
  }

  bool showOtpDialog = false;
  bool otpField = false;
  String? verificationString;
  
  verifCompl(BuildContext context) async {
    await _firestoreService.updateData(context);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('fully_authenticated', true);
    fully_authenticated = true;
    notifyListeners();
  }

  Future<void> verifyPhoneNumber(String number, BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: number,
      codeSent: (String verificationId, int? resendToken) async {
        // Update the UI - wait for the user to enter the SMS code
        verificationString = verificationId;
        otpField = true;
        notifyListeners();
        // Create a PhoneAuthCredential with the code

        // Sign the user  in (or link) with the credential
        // await auth.signInWithCredential(credential);
      },
      verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
        verifCompl(context);
      },
      verificationFailed: (FirebaseAuthException error) {
        var snackBar = SnackBar(
          content: Text('Otp verification failed. $error'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
    //   String phoneNumber,
    //   BuildContext context,
    //   Function(PhoneAuthCredential) verificationCompleted,
    //   Function(String verificationId, [int? forceResendingToken]) codeSent,
    //   Function(String verificationId) codeAutoRetrievalTimeout,
    // ) async {
    //   try {
    //     await _auth.verifyPhoneNumber(
    //       phoneNumber: phoneNumber,
    //       verificationCompleted: verificationCompleted,
    //       codeSent: codeSent,
    //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    //       verificationFailed: (FirebaseAuthException error) {
    //         var snackBar = const SnackBar(
    //           content: Text('Error verifying phone number.'),
    //         );
    //         ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //       },
    //     );
    //   } catch (e) {
    //     var snackBar = const SnackBar(
    //       content: Text('Error verifying phone number.'),
    //     );
    //     ScaffoldMessenger.of(context).showSnackBar(snackBar);
    //   }
  }

  Future<void> signInWithPhoneNumber(
    String verificationId,
    String smsCode,
    BuildContext context,
  ) async {
    try {
      _status = AuthStatus.authenticating;
      notifyListeners();
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _user = CurrentUser(
          emailId: userCredential.user!.email,
          mobileNumber: userCredential.user!.phoneNumber,
          name: userCredential.user!.displayName,
          photoUrl: userCredential.user!.photoURL);

      _status = AuthStatus.authenticated;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      _status = AuthStatus.unauthenticated;
      notifyListeners();
      if (e.code == 'invalid-verification-code') {
        var snackBar = const SnackBar(
          content: Text('Invalid verification code.'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } else if (e.code == 'session-expired') {
        var snackBar = const SnackBar(
          content: Text('session-expired'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }
}
