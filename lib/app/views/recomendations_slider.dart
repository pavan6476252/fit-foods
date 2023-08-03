
import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RecomendationOfDay extends StatefulWidget {
  const RecomendationOfDay({super.key});

  @override
  State<RecomendationOfDay> createState() => _RecomendationOfDayState();
}

class _RecomendationOfDayState extends State<RecomendationOfDay> {
  final PageController _controller = PageController();
  final List<String> _images = [
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

  List<String> urls = [
    'https://www.food52.com/',
    'https://www.allrecipes.com/',
    'https://www.bonappetit.com/',
    'https://www.simplyrecipes.com/'
        'https://www.thekitchn.com/'
        'https://minimalistbaker.com/'
  ];
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
            child: GestureDetector(
              onTap: () async {
                if (await canLaunchUrl(Uri.parse(urls[index]))) {
                  await launchUrl(Uri.parse(urls[index]));
                } else {}
              },
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
            ),
          );
        },
      ),
    );
  }
}
