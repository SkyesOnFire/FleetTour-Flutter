import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fleet_tour/widgets/empresa/empresas.dart';
import 'package:fleet_tour/widgets/funcionario/funcionarios.dart';
import 'package:fleet_tour/widgets/onibus/onibus.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros.dart';
import 'package:fleet_tour/providers/dropdown_state.dart'; // Importe o arquivo onde você criou o DropdownState

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

  @override
  Widget build(BuildContext context) {
    return Consumer<DropdownState>(
      builder: (context, dropdownState, child) {
        return DropdownButton<String>(
          value: dropdownState.selectedItem,
          items: dropdownItems.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            dropdownState.selectItem(newValue); // Atualizar o estado

            if (newValue == "Frota") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Expenses(),
                ),
              );
            } else if (newValue == "Passageiros") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Passageiros(),
                ),
              );
            } else if (newValue == "Funcionarios") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Funcionarios(),
                ),
              );
            } else if (newValue == "Empresa") {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const Empresas(),
                ),
              );
            }
          },
        );
      },
    );
  }
}
