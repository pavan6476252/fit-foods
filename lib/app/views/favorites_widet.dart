import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food_model.dart';
import 'food_details_page.dart';

class FavoriteFoodsWidget extends StatefulWidget {
  const FavoriteFoodsWidget({super.key});

  @override
  State<FavoriteFoodsWidget> createState() => _FavoriteFoodsWidgetState();
}
class _FavoriteFoodsWidgetState extends State<FavoriteFoodsWidget> {
  List<Food> favoriteFoods = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    favoriteFoods = await _getFavoriteFoods();
    setState(() {});
  }

  Future<List<Food>> _getFavoriteFoods() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoriteFoodStrings = prefs.getStringList('favorite_foods');
    if (favoriteFoodStrings != null) {
      return favoriteFoodStrings.map((foodString) {
        Map<String, dynamic> foodMap = json.decode(foodString);
        return Food.fromMap(foodMap);
      }).toList();
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 5),
          child: Text(
            'Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(
          height: 250,
          width: double.maxFinite,
          child: favoriteFoods.isNotEmpty
              ? ListView.builder(

                  scrollDirection: Axis.horizontal,
                  itemCount: (favoriteFoods.length / 3).ceil(),
                  itemBuilder: (context, index) {
                    final startingIndex = index * 3;
                    final endingIndex = (index + 1) * 3;
                    final foodsForCurrentRow = favoriteFoods.sublist(
                        startingIndex,
                        endingIndex > favoriteFoods.length
                            ? favoriteFoods.length
                            : endingIndex);

                    return SizedBox(
                      width: 300,
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          mainAxisSpacing: 8.0,
                          childAspectRatio: 16 / 4,
                        ),
                        itemCount: foodsForCurrentRow.length,
                        itemBuilder: (context, subIndex) {
                          final food = foodsForCurrentRow[subIndex];
                          return Card(
                            child: ListTile(
                              leading: food.imageUrl != null
                                  ? CircleAvatar(
                                      backgroundImage:
                                          CachedNetworkImageProvider(
                                              food.imageUrl!),
                                    )
                                  : const Icon(Icons.fastfood),
                              title: Text(food.name ?? 'Unknown'),
                              subtitle: Text(food.description ?? ''),
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        FoodDetailsScreen(food: food),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                )
              : const Center(
                  child: Text("No favorite foods yet."),
                ),
        ),
      ],
    );
  }
}
