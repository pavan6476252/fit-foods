import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medirec/app/views/get_user_info.dart';

import '../controller/auth_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends ConsumerWidget {
  CustomDrawer();

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
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage(user.photoURL ?? ""),
            ),
            otherAccountsPictures: <Widget>[
              // Add additional profile pictures here
            ],
          ),
          ListTile(
            leading: Icon(Icons.healing_outlined),
            title: Text('Health Details'),
            onTap: () async => Navigator.push(context, MaterialPageRoute(builder: (context) => GetUserInfo(),)),
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sign Out'),
            onTap: () async => _auth.signOut(),
          ),
        ],
      ),
    );
  }
}
