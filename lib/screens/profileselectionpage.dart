import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileSelectionPage extends StatelessWidget {
  final List profiles = ['Profile A', 'Profile B', 'Profile C'];
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
                        Get.toNamed('/offlinemainpage');
                      },
                      child: Card(
                        child: ListTile(
                          title: Text(profiles[i]),
                        ),
                      ),
                    ),
                  );
                })),
      ),
    );
  }
}
