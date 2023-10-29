import 'package:flutter/foundation.dart';

class DropdownState extends ChangeNotifier {
  String? _selectedItem;

  DropdownState({String? defaultValue}) {
    _selectedItem = defaultValue;
    notifyListeners();
  }

  String? get selectedItem => _selectedItem;

  void selectItem(String? value) {
    _selectedItem = value;
    notifyListeners();
  }
}
