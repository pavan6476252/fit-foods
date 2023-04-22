import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fitfood_medirec/app/utils/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/chat/chat_page.dart';
import '../../theme_provider.dart';
import '../utils/custom_drawer.dart';
import '../utils/search_bar.dart';
import 'get_user_info.dart';
import 'safe_food_items.dart';

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
  bool _showTitle = false;

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
                    return theme.getTheme().brightness == Brightness.dark
                        ? IconButton(icon:Icon(Icons.sunny),onPressed: () => theme.toggleTheme(),)
                        : IconButton(icon:Icon(Icons.dark_mode_outlined),onPressed: () => theme.toggleTheme(),);
                  },
                ),
              ],
            ),
            drawer: CustomDrawer(),
            body: SingleChildScrollView(
                child: Column(
              children: [
                SearchBar(),
                const RecomendationOfDay(),
                // SelectYourChoice(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SelectYourChoice(title: 'Recomended'),
                ),
              ],
            )),
            // bottomNavigationBar: CustomBottomNavigationBar(),
          );
  }
}

class RecomendationOfDay extends StatefulWidget {
  const RecomendationOfDay({super.key});

  @override
  State<RecomendationOfDay> createState() => _RecomendationOfDayState();
}

class _RecomendationOfDayState extends State<RecomendationOfDay> {
  PageController _controller = PageController();
  List<String> _images = [
    "https://images.unsplash.com/photo-1490645935967-10de6ba17061?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1153&q=80",
    "https://images.unsplash.com/photo-1620706857370-e1b9770e8bb1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTF8fGRpZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60",
    "https://images.unsplash.com/photo-1532054241088-402b4150db33?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTh8fGRpZXR8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60"
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_controller.page!.round() == _images.length - 1) {
        _controller.animateToPage(
          0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 250,
      child: PageView.builder(
        controller: _controller,
        itemCount: _images.length,
        itemBuilder: (BuildContext context, int index) {
          return Align(
            alignment: Alignment.center,
            child: Card(
              elevation: 1.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: double.maxFinite,
                height: 300.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  // image: DecorationImage(
                  //   image:,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: CachedNetworkImage(
                    height: double.maxFinite,
                    imageUrl: _images[index],
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SelectYourChoice extends StatelessWidget {
  String? title;

  final List<String> _images = [
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
    'https://picsum.photos/200/300',
  ];

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
              ))
        ),
        SizedBox(height: 200.0, child: SafeFoodsScreen()),
      ],
    );
  }
}
