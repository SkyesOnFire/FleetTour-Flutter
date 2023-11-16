import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/widgets/contratante/contratante_card.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ContratanteListPicker extends StatefulWidget {
  const ContratanteListPicker(
      {super.key,
      required this.contratantes,
      required this.selectedContratantes});

  final List<Contratante> contratantes;
  final List<Contratante> selectedContratantes;

  @override
  State<ContratanteListPicker> createState() => _ContratanteListPickerState();
}

class _ContratanteListPickerState extends State<ContratanteListPicker> {
  List<Contratante> filteredContratantes = [];
  TextEditingController searchController = TextEditingController();
  var storage = GetStorage();

  late List<Contratante> _localSelectedContratantes;

  @override
  void initState() {
    super.initState();
    filteredContratantes = widget.contratantes;
    _localSelectedContratantes = List.from(widget.selectedContratantes);
    storage.write('selectedContratantes', _localSelectedContratantes);
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredContratantes = widget.contratantes;
      });
      return;
    }

    List<Contratante> dummyListData = [];
    widget.contratantes.forEach((item) {
      if (item.nome!.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });

    setState(() {
      filteredContratantes = dummyListData;
    });
  }

  void _toggleContratante(Contratante contratante) {
    setState(() {
      if (_localSelectedContratantes.contains(contratante)) {
        _localSelectedContratantes.remove(contratante);
        storage.write('selectedContratantes', _localSelectedContratantes);
      } else {
        if (_localSelectedContratantes.length == 1) {
          _localSelectedContratantes.removeAt(0);
        }
        _localSelectedContratantes.add(contratante);
        storage.write('selectedContratantes', _localSelectedContratantes);
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
              hintText: "Digite para pesquisar contratantes",
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
            itemCount: filteredContratantes.length,
            itemBuilder: (context, index) {
              final contratante = filteredContratantes[index];
              final isSelected = _localSelectedContratantes
                  .map((c) => c.idContratante == contratante.idContratante)
                  .toList()
                  .contains(true);
              return GestureDetector(
                onTap: () => _toggleContratante(
                    _localSelectedContratantes.firstWhere(
                        (c) => c.idContratante == contratante.idContratante,
                        orElse: () => contratante)),
                child: ContratanteCard(
                    contratante: contratante, isSelected: isSelected),
              );
            },
          ),
        ),
      ],
    );
  }
}
