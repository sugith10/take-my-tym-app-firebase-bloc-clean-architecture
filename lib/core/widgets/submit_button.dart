import 'dart:io';

import 'package:flutter/material.dart';
import 'package:take_my_tym/core/utils/app_padding.dart';
import 'package:take_my_tym/core/utils/app_radius.dart';

class SubmitButton extends StatelessWidget {
  final VoidCallback callback;
  final String text;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Widget? child;

  const SubmitButton({
    required this.callback,
    required this.text,
    this.child,
    this.backgroundColor,
    this.foregroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(MyAppPadding.homePadding),
      child: ElevatedButton(
        onPressed: () {
          callback();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          shape: Platform.isIOS
              ? RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(MyAppRadius.borderRound),
                )
              : null,
        ),
        child: child ?? Text(text),
      ),
    );
  }
}
