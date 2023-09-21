import 'package:flutter/material.dart';
import 'package:fleet_tour/models/funcionario.dart';  // Update with your model
import 'funcionario_item.dart';  // Import the FuncionarioItem widget

class FuncionariosList extends StatelessWidget {
  final List<Funcionario> funcionarios;
  final Function(Funcionario funcionario) onDelete;
  final Function(Funcionario funcionario) onEdit;

  FuncionariosList({
    required this.funcionarios,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: funcionarios.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () => onEdit(funcionarios[index]),
        child: Dismissible(
          key: ValueKey(funcionarios[index].id),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onDismissed: (direction) {
            onDelete(funcionarios[index]);
          },
          child: FuncionarioItem(funcionario: funcionarios[index]),
        ),
      ),
    );
  }
}
