import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fleet_tour/providers/dropdown_state.dart';

class DropdownMenuButton extends StatefulWidget {
  const DropdownMenuButton({super.key});

  @override
  State<DropdownMenuButton> createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends State<DropdownMenuButton> {
  List<String> dropdownItems = [
    'Gerenciamento de Frota',
    'Gerenciamento de Passageiros',
    'Gerenciamento de Funcionarios',
    'Informações da Empresa'
  ];

  final DropdownState dropdownState =
      Get.find(); // Ensure DropdownState has an observable variable

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: const Color.fromARGB(255, 0, 167, 213),
            style: BorderStyle.solid,
            width: 0.80,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: dropdownState.selectedItem, // Use .value for Rx types
            icon: const Icon(Icons.arrow_downward),
            focusColor: Color.fromARGB(255, 255, 255, 255),
            elevation: 16,
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 167, 213),
            ),
            underline: Container(
              height: 2,
            ),
            items: dropdownItems.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              dropdownState.selectItem(
                  newValue); // This should update the observable variable

              if (newValue == "Gerenciamento de Frota") {
                Get.offNamed('/veiculos'); // Usando Get.to() para navegação
              } else if (newValue == "Gerenciamento de Passageiros") {
                Get.offNamed('/passageiros');
              } else if (newValue == "Gerenciamento de Funcionarios") {
                Get.offNamed('/funcionarios');
              } else if (newValue == "Informações da Empresa") {
                Get.offNamed('/empresas');
              }
            },
          ), // Your DropdownButton widget
        ),
      );
    });
  }
}
