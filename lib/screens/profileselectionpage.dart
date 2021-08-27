import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileSelectionPage extends StatelessWidget {
  final List profiles = ['Profile A', 'Profile B', 'Profile C'];
  final GetStorage box = new GetStorage();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Select Profile'),
          backgroundColor: Theme.of(context).backgroundColor,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3,
            ),
            itemCount: profiles.length,
            itemBuilder: (context, i) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                  onTap: () {
                    box.write(
                      'profileName',
                      profiles[i],
                    );
                    Get.toNamed('/offlinemainpage');
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(profiles[i]),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        drawer: Container(
          width: 100,
          height: 65,
          child: Drawer(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    box.remove('userName');
                    Get.offAndToNamed('/homepage');
                  },
                  child: Card(
                    borderOnForeground: true,
                    color: Theme.of(context).backgroundColor,
                    child: ListTile(
                      title: Text(
                        'Log out',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
