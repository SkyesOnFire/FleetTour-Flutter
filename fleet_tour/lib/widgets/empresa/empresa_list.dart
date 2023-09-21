import 'package:flutter/material.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'empresa_item.dart';

class EmpresasList extends StatelessWidget {
  final List<Empresa> empresaList;
  final void Function(Empresa empresa) onRemoveEmpresa;
  final void Function(Empresa empresa) onEditEmpresa;

  const EmpresasList({
    Key? key,
    required this.empresaList,
    required this.onRemoveEmpresa,
    required this.onEditEmpresa,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: empresaList.length,
      itemBuilder: (ctx, index) => GestureDetector(
        onTap: () {
          onEditEmpresa(empresaList[index]);
        },
        child: Dismissible(
          key: ValueKey(empresaList[index]),
          background: Container(
            color: Theme.of(context).errorColor,
            margin: const EdgeInsets.symmetric(horizontal: 8),
          ),
          onDismissed: (direction) {
            onRemoveEmpresa(empresaList[index]);
          },
          child: EmpresaItem(empresaList[index]),
        ),
      ),
    );
  }
}
