import 'package:get/get.dart';

class DateTimePickerController extends GetxController {
  var selectedDateTime = DateTime.now().obs;

  void updateSelectedDateTime(DateTime newDateTime) {
    selectedDateTime.value = newDateTime;
  }
}
