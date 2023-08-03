import 'package:cloud_firestore/cloud_firestore.dart';

enum FoodCategory {
  fruits,
  vegetables,
  grains,
  dairy,
  meat,
  seafood,
  desserts,
  snacks,
  beverages,
  condiments,
  others,
}

class Food {
  String? id;
  String? name;
  String? imageUrl;
  int? protein;
  int? carbs;
  int? fat;
  List<String>? allergies;
  List<String>? healthIssues;
  int? minAge;
  int? maxAge;
  String? uploadedBy;
  String? description;
  List<String>? ingredients;
  List<String>? dietaryRestrictions;
  double? averageRating;
  int? numberOfRatings;
  DateTime? uploadedDate;
  FoodCategory? foodCategory;

  Food({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.allergies,
    required this.healthIssues,
    required this.minAge,
    required this.maxAge,
    required this.uploadedBy,
    required this.description,
    required this.ingredients,
    required this.dietaryRestrictions,
    required this.averageRating,
    required this.numberOfRatings,
    required this.uploadedDate,
    required this.foodCategory,
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'],
      imageUrl: data['imageUrl'],
      protein: data['protein'],
      carbs: data['carbs'],
      fat: data['fat'],
      allergies: data['allergies'] != null ? List<String>.from(data['allergies']) : null,
      healthIssues: data['healthIssues'] != null ? List<String>.from(data['healthIssues']) : null,
      minAge: data['minAge'],
      maxAge: data['maxAge'],
      uploadedBy: data['uploadedBy'],
      description: data['description'],
      ingredients: data['ingredients'] != null ? List<String>.from(data['ingredients']) : null,
      dietaryRestrictions: data['dietaryRestrictions'] != null
          ? List<String>.from(data['dietaryRestrictions'])
          : null,
      averageRating: data['averageRating']?.toDouble(),
      numberOfRatings: data['numberOfRatings'],
      uploadedDate: data['uploadedDate'] != null ? (data['uploadedDate'] as Timestamp).toDate() : null,
      foodCategory: _parseFoodCategory(data['foodCategory']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl': imageUrl,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'allergies': allergies,
      'healthIssues': healthIssues,
      'minAge': minAge,
      'maxAge': maxAge,
      'uploadedBy': uploadedBy,
      'description': description,
      'ingredients': ingredients,
      'dietaryRestrictions': dietaryRestrictions,
      'averageRating': averageRating,
      'numberOfRatings': numberOfRatings,
      'uploadedDate': uploadedDate != null ? Timestamp.fromDate(uploadedDate!) : null,
      'foodCategory': foodCategory.toString().split('.').last,
    };
  }

  Food copyWith({
    String? id,
    String? name,
    String? imageUrl,
    int? protein,
    int? carbs,
    int? fat,
    List<String>? allergies,
    List<String>? healthIssues,
    int? minAge,
    int? maxAge,
    String? uploadedBy,
    String? description,
    List<String>? ingredients,
    List<String>? dietaryRestrictions,
    double? averageRating,
    int? numberOfRatings,
    DateTime? uploadedDate,
    FoodCategory? foodCategory,
  }) {
    return Food(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      allergies: allergies ?? this.allergies,
      healthIssues: healthIssues ?? this.healthIssues,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      description: description ?? this.description,
      ingredients: ingredients ?? this.ingredients,
      dietaryRestrictions: dietaryRestrictions ?? this.dietaryRestrictions,
      averageRating: averageRating ?? this.averageRating,
      numberOfRatings: numberOfRatings ?? this.numberOfRatings,
      uploadedDate: uploadedDate ?? this.uploadedDate,
      foodCategory: foodCategory ?? this.foodCategory,
    );
  }

  static FoodCategory _parseFoodCategory(String? category) {
    if (category == null) return FoodCategory.others;
    return FoodCategory.values.firstWhere(
      (e) => e.toString().split('.').last == category,
      orElse: () => FoodCategory.others,
    );
  }

  factory Food.fromMap(Map<String, dynamic> data) {
  return Food(
    id: data['id'],
    name: data['name'],
    imageUrl: data['imageUrl'],
    protein: data['protein'],
    carbs: data['carbs'],
    fat: data['fat'],
    allergies: data['allergies'] != null ? List<String>.from(data['allergies']) : null,
    healthIssues: data['healthIssues'] != null ? List<String>.from(data['healthIssues']) : null,
    minAge: data['minAge'],
    maxAge: data['maxAge'],
    uploadedBy: data['uploadedBy'],
    description: data['description'],
    ingredients: data['ingredients'] != null ? List<String>.from(data['ingredients']) : null,
    dietaryRestrictions: data['dietaryRestrictions'] != null
        ? List<String>.from(data['dietaryRestrictions'])
        : null,
    averageRating: data['averageRating']?.toDouble(),
    numberOfRatings: data['numberOfRatings'],
    uploadedDate: data['uploadedDate'] != null ? (data['uploadedDate'] as Timestamp).toDate() : null,
    foodCategory: _parseFoodCategory(data['foodCategory']),
  );
}

}
