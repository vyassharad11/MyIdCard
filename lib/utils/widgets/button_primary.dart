import 'package:flutter/material.dart';

import '../colors/colors.dart';

class Utils {
  primaryButton({String? text, Color? colors, required Function onClick}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          onClick.call();
          debugPrint("onlick----");
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: colors ?? ColoursUtils.primaryColor.withOpacity(0.8),
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Text(
          text ?? "",
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
