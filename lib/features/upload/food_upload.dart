import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rive/rive.dart';
import 'package:uuid/uuid.dart';

import '../../app/models/food_model.dart';

class UploadFoodScreen extends StatefulWidget {
  const UploadFoodScreen({Key? key}) : super(key: key);

  @override
  _UploadFoodScreenState createState() => _UploadFoodScreenState();
}

class _UploadFoodScreenState extends State<UploadFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbsController = TextEditingController();
  final _fatController = TextEditingController();
  final _allergiesController = TextEditingController();
  final _healthIssuesController = TextEditingController();
  final _minAgeController = TextEditingController();
  final _maxAgeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _dietaryRestrictionsController = TextEditingController();

  bool _isLoading = false;
  XFile? pickedFile;

  Future<void> _pickImage() async {
    pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {});
  }

  Future<void> _uploadFoodItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        Reference storageReference = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().toString()}');

        UploadTask uploadTask =
            storageReference.putFile(File(pickedFile!.path));
        TaskSnapshot taskSnapshot = await uploadTask
            .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image uploaded successfully')),
                ));
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        final foodItem = Food(
          id: const Uuid().v1(),
          name: _nameController.text,
          imageUrl: downloadUrl,
          protein: int.tryParse(_proteinController.text) ?? 0,
          carbs: int.tryParse(_carbsController.text) ?? 0,
          fat: int.tryParse(_fatController.text) ?? 0,
          allergies: _allergiesController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          healthIssues: _healthIssuesController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          minAge: int.tryParse(_minAgeController.text) ?? 0,
          maxAge: int.tryParse(_maxAgeController.text) ?? 0,
          uploadedBy: FirebaseAuth.instance.currentUser!.email!,
          description: _descriptionController.text,
          ingredients: _ingredientsController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          dietaryRestrictions: _dietaryRestrictionsController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          averageRating: 0.0,
          numberOfRatings: 0,
          uploadedDate: DateTime.now(),
          foodCategory: _selectedCategory, // Add this line
        );

        final docRef = await FirebaseFirestore.instance
            .collection('foods')
            .add(foodItem.toMap());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Food item uploaded successfully')),
        );

        setState(() {
          _nameController.text = '';
          _proteinController.text = '';
          _carbsController.text = '';
          _fatController.text = '';
          _allergiesController.text = '';
          _healthIssuesController.text = '';
          _minAgeController.text = '';
          _maxAgeController.text = '';
          _isLoading = false;
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.toString())),
        );
      }
    }
  }

  FoodCategory? _selectedCategory; // Add this line

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Food Item'),
      ),
      body: _isLoading
          ? const Center(
              child: RiveAnimation.asset('assets/upload.riv'),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Name'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: pickedFile == null
                          ? const Text('No image selected.')
                          : Image.file(
                              File(pickedFile!.path),
                              fit: BoxFit.cover,
                            ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        await _pickImage();
                      },
                      child: const Text("Select Image"),
                    ),
                    _buildCategoryDropDown(),
                    TextFormField(
                      controller: _proteinController,
                      decoration: const InputDecoration(labelText: 'Protein'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the protein amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _carbsController,
                      decoration: const InputDecoration(labelText: 'Carbs'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the Carbs amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _fatController,
                      decoration: const InputDecoration(labelText: 'Fat'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter the fat amount';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _allergiesController,
                      decoration: const InputDecoration(
                          labelText: 'Allergies (separate with commas)'),
                    ),
                    TextFormField(
                      controller: _healthIssuesController,
                      decoration: const InputDecoration(
                          labelText: 'Health Issues (separate with commas)'),
                    ),
                    TextFormField(
                      controller: _minAgeController,
                      decoration:
                          const InputDecoration(labelText: 'Minimum Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a minimum age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _maxAgeController,
                      decoration:
                          const InputDecoration(labelText: 'Maximum Age'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a minimum age';
                        }
                        if (int.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      maxLines: 3,
                      decoration:
                          const InputDecoration(labelText: 'Description'),
                    ),
                    TextFormField(
                      controller: _ingredientsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText: 'Ingredients (separate with commas)'),
                    ),
                    TextFormField(
                      controller: _dietaryRestrictionsController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                          labelText:
                              'Dietary Restrictions (separate with commas)'),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _uploadFoodItem();
        },
        child: const Icon(Icons.upload),
      ),
    );
  }

  Widget _buildCategoryDropDown() {
    return DropdownButtonFormField<FoodCategory>(
      value: _selectedCategory,
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
      items: FoodCategory.values.map((category) {
        return DropdownMenuItem<FoodCategory>(
          value: category,
          child: Text(category.toString().split('.').last),
        );
      }).toList(),
      decoration: const InputDecoration(labelText: 'Food Category'),
      validator: (value) {
        if (value == null) {
          return 'Please select a category';
        }
        return null;
      },
    );
  }
}
