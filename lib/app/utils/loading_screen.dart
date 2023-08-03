import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart'; 
import 'package:rive/rive.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( 
        child: RiveAnimation.asset('assets/food.riv',fit: BoxFit.cover))
    );
  }
}
