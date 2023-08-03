import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/food_model.dart';

class FoodDetailsScreen extends StatefulWidget {
  final Food food;

  const FoodDetailsScreen({super.key, required this.food});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isFavorite = prefs.getBool(widget.food.id ?? '') ?? false;
    });
  }

  Future<void> _toggleFavoriteStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool newStatus = !(prefs.getBool(widget.food.id ?? '') ?? false);
    prefs.setBool(widget.food.id ?? '', newStatus);
    if (newStatus) {
      await _addToFavorites();
    } else {
      await _removeFromFavorites();
    }
    setState(() {
      isFavorite = newStatus;
    });
  }

  Future<void> _addToFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Food> favoriteFoods = await _getFavoriteFoods();
    if (!favoriteFoods.contains(widget.food)) {
      favoriteFoods.add(widget.food);
      prefs.setStringList('favorite_foods',
          favoriteFoods.map((food) => json.encode(food.toMap())).toList());
      setState(() {
        isFavorite = true;
      });
    }
  }

  Future<void> _removeFromFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Food> favoriteFoods = await _getFavoriteFoods();
    if (favoriteFoods.contains(widget.food)) {
      favoriteFoods.remove(widget.food);
      prefs.setStringList('favorite_foods',
          favoriteFoods.map((food) => json.encode(food.toMap())).toList());
      setState(() {
        isFavorite = false;
      });
    }
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.name ?? "Food Details"),
        actions: [
          IconButton(
              onPressed: () {
                _toggleFavoriteStatus();
              },
              icon: isFavorite
                  ? const Icon(Icons.favorite)
                  : const Icon(Icons.favorite_border_rounded))
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: widget.food.imageUrl ?? "",
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildDetailRow(context, "Description",
                widget.food.description ?? 'No description available.'),
            _buildDetailRow(context, "Ingredients",
                widget.food.ingredients?.join(', ') ?? 'Not specified.'),
            _buildDetailRow(context, "Dietary Restrictions",
                widget.food.dietaryRestrictions?.join(', ') ?? 'None'),
            _buildDetailRow(
                context, "Protein", "${widget.food.protein ?? 0} g"),
            _buildDetailRow(context, "Carbs", "${widget.food.carbs ?? 0} g"),
            _buildDetailRow(context, "Fat", "${widget.food.fat ?? 0} g"),
            _buildDetailRow(context, "Allergies",
                widget.food.allergies?.join(', ') ?? 'None'),
            _buildDetailRow(context, "Health Issues",
                widget.food.healthIssues?.join(', ') ?? 'None'),
            _buildDetailRow(
                context, "Minimum Age", "${widget.food.minAge ?? 0} years"),
            _buildDetailRow(
                context, "Maximum Age", "${widget.food.maxAge ?? 0} years"),
            _buildDetailRow(
                context, "Uploaded By", widget.food.uploadedBy ?? 'Unknown'),
            _buildDetailRow(
                context, "Average Rating", "${widget.food.averageRating ?? 0}"),
            _buildDetailRow(context, "Number of Ratings",
                "${widget.food.numberOfRatings ?? 0}"),
            _buildDetailRow(context, "Uploaded Date",
                widget.food.uploadedDate?.toString() ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String title, String data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(
          data,
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
