import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/food_model.dart';

class SafeFoodsScreen extends StatefulWidget {
  @override
  _SafeFoodsScreenState createState() => _SafeFoodsScreenState();
}

class _SafeFoodsScreenState extends State<SafeFoodsScreen> {
  List<Food> _foods = [];

  @override
  void initState() {
    super.initState();
    _getSafeFoods();
  }

  Future<void> _getSafeFoods() async {
    final user = FirebaseAuth.instance.currentUser;
    final allergies = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((doc) => List<String>.from(doc['allergies']));
    final healthIssues = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((doc) => List<String>.from(doc['healthIssues']));
    final age = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get()
        .then((doc) => doc['age']);

    final snapshot = await FirebaseFirestore.instance.collection('foods').get();

    final safeFoods = snapshot.docs
        .map((doc) => Food.fromFirestore(doc))
        .where((food) =>
            !food.allergies.any((allergy) => allergies.contains(allergy)) &&
            !food.healthIssues.any((issue) => healthIssues.contains(issue)) &&
            food.minAge <= age &&
            food.maxAge >= age)
        .toList();

    setState(() {
      _foods = safeFoods;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Safe Foods'),
      ),
      body: _foods.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _foods.length,
              itemBuilder: (context, index) {
                final food = _foods[index];
                return ListTile(
                  title: Text(food.name),
                  subtitle: Text(
                      'Protein: ${food.protein}g | Carbs: ${food.carbs}g | Fat: ${food.fat}g'),
                );
              },
            ),
    );
  }
}
