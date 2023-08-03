import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitfood_medirec/app/utils/loading_screen.dart';
import 'package:fitfood_medirec/app/views/favorites_widet.dart';
import 'package:fitfood_medirec/app/views/food_categories_page.dart';
import 'package:fitfood_medirec/app/views/recomendations_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../features/chat/chat_page.dart';
import '../../theme_provider.dart';
import '../utils/custom_drawer.dart';
import '../utils/search_bar.dart';
import 'get_user_info.dart';
import 'safe_food_items.dart';
import '../views/seach_page.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    check();
    super.initState();
  }

  void check() async {
    if (!await checkIfUserExist()) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => GetUserInfo(),
          ));
    } else {
      isLoading = false;
      setState(() {});
    }
  }

  bool isLoading = true;
  final bool _showTitle = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const LoadingScreen()
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.message_outlined),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ChatPage(),
                    ));
              },
            ),
            appBar: AppBar(
              title: const Text("Fit Food"),
              centerTitle: true,
              actions: [
                Consumer(
                  builder: (context, watch, child) {
                    final theme = watch.watch(themeProvider);
                    return theme.getTheme()!.brightness == Brightness.dark
                        ? IconButton(
                            icon: const Icon(Icons.sunny),
                            onPressed: () => theme.toggleTheme(),
                          )
                        : IconButton(
                            icon: const Icon(Icons.dark_mode_outlined),
                            onPressed: () => theme.toggleTheme(),
                          );
                  },
                ),
              ],
            ),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
                child: Column(
              children: [
                const SearchBarWidget(),
                const RecomendationOfDay(),
                const FoodCategoryPage(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SelectYourChoice(title: 'Recomended'),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: FavoriteFoodsWidget(),
                ),
              ],
            )),
            // bottomNavigationBar: CustomBottomNavigationBar(),
          );
  }
}

class SelectYourChoice extends StatelessWidget {
  String? title;

  SelectYourChoice({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
            child: Text(title ?? "SELECT YOUR CHOICE",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ))),
        SizedBox(height: 200.0, child: SafeFoodsScreen()),
      ],
    );
  }
}
