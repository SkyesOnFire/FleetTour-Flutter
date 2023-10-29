import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fleet_tour/widgets/empresa/empresas.dart';
import 'package:fleet_tour/widgets/funcionario/funcionarios.dart';
import 'package:fleet_tour/widgets/veiculo/veiculo.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros.dart';
import 'package:fleet_tour/providers/dropdown_state.dart';

class DropdownMenuButton extends StatefulWidget {
  const DropdownMenuButton({super.key});

  @override
  State<DropdownMenuButton> createState() => _DropdownMenuButtonState();
}

class _DropdownMenuButtonState extends State<DropdownMenuButton> {
  List<String> dropdownItems = [
    'Frota',
    'Passageiros',
    'Funcionarios',
    'Empresa'
  ];

  final DropdownState dropdownState = Get.find(); // Obtendo o controlador

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return DropdownButton<String>(
          value: dropdownState.selectedItem.value,
          items: dropdownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            dropdownState.selectItem(newValue); // Atualizar o estado

            if (newValue == "Frota") {
              Get.to(() => const Veiculos()); // Usando Get.to() para navegação
            } else if (newValue == "Passageiros") {
              Get.to(() => const Passageiros());
            } else if (newValue == "Funcionarios") {
              Get.to(() => const Funcionarios());
            } else if (newValue == "Empresa") {
              Get.to(() => const Empresas());
            }
          },
        );
      },
    );
  }
}
