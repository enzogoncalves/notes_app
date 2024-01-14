import 'package:flutter/material.dart';
import 'package:notes_app/models/color.dart';

AppColors appColors = AppColors();

Future<void> dialogBuilder({required BuildContext context, required Function() dontExit, required Function() exitWithoutSave}) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Exit without saving ?', style: TextStyle(color: appColors.mainTextColor)),
        actions: [
          TextButton(
            onPressed: dontExit,
            style: TextButton.styleFrom(foregroundColor: appColors.foregroundBlueColor),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: exitWithoutSave,
            style: TextButton.styleFrom(foregroundColor: appColors.mainRedColor),
            child: const Text('Yes'),
          ),
        ],
      );
    },
  );
}
