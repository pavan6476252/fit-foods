import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitfood_medirec/app/views/food_details_page.dart';
import 'package:flutter/material.dart';
import '../models/food_model.dart';

class FoodCategoryPage extends StatelessWidget {
  const FoodCategoryPage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: double.maxFinite,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: FoodCategory.values.length,
        itemBuilder: (context, index) {
          final category = FoodCategory.values[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(label: Text(category.name)),
          );
        },
      ),
    );
  }
}
