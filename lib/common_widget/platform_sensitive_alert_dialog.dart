import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:friendss_messenger/common_widget/platform_sensitive_widget.dart';

class PlatformSensitiveAlertDialog extends PlatformSensitiveWidget {
  final String title;
  final String content;
  final String homeButtonText;
  final String cancelButtonText;

  PlatformSensitiveAlertDialog(
      {required this.title,
        required this.content,
        required this.homeButtonText,
        required this.cancelButtonText});

  Future<bool?> show(BuildContext context) async {
    return Platform.isIOS
        ? await showCupertinoDialog<bool>(
        context: context, builder: (context) => this)
        : await showDialog<bool>(
        context: context,
        builder: (context) => this,
        //kullanıcı dışarıya basarak kapatamaz
        barrierDismissible: false);
  }

  @override
  Widget buildAndroidWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  @override
  Widget buildIOSWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: _dialogButonlariniAyarla(context),
    );
  }

  List<Widget> _dialogButonlariniAyarla(BuildContext context) {
    final allButton = <Widget>[];

    if (Platform.isIOS) {
      if (cancelButtonText != null) {
        allButton.add(
          CupertinoDialogAction(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButton.add(
        CupertinoDialogAction(
          child: Text(homeButtonText),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    } else {
      if (cancelButtonText != null) {
        allButton.add(
          FlatButton(
            child: Text(cancelButtonText),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        );
      }

      allButton.add(
        FlatButton(
          child: Text("Tamam"),
          onPressed: () {
            Navigator.of(context).pop(true);
          },
        ),
      );
    }

    return allButton;
  }
}
