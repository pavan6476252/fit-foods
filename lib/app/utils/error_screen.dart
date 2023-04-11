import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  Object e;
  StackTrace trace;
  ErrorScreen(this.e, this.trace, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(e.toString()),
      ),
    );
  }
}
