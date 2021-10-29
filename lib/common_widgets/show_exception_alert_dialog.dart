



import 'package:flutter/material.dart';
import 'package:radix_freshers/common_widgets/show_alert_dialog.dart';


Future<void> showExceptionAlertDialog  (
BuildContext context,{
required String title,
 required Exception exception,
}
)=>showAlertDialog(context,defalutActionText: 'OK', content: exception.toString(), title: title
);

