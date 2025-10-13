import 'package:flutter/material.dart';

class BottomNavController extends ChangeNotifier {
  int _currentIndex = 0;
  
  int get currentIndex => _currentIndex;
  
  final List<String> _screenTitles = [
    'Home',
    'Explore',
    'Cart',
    'Categories',
    'Profile',
  ];
  
  String get currentTitle => _screenTitles[_currentIndex];
  
  void changeIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}