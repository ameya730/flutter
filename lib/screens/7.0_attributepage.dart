import 'package:flutter/material.dart';
import 'package:gshala/const.dart';
import 'package:get/get.dart';

class ImageAttributesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List _images = [
      'assets/downloading.gif',
      'assets/offlineimage.gif',
      'assets/offlineimageone.gif',
      'assets/nointernet.gif',
    ];
    final List _imageSource = [
      'https://lottiefiles.com/9499-icons-package-download',
      'https://lottiefiles.com/13262-no-internet-connection',
      'https://lottiefiles.com/33943-video-upload-in-a-mobile',
      'https://lottiefiles.com/54633-no-internet-access-animation',
    ];
    final List _imageAuthor = [
      'Tam Doan',
      'Akhilesh Singh',
      'Sudhakar Subramanian',
      'Owais Uddin'
    ];

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Attributions'.tr),
          backgroundColor: backGroundColor,
          shadowColor: Colors.transparent,
        ),
        backgroundColor: backGroundColor,
        body: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(32.0),
                child: Text(
                  'This section mentions the source and artist names for the images used in this app'
                      .tr,
                  style: TextStyle(
                    color: normalWhiteText,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: _images.length,
                itemBuilder: (BuildContext context, int i) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: AssetImage(_images[i]),
                        ),
                        title: Text(
                          _imageSource[i],
                          style: TextStyle(
                            fontSize: 7,
                            color: normalDarkText,
                          ),
                        ),
                        subtitle: Text(
                          _imageAuthor[i],
                          style: TextStyle(
                            fontSize: 10,
                            color: normalDarkText,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
