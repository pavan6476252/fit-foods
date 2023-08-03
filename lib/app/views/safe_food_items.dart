import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitfood_medirec/app/utils/loading_screen.dart';
import 'package:flutter/material.dart';

import '../models/food_model.dart';

class SafeFoodsScreen extends StatefulWidget {
  @override
  _SafeFoodsScreenState createState() => _SafeFoodsScreenState();
}

class _SafeFoodsScreenState extends State<SafeFoodsScreen> {
  List<Food> foods = [];

  @override
  void initState() {
    super.initState();
    _getSafeFoods();
  }

  Future<void> _getSafeFoods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final allergies = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user!.email)
          .get()
          .then((doc) => List<String>.from(doc['allergies']));
      final healthIssues = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .get()
          .then((doc) => List<String>.from(doc['healthIssues']));

      final age = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .get()
          .then((doc) => doc['age']);

      final snapshot =
          await FirebaseFirestore.instance.collection('foods').limit(8).get();

      final safeFoods = snapshot.docs
          .map((doc) => Food.fromFirestore(doc))
          .where((food) =>
              (food.allergies == null ||
                  !food.allergies!
                      .any((allergy) => allergies.contains(allergy))) &&
              (food.healthIssues == null ||
                  !food.healthIssues!
                      .any((issue) => healthIssues.contains(issue))) &&
              food.minAge! <= age &&
              food.maxAge! >= age)
          .toList();

      setState(() {
        foods = safeFoods;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error while loading data")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return foods.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final food = foods[index];
              return SizedBox(
                width: 150,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          height: double.maxFinite,
                          imageUrl: food.imageUrl ?? "",
                          placeholder: (context, url) => const LoadingScreen(),
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            food.name ?? "",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
