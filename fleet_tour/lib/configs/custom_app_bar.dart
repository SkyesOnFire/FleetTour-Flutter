import 'package:fleet_tour/widgets/dropdown_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

AppBar customAppBar({
  required VoidCallback loadItems,
  required VoidCallback addItem,
}) {
  // Assuming 'LoginPage' is the route name of your login page
  bool isNextPageLogin = Get.routing.current == '/veiculos' 
  || Get.routing.current == '/passageiros'
  || Get.routing.current == '/funcionarios'
  || Get.routing.current == '/empresas'
  || Get.routing.current == '/contratantes'
  || Get.routing.current == '/viagens';

  return AppBar(
    leading: isNextPageLogin
        ? IconButton(
            icon: const Icon(Icons.logout), // Logout icon
            onPressed: () {
              Get.offAllNamed('/login');
            },
          )
        : IconButton(
            icon: const Icon(Icons.arrow_back), // Default back icon
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
          const DropdownMenuButton(),
          IconButton(onPressed: loadItems, icon: const Icon(Icons.refresh)),
          IconButton(onPressed: addItem, icon: const Icon(Icons.add))
        ],
    // The rest of your AppBar properties
  );
}
