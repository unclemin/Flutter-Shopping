import 'package:flutter/material.dart';


class Counter with ChangeNotifier {
  int value = 5 ;

  increment(){
    value++;
    notifyListeners();
  }
}

