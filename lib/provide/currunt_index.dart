import 'package:flutter/material.dart';

class CurruntProvide with ChangeNotifier{
  int currentIndex=0;
  changeIndex(index){
    currentIndex = index;
    notifyListeners();
  }
}