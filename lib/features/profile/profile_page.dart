import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:medirec/features/remainders/remainder_page.dart';

class ProfilePage extends StatefulWidget {
  VoidCallback signOut;
  ProfilePage({required this.signOut});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isEditing = false;
  bool _isLoading = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  User? _user;
  FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    super.initState();

    _user = FirebaseAuth.instance.currentUser;

    _fullNameController.text = _user!.displayName ?? "";
    _emailController.text = _user!.email ?? "";
    _mobileNumberController.text = _user!.phoneNumber ?? "";

    _db.collection('users').doc(_user!.uid).get().then((snapshot) {
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data()!;
        _fullNameController.text = data['fullName'];
        _emailController.text = data['email'];
        _mobileNumberController.text = data['mobileNumber'];
        _addressController.text = data['address'];
      }
    });
    // setState(() {
    //   _isLoading = false;
    // });
  }

  void _updateProfile() async {
    setState(() {
      _isLoading = true;
    });
    await _db.collection('users').doc(_user!.uid).set({
      'fullName': _fullNameController.text,
      'email': _emailController.text,
      'mobileNumber': _mobileNumberController.text,
      'address': _addressController.text,
    }, SetOptions(merge: true));

    _isLoading = false;
    _isEditing = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          actions: [
            !_isEditing
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        _isEditing = true;
                      });
                    },
                    icon: const Icon(Icons.edit),
                  )
                : Row(
                    children: [
                      // IconButton(
                      //   icon: const Icon(Icons.cancel_presentation),
                      //   onPressed: () {
                      //     setState(() {
                      //       _isEditing = false;
                      //     });
                      //   },
                      // ),
                      IconButton(
                        icon: const Icon(Icons.save),
                        onPressed: _updateProfile,
                      ),
                    ],
                  ),
          ],
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _isEditing
                  ? Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  NetworkImage(_user!.photoURL ?? ""),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              controller: _fullNameController,
                              decoration: const InputDecoration(
                                hintText: 'Full Name',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Email ID',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _mobileNumberController,
                              decoration: const InputDecoration(
                                hintText: 'Mobile Number',
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                hintText: 'Address',
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 3),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50.0,
                              backgroundImage:
                                  NetworkImage(_user!.photoURL ?? ""),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              _fullNameController.text,
                              style: const TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              _emailController.text,
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            _mobileNumberController.text == " "
                                ? Text(
                                    "mobile : ${_mobileNumberController.text}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                : SizedBox(),
                            const SizedBox(height: 8.0),
                            _addressController.text == " "
                                ? Text(
                                    "address : ${_addressController.text}",
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  )
                                : SizedBox()
                          ],
                        ),
                      ),
                    ),
              Divider(
                thickness: 0.4,
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.folder),
                  title: const Text('Essential Documents'),
                  onTap: () {
                    // Navigate to essential documents folder
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.local_hospital),
                  title: const Text('Medical Reports'),
                  onTap: () {
                    // Navigate to medical reports folder
                  },
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.add_alert),
                  title: const Text('Reminders'),
                  onTap: () {
                    // Navigate to reminders screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReminderPage(),
                        ));
                  },
                ),
              ),
              Divider(
                thickness: 0.4,
              ),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    widget.signOut();
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.logout_rounded,
                        size: 25,
                      ),
                      Text(
                        " Logout ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w300),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        )));
  }
}
