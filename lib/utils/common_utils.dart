import 'package:flutter/material.dart';

class CommonUtils {
  static void closeKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
