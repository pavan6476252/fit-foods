import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  final String id;
  final String name;
  final int protein;
  final int carbs;
  final int fat;
  final List<String> allergies;
  final List<String> healthIssues;
  final int minAge;
  final int maxAge;
  final String uploadedBy;

  Food({
    required this.id,
    required this.name,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.allergies,
    required this.healthIssues,
    required this.minAge,
    required this.maxAge,
    required this.uploadedBy,
  });

  factory Food.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Food(
      id: doc.id,
      name: data['name'],
      protein: data['protein'],
      carbs: data['carbs'],
      fat: data['fat'],
      allergies: List<String>.from(data['allergies']),
      healthIssues: List<String>.from(data['healthIssues']),
      minAge: data['minAge'],
      maxAge: data['maxAge'],
      uploadedBy: data['uploadedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'allergies': allergies,
      'healthIssues': healthIssues,
      'minAge': minAge,
      'maxAge': maxAge,
      'uploadedBy': uploadedBy,
    };
  }

  Food copyWith({
    String? name,
    int? protein,
    int? carbs,
    int? fat,
    List<String>? allergies,
    List<String>? healthIssues,
    int? minAge,
    int? maxAge,
    String? uploadedBy,
  }) {
    return Food(
      id: id,
      name: name ?? this.name,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      allergies: allergies ?? this.allergies,
      healthIssues: healthIssues ?? this.healthIssues,
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      uploadedBy: uploadedBy ?? this.uploadedBy,
    );
  }
}
