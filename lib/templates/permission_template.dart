import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: AlertDialog(
        title: Text('Information on Video Download'.tr),
        content: Text('InfoContent'.tr),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.check),
            label: Text('Ok'),
          ),
        ],
      ),
    );
  }
}
