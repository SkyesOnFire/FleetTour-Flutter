import 'package:fleet_tour/providers/dropdown_state.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importe o GetX
import 'package:fleet_tour/widgets/login_screen.dart';

void main() {
  runApp(
    GetMaterialApp(  // Use GetMaterialApp ao invés de MaterialApp
      initialBinding: InitialBinding(),  // Inicialize o controlador aqui
      title: 'Fleet Tour',
      theme: ThemeData.light().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 255, 255, 255),
          brightness: Brightness.dark,
          surface: Color.fromARGB(255, 91, 91, 253),
        ),
        scaffoldBackgroundColor: Color.fromARGB(255, 78, 96, 101),
      ),
      home: const LoginScreen(),
    ),
  );
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Inicializando o controlador usando Get.put
    Get.put(DropdownState());
  }
}
