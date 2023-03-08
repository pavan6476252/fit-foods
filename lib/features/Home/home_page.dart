// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';
import '../chat/chat_page.dart';
import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  VoidCallback signOut;
  HomePage({
    Key? key,
    required this.signOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Medirec"),
        actions: [
          IconButton(
              onPressed: () {
                AdaptiveTheme.of(context).toggleThemeMode();
              },
              icon: const Icon(Icons.sunny)),
          IconButton(
            icon: const Icon(Icons.person_2_outlined),
            onPressed: () {
              // signOut();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfilePage(signOut: signOut),
                  ));
            },
          )
        ],
      ),
      body: ListView(
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.search),
              title: Text('Search Tablets/Medicines'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.scanner),
              title: Text('Scan Report'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.local_pharmacy),
              title: Text('Local Medical Stores'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.folder),
              title: Text('My Health Records/Files'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.lightbulb),
              title: Text('Get Suggestions'),
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(
      //     onPressed: () {
      //       Navigator.push(
      //           context,
      //           MaterialPageRoute(
      //             builder: (_) => const ChatPage(),
      //           ));
      //     },
      //     child: const Icon(Icons.chat))

      floatingActionButtonLocation: ExpandableFab.location,
      floatingActionButton: ExpandableFab(
        expandedFabSize: ExpandableFabSize.regular,

type: ExpandableFabType.up,
distance: 80,
        children: [
          FloatingActionButton.small(
            child: const Icon(Icons.chat),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChatPage(),
                  ));
            },
          ),
          FloatingActionButton.small(
            child: const Icon(Icons.scanner_sharp),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
