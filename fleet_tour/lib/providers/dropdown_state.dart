import 'package:get/get.dart';

class DropdownState extends GetxController {
  final Rx<String?> _selectedItem = Rx<String?>(null);

  DropdownState({String? defaultValue}) {
    _selectedItem.value = defaultValue;
  }

  String? get selectedItem => _selectedItem.value;

  set selectedItem(String? value) {
    _selectedItem.value = value;
  }

  void selectItem(String? value) {
    _selectedItem.value = value;
    update(); // This will update all GetBuilder<DropdownState> widgets
  }
}
