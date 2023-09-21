import 'package:flutter/foundation.dart';

class DropdownState extends ChangeNotifier {
  String? _selectedItem;

  String? get selectedItem => _selectedItem;

  void selectItem(String? value) {
    _selectedItem = value;
    notifyListeners();
  }
}
