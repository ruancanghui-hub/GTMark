import 'package:get/get.dart';

class MainController extends GetxController {
  final currentIndex = 0.obs;

  void switchTab(int index) {
    if (index < 0 || index > 3) return;
    currentIndex.value = index;
  }
}
