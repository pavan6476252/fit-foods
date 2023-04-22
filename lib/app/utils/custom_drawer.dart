import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/upload/food_upload.dart';
import '../controller/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../views/get_user_info.dart';

class CustomDrawer extends ConsumerWidget {
  CustomDrawer({super.key});

  final TextEditingController _textFieldController = TextEditingController();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    User? user = ref.read(authStateProvider).value;
    final _auth = ref.watch(authenticationProvider);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            
            accountName: Text(user!.displayName ?? "Guest"),
            accountEmail: Text(user.email ?? ""),
            currentAccountPicture: ClipRRect(
              borderRadius: BorderRadius.circular(50),
             child:  CachedNetworkImage(
                          height: double.maxFinite,
                          imageUrl: user.photoURL ?? "",
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(),
                          fit: BoxFit.cover,
                        ),
            ),
            otherAccountsPictures: <Widget>[
              // Add additional profile pictures here
            ],
          ),
          ListTile(
            leading: const Icon(Icons.healing_outlined),
            title: const Text('Health Details'),
            onTap: () async => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GetUserInfo(),
                )),
          ),
          ListTile(
            leading: const Icon(Icons.upload_file_outlined),
            title: const Text('Upload food data'),
            onTap: () => _displayTextInputDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sign Out'),
            onTap: () async => _auth.signOut(),
          ),
        ],
      ),
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authentication'),
          content: TextField(
            controller: _textFieldController,
            decoration: const InputDecoration(hintText: "Enter Admin password"),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            ElevatedButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context);
                if (_textFieldController.text == '1234567890') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const UploadFoodScreen(),
                      ));
                }
              },
            ),
          ],
        );
      },
    );
  }
}
