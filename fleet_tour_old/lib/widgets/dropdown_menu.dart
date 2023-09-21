import 'package:flutter/material.dart';
import 'package:fleet_tour/widgets/onibus/expenses.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros.dart';

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
  ];

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
        items: dropdownItems.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          if (value == "Frota") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Expenses(),
              ),
            );
          } else if (value == "Passageiros") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Passageiros(),
              ),
            );
          } else if (value == "Funcionarios") {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Expenses(),
              ),
            );
          }
        });
  }
}
