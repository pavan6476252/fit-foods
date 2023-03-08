import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medirec/features/Home/home_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(ProviderScope(
      child: MyApp(
    savedThemeMode: savedThemeMode,
  )));
}

class MyApp extends StatefulWidget {
  AdaptiveThemeMode? savedThemeMode;
  MyApp({super.key, required this.savedThemeMode});

  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  User? _user;

  @override
  void initState() {
    super.initState();
    _checkCurrentUser();
  }

  void _checkCurrentUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _user = user;
      });
    }
  }

  void _signInWithGoogle() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      final googleAuth = await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      setState(() {
        _user = userCredential.user;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
    setState(() {
      _user = null;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
        light: ThemeData(
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        dark: ThemeData(
          brightness: Brightness.dark,
          useMaterial3: true,
        ),
        initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
              theme: theme,
              darkTheme: darkTheme,
              debugShowCheckedModeBanner: false,
              title: 'Medirec',
              home: _user != null
                  ? HomePage(signOut: _signOut)
                  : LoginScreen(signInWithGoogle: _signInWithGoogle),
            ));
  }
}

class LoginScreen extends StatelessWidget {
  final VoidCallback signInWithGoogle;

  const LoginScreen({Key? key, required this.signInWithGoogle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Medirec',
              style: TextStyle(fontSize: 24.0),
            ),
            SizedBox(height: 16.0),
            ElevatedButton.icon(
              icon: Icon(Icons.login),
              label: Text('Sign in with Google'),
              onPressed: signInWithGoogle,
            ),
          ],
        ),
      ),
    );
  }
}
