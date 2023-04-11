import 'dart:async';

import 'package:flutter/material.dart';
import 'package:medirec/app/utils/custom_drawer.dart';
import 'package:medirec/app/utils/search_bar.dart';
import 'package:medirec/app/views/get_user_info.dart';

import '../../features/chat/chat_page.dart';

class HomePage extends StatelessWidget {
   HomePage({super.key});

    bool _showTitle = false;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      floatingActionButton: FloatingActionButton(  onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>  GetUserInfo(),
                  ));
            },),
      appBar: AppBar(
        title: Text("My Health "),
        centerTitle: true,
      ),
      drawer: CustomDrawer(),
      body:
      SingleChildScrollView(
          child: Column(
        children: [
          SearchBar(),
          RecomendationOfDay(),
          SelectYourChoice(),
          SelectYourChoice(title: 'Recomended'),
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
    'https://picsum.photos/300/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      if (_controller.page!.round() == _images.length - 1) {
        _controller.animateToPage(
          0,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        _controller.nextPage(
          duration: Duration(milliseconds: 500),
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
                  image: DecorationImage(
                    image: NetworkImage(_images[index]),
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
    'https://picsum.photos/200/300?random=1',
    'https://picsum.photos/200/300?random=2',
    'https://picsum.photos/200/300?random=3',
    'https://picsum.photos/200/300?random=4',
    'https://picsum.photos/200/300?random=5',
    'https://picsum.photos/200/300?random=6',
  ];

  SelectYourChoice({this.title, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(title ?? "SELECT YOUR CHOICE",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.grey)),
        ),
        SizedBox(
          height: 200.0,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _images.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    width: 150.0,
                    height: 200.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      image: DecorationImage(
                        image: NetworkImage(_images[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
