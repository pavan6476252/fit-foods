import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../app/models/food_model.dart';

class UploadFoodScreen extends StatefulWidget {
  const UploadFoodScreen({super.key});

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

  bool _isLoading = false;
  XFile? pickedFile;

  Future<void> _pickImage() async {
     pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    
    // _imageFile = await FlutterImageCompress.compressAndGetFile(
    //   _imageFile!.path,
    //   _imageFile!.path,
    //   quality: 50,
    // );

    setState(() {});
  }


  Future<void> _uploadFoodItem() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        //upload image

         Reference storageReference = FirebaseStorage.instance
      .ref()
      .child('images/${DateTime.now().toString()}');

        UploadTask uploadTask = storageReference.putFile(File(pickedFile!.path));
        TaskSnapshot taskSnapshot = await uploadTask
            .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Image uploaded successfully')),
                ));
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      print(downloadUrl);

        final foodItem = Food(
          id: '',
          name: _nameController.text,
          imageUrl: downloadUrl,
          protein: int.parse(_proteinController.text),
          carbs: int.parse(_carbsController.text),
          fat: int.parse(_fatController.text),
          allergies: _allergiesController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          healthIssues: _healthIssuesController.text
              .split(',')
              .map((e) => e.trim())
              .toList(),
          minAge: int.parse(_minAgeController.text),
          maxAge: int.parse(_maxAgeController.text),
          uploadedBy: FirebaseAuth.instance.currentUser!.email!,
        );

        final docRef = await FirebaseFirestore.instance
            .collection('foods')
            .add(foodItem.toMap());
        // final updatedFoodItem = foodItem.copyWith();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Food Item'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
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
                            child: Text("select image")),
                        TextFormField(
                          controller: _proteinController,
                          decoration:
                              const InputDecoration(labelText: 'Protein'),
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
                              labelText:
                                  'Health Issues (separate with commas)'),
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
                      ]))),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _uploadFoodItem();
        },
        child: const Icon(Icons.upload),
      ),
    );
  }
}
