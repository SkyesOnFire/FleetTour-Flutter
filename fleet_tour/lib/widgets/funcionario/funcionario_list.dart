import 'package:flutter/material.dart';
import 'package:fleet_tour/models/funcionario.dart'; // Update with your model
import 'funcionario_card.dart'; // Import the FuncionarioCard widget

class FuncionariosList extends StatelessWidget {
  const FuncionariosList(
      {super.key,
      required this.funcionarios,
      required this.onDelete,
      required this.onEdit});

  final void Function(Funcionario funcionario) onDelete;
  final void Function(Funcionario funcionario) onEdit;
  final List<Funcionario> funcionarios;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: funcionarios.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEdit(funcionarios[index]);
        },
        child: Dismissible(
          key: ValueKey(funcionarios[index].idFuncionario),
          background: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onDismissed: (direction) {
            onDelete(funcionarios[index]);
          },
          child: FuncionarioCard(funcionario: funcionarios[index]),
        ),
      ),
    );
  }
}
