import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:medirec/features/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:medirec/features/Home/home_page.dart';
import 'features/auth/auth_services.dart';
import 'features/firebase/firestore_services.dart';
import 'firebase_options.dart';

import 'package:go_router/go_router.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final savedThemeMode = await AdaptiveTheme.getThemeMode();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
      providers: [
        Provider<FirestoreService>(create: (_) => FirestoreService()),
      ],
      child: App(
          // savedThemeMode: savedThemeMode,
          )));
}

class App extends StatelessWidget {
  final loginInfo = AuthService();

  late final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(
          signOut: () {},
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
    ],
    redirect: (context, state) {
      final loginInfo = context.watch<AuthService>();
      final loggedIn = loginInfo.fully_authenticated;
      final loggingIn = state.subloc == '/login';
      if (!loggedIn) {
      // if (true) {
        return loggingIn ? null : '/login';
      }

      if (loggingIn) return '/';

      return null;
    },
  );

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<AuthService>.value(
        value: loginInfo,
        child: MaterialApp.router(
          theme: ThemeData(useMaterial3: true),
          routeInformationParser: _router.routeInformationParser,
          routerDelegate: _router.routerDelegate,
        ),
      );
}

// class MyApp extends StatefulWidget {
//   AdaptiveThemeMode? savedThemeMode;
//   MyApp({super.key, required this.savedThemeMode});

//   @override
//   State<StatefulWidget> createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   User? _user;

//   @override
//   void initState() {
//     super.initState();
//     _checkCurrentUser();
//   }

//   void _checkCurrentUser() async {
//     final user = _auth.currentUser;
//     if (user != null) {
//       setState(() {
//         _user = user;
//       });
//     }
//   }

//   void _signInWithGoogle() async {
//     try {
//       final googleUser = await _googleSignIn.signIn();
//       final googleAuth = await googleUser?.authentication;
//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth?.accessToken,
//         idToken: googleAuth?.idToken,
//       );
//       final userCredential = await _auth.signInWithCredential(credential);
//       setState(() {
//         _user = userCredential.user;
//       });
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _signOut() async {
//     await _auth.signOut();
//     await _googleSignIn.signOut();
//     setState(() {
//       _user = null;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AdaptiveTheme(
//         light: ThemeData(
//           brightness: Brightness.light,
//           useMaterial3: true,
//         ),
//         dark: ThemeData(
//           brightness: Brightness.dark,
//           useMaterial3: true,
//         ),
//         initial: widget.savedThemeMode ?? AdaptiveThemeMode.system,
//         builder: (theme, darkTheme) => MaterialApp(
//               theme: theme,
//               darkTheme: darkTheme,
//               debugShowCheckedModeBanner: false,
//               title: 'Medirec',
//               home: _user != null
//                   ? HomePage(signOut: _signOut)
//                   : LoginScreen(signInWithGoogle: _signInWithGoogle),
//             ));
//   }
// }

// class LoginScreen extends StatelessWidget {
//   final VoidCallback signInWithGoogle;

//   const LoginScreen({Key? key, required this.signInWithGoogle})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               'Medirec',
//               style: TextStyle(fontSize: 24.0),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton.icon(
//               icon: Icon(Icons.login),
//               label: Text('Sign in with Google'),
//               onPressed: signInWithGoogle,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
