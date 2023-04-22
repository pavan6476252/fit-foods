import 'package:cloud_firestore/cloud_firestore.dart';

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
  );
}

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'imageUrl':imageUrl,
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
    String? imageUrl,
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
      imageUrl: imageUrl ?? this.imageUrl,
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
