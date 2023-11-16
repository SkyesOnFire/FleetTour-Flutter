import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/widgets/funcionario/funcionario_card.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class FuncionarioListPicker extends StatefulWidget {
  const FuncionarioListPicker(
      {super.key,
      required this.funcionarios,
      required this.selectedFuncionarios});

  final List<Funcionario> funcionarios;
  final List<Funcionario> selectedFuncionarios;

  @override
  State<FuncionarioListPicker> createState() => _FuncionarioListPickerState();
}

class _FuncionarioListPickerState extends State<FuncionarioListPicker> {
  List<Funcionario> filteredFuncionarios = [];
  TextEditingController searchController = TextEditingController();
  var storage = GetStorage();

  late List<Funcionario> _localSelectedFuncionarios;

  @override
  void initState() {
    super.initState();
    filteredFuncionarios = widget.funcionarios;
    _localSelectedFuncionarios = List.from(widget.selectedFuncionarios);
    storage.write('selectedFuncionarios', _localSelectedFuncionarios);
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredFuncionarios = widget.funcionarios;
      });
      return;
    }

    List<Funcionario> dummyListData = [];
    widget.funcionarios.forEach((item) {
      if (item.nome!.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });

    setState(() {
      filteredFuncionarios = dummyListData;
    });
  }

  void _toggleFuncionario(Funcionario funcionario) {
    setState(() {
      if (_localSelectedFuncionarios.contains(funcionario)) {
        _localSelectedFuncionarios.remove(funcionario);
        storage.write('selectedFuncionarios', _localSelectedFuncionarios);
      } else {
        _localSelectedFuncionarios.add(funcionario);
        storage.write('selectedFuncionarios', _localSelectedFuncionarios);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            style: const TextStyle(color: Colors.black),
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: searchController,
            decoration: const InputDecoration(
              labelText: "Pesquisar",
              labelStyle: TextStyle(color: Colors.black),
              hintText: "Digite para pesquisar funcionários",
              hintStyle: TextStyle(color: Colors.black),
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFuncionarios.length,
            itemBuilder: (context, index) {
              final funcionario = filteredFuncionarios[index];
              final isSelected = _localSelectedFuncionarios
                  .map((f) => f.idFuncionario == funcionario.idFuncionario)
                  .toList()
                  .contains(true);
              return GestureDetector(
                onTap: () => _toggleFuncionario(_localSelectedFuncionarios.firstWhere((f) => f.idFuncionario == funcionario.idFuncionario, orElse: () => funcionario)),
                child: FuncionarioCard(
                    funcionario: funcionario, isSelected: isSelected),
              );
            },
          ),
        ),
      ],
    );
  }
}
