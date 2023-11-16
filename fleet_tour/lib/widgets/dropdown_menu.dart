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
    'Tela Inicial',
    'Gerenciamento de Frota',
    'Gerenciamento de Passageiros',
    'Gerenciamento de Funcionarios',
    'Gerenciamento de Contratantes',
    'Gerenciamento de Viagens',
    'Informações da Empresa'
  ];

  final DropdownState dropdownState =
      Get.find(); // Ensure DropdownState has an observable variable

  int findIndex() {
    return Get.currentRoute == '/veiculos'
        ? 1
        : Get.currentRoute == '/passageiros'
            ? 2
            : Get.currentRoute == '/funcionarios'
                ? 3
                : Get.currentRoute == '/contratantes'
                    ? 4
                    : Get.currentRoute == '/viagens'
                        ? 5
                        : Get.currentRoute == '/empresas'
                            ? 6
                            : 0;
  }

  @override
  void initState() {
    super.initState();
    dropdownState.selectItem(dropdownItems[findIndex()]); // Set initial value
  }

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
                Get.offAllNamed('/veiculos'); // Usando Get.to() para navegação
              } else if (newValue == "Tela Inicial") {
                Get.offAllNamed('/home');
              } else if (newValue == "Gerenciamento de Passageiros") {
                Get.offAllNamed('/passageiros');
              } else if (newValue == "Gerenciamento de Funcionarios") {
                Get.offAllNamed('/funcionarios');
              } else if (newValue == "Gerenciamento de Contratantes") {
                Get.offAllNamed('/contratantes');
              } else if (newValue == "Informações da Empresa") {
                Get.offAllNamed('/empresas');
              } else if (newValue == "Gerenciamento de Viagens") {
                Get.offAllNamed('/viagens');
              }
            },
          ), // Your DropdownButton widget
        ),
      );
    });
  }
}
