import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/food_model.dart';

class SearchPage extends StatefulWidget {
  String query;

  SearchPage({required this.query, super.key});
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Food>? foods;

  var age;

  List<String>? healthIssues;

  List<String>? allergies;

  @override
  void initState() {
    super.initState();
    _getSafeFoods();
  }

  Future<void> _getSafeFoods() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      allergies = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user!.email)
          .get()
          .then((doc) => List<String>.from(doc['allergies']));
      healthIssues = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .get()
          .then((doc) => List<String>.from(doc['healthIssues']));

      age = await FirebaseFirestore.instance
          .collection('userData')
          .doc(user.email)
          .get()
          .then((doc) => doc['age']);

      final snapshot =
          await FirebaseFirestore.instance.collection('foods').get();

      final safeFoods = snapshot.docs
          .map((doc) => Food.fromFirestore(doc))
          // .where((food) =>
          //     (food.allergies == null ||
          //         !food.allergies!
          //             .any((allergy) => allergies.contains(allergy))) &&
          //     (food.healthIssues == null ||
          //         !food.healthIssues!
          //             .any((issue) => healthIssues.contains(issue))) &&
          //     food.minAge! <= age &&
          //     food.maxAge! >= age)
          .toList();

      final filteredFoods = safeFoods
        .where((food) => food.name!.toLowerCase().contains(widget.query.toLowerCase()))
        .toList();

    setState(() {
      foods = filteredFoods;
    });
    } catch (e) {
      print("##############");

      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(appBar: AppBar(title: Text("Seach items")),
    body:
    
     foods==null 
        ? const Center(
            child: CircularProgressIndicator(),
          ) 
        : foods!.isEmpty ? const Center(child: Text("No items Found"),): ListView.builder(
          
           
            itemCount: foods!.length,
            itemBuilder: (context, index) {
              final food = foods![index];
              final isMatched = (food.allergies != null &&
                      food.allergies!
                          .any((allergy) => allergies!.contains(allergy))) ||
                  (food.healthIssues != null &&
                      food.healthIssues!
                          .any((issue) => healthIssues!.contains(issue))) ||
                  food.minAge! > age ||
                  food.maxAge! < age;

              return Container(
                margin: const EdgeInsets.all(5),
                width: double.maxFinite,
                height: 200,
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
                          width: double.maxFinite,
                          imageUrl: food.imageUrl ?? "",
                          placeholder: (context, url) =>
                              const Center(child: CircularProgressIndicator()),
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
                                    color: isMatched ? Colors.red :  Colors.black.withOpacity(0.5),
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: food.healthIssues != null &&
                                            healthIssues!.any((issue) => food
                                                .healthIssues!
                                                .contains(issue))
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.black.withOpacity(0.5),
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Text(
                                    food.name ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textAlign: TextAlign.center,
                                  ))))
                    ],
                  ),
                ),
              );
            },
     ) );
  }
}
