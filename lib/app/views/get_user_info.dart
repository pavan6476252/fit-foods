import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart'; 

import 'home_page.dart';

class GetUserInfo extends StatefulWidget {
  @override
  _GetUserInfoState createState() => _GetUserInfoState();
}

class _GetUserInfoState extends State<GetUserInfo> {
  int _currentStep = 0;
  int? _age;
  List<String> _healthIssues = [];

  List<String> _selectedIssueList = [];

  final List<String> _issueList = [
    'Diabetes',
    'High Blood Pressure',
    'Asthma',
    'Arthritis',
    'Cancer',
    'Other',
  ];

  final List<String> _allergyList = [
    'Peanuts',
    'Shellfish',
    'Eggs',
    'Milk',
    'Soy',
    'Wheat',
    'Fish',
    'Other',
  ];

  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    checkIfUserExist();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Health Details'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue:
            _currentStep < 2 ? () => setState(() => _currentStep += 1) : null,
        onStepCancel:
            _currentStep > 0 ? () => setState(() => _currentStep -= 1) : null,
        steps: [
          Step(
            title: Text('Enter Age'),
            isActive: _currentStep >= 0,
            content: Form(
              key: _formKey,
              child: TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
                onSaved: (value) {
                  _age = int.parse(value!);
                },
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                ),
              ),
            ),
          ),
          Step(
            title: Text('Select allergies'),
            isActive: _currentStep >= 1,
            content: Column(
              children: [
                Wrap(
                  spacing: 8.0,
                  children: _allergyList.map((allergy) {
                    return ChoiceChip(
                      label: Text(allergy),
                      selected: _healthIssues.contains(allergy),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _healthIssues.add(allergy);
                          } else {
                            _healthIssues.remove(allergy);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Step(
            title: Text('Select Issue'),
            isActive: _currentStep >= 2,
            content: Column(
              children: [
                Wrap(
                  spacing: 8.0,
                  children: _issueList.map((allergy) {
                    return ChoiceChip(
                      label: Text(allergy),
                      selected: _selectedIssueList.contains(allergy),
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedIssueList.add(allergy);
                          } else {
                            _selectedIssueList.remove(allergy);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _currentStep == 0
                  ? SizedBox.shrink()
                  : ElevatedButton(
                      onPressed: () => setState(() => _currentStep -= 1),
                      child: Text('Back'),
                    ),
              ElevatedButton(
                  child: Text(_currentStep == 2 ? 'Submit' : 'Next'),
                  onPressed: () {
                    _currentStep == 2
                        ? _submit(
                            _age ?? 0, _selectedIssueList, _healthIssues)
                        : setState(() => _currentStep += 1);
                  }),
            ],
          ),
        ),
      ),
    );
  }

  _submit(int age, List<String> allergies,
      List<String> healthIssues) async {
    if (_formKey.currentState!.validate()) {
      await storeUserData(age, allergies, healthIssues);
      // Navigate to home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(),
        ),
      );
    }
  }
}

Future<bool> checkIfUserExist() async {
  bool exist = false;

  User? user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final documentRef =
        FirebaseFirestore.instance.collection('userData').doc(user.email);
    final snapshot = await documentRef.get();
    exist = snapshot.exists;
  }
  // print(exist);
  return exist;
}

Future<void> storeUserData(int age, List<String> allergies,
    List<String> healthIssues) async {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final User? user = auth.currentUser;

  if (user != null) {
    final CollectionReference userDataCollection =
        FirebaseFirestore.instance.collection('userData');
    final DocumentReference userDocRef = userDataCollection.doc(user.email);

    // Check if user already exists in the database
    final DocumentSnapshot userData = await userDocRef.get();
    if (userData.exists) {
      // User already exists, overwrite the existing data
      await userDocRef.set({
        'age': age,
        'allergies': allergies,
        'healthIssues': healthIssues
      });
    } else {
      // User does not exist, create a new record
      await userDocRef.set({
        'email': user.email,
        'age': age,
        'allergies': allergies,
        'healthIssues': healthIssues
      });
    }
  } else {
    print('User is not logged in');
  }
}
