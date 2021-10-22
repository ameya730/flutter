import 'package:get/get.dart';

class PDFViewController extends GetxController {
  final pdfOpen = false.obs;
  final pdfPath = ''.obs;

  openPDF() {
    pdfOpen.value = true;
    update();
  }

  closePDF() {
    pdfOpen.value = false;
    update();
  }
}
