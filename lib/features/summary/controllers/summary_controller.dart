import 'package:get/get.dart';

class SummaryController extends GetxController{

  static SummaryController get instance => Get.find();

  final carouselCurrentIndex = 0.obs;
  
  void updatePageIndicator(index) {
    carouselCurrentIndex.value = index;
  }

}