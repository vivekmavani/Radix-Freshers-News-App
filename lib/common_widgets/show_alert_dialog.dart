import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<dynamic> showAlertDialog(BuildContext context, {
  required String title,
  required String content,
  String? cancleActiontext,
  required String defalutActionText,
}) async {
  if (!Platform.isIOS) {
   return showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              if(cancleActiontext != null)
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text(cancleActiontext),
                ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: Text(defalutActionText),
              ),
            ],
          ),
    );
  }
  return showCupertinoDialog(
    context: context,
    builder: (context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        if(cancleActiontext != null)
          CupertinoDialogAction(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(cancleActiontext),
          ),
        CupertinoDialogAction(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(defalutActionText),
        ),
      ],
    ),
  );
}