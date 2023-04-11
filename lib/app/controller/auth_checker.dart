
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../utils/error_screen.dart';
import '../utils/loading_screen.dart';
import '../views/home_page.dart';
import '../views/login_page.dart';
import 'auth_provider.dart';


class AuthChecker extends ConsumerWidget {
  const AuthChecker({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _authState = ref.watch(authStateProvider);
    return _authState.when(
        data: (data) {
          if (data != null) return  HomePage();
          return const LoginPage();
        },
        loading: () => const LoadingScreen(),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}