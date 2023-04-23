import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = ChangeNotifierProvider<ThemeProvider>((ref) {
  return ThemeProvider();
});

class ThemeProvider extends ChangeNotifier {
  final lightThemeData  = ThemeData.light(useMaterial3: true);
  final darkThemeData  = ThemeData.dark(useMaterial3: true);
 ThemeData? _themeData ;

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData? getTheme() => _themeData;

  void setTheme(ThemeData themeData) async {
    _themeData = themeData;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData!.brightness == Brightness.dark);
    notifyListeners();
  }

  void toggleTheme() async {
    if (_themeData!.brightness == Brightness.dark) {
      _themeData =lightThemeData;
    } else {
      _themeData = darkThemeData;
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _themeData!.brightness == Brightness.dark);
    notifyListeners();
  }

  void _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDarkMode = prefs.getBool('isDarkMode') ?? true;
    _themeData = isDarkMode ? darkThemeData : lightThemeData;
    notifyListeners();
  }
}
