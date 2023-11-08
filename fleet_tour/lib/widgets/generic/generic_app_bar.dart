import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final VoidCallback loadItems;
  final VoidCallback addItem;

  const CustomAppBar(
      {super.key, required this.loadItems, required this.addItem});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        const DropdownMenuButton(),
        IconButton(onPressed: loadItems, icon: const Icon(Icons.refresh)),
        IconButton(onPressed: addItem, icon: const Icon(Icons.add)),
      ],
    );
  }
}
