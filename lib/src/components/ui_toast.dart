import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mmc_test/main.dart';

class UIToast {
  static showToast(BuildContext constext, String message,
      {bool makeToastPositionTop = false, bool extendDurationTime = false}) {
    var fToast = FToast();
    fToast.init(navigatorKey.currentState!.context);
    Widget toast = Padding(
      padding: EdgeInsets.only(
        top: 12,
        left: 24,
        right: 24,
        bottom: makeToastPositionTop ? 12 : 34,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Colors.blueAccent,
        ),
        child: Text(
          message,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: makeToastPositionTop ? ToastGravity.TOP : ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: extendDurationTime ? 5 : 3),
    );
  }
}
