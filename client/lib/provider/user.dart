import 'package:flutter/material.dart';

class UserWrapper with ChangeNotifier {
  int credits = 0;

  UserWrapper();
  int get userCredit => credits;
  updateCredits(int val) {
    credits = val;
    notifyListeners();
  }
}
