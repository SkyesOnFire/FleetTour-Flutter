import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/widgets/passageiro/passageiro_card.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PassageiroListPicker extends StatefulWidget {
  const PassageiroListPicker({super.key, required this.passageiros, required this.selectedPassageiros});

  final List<Passageiro> passageiros;
  final List<Passageiro> selectedPassageiros;

  @override
  State<PassageiroListPicker> createState() => _PassageiroListPickerState();
}

class _PassageiroListPickerState extends State<PassageiroListPicker> {
  List<Passageiro> filteredPassageiros = [];
  TextEditingController searchController = TextEditingController();
  var storage = GetStorage();

  late List<Passageiro> _localSelectedPassageiros;

  @override
  void initState() {
    super.initState();
    filteredPassageiros = widget.passageiros;
    _localSelectedPassageiros = List.from(widget.selectedPassageiros);
    storage.write('selectedPassageiros', _localSelectedPassageiros);
  }

  void filterSearchResults(String query) {
    if(query.isEmpty) {
      setState(() {
        filteredPassageiros = widget.passageiros;
      });
      return;
    } 

    List<Passageiro> dummyListData = [];
    widget.passageiros.forEach((item) {
      if(item.nome!.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });

    setState(() {
      filteredPassageiros = dummyListData;
    });
  }

  void _togglePassageiro(Passageiro passageiro) {
    setState(() {
      if (_localSelectedPassageiros.contains(passageiro)) {
        _localSelectedPassageiros.remove(passageiro);
        storage.write('selectedPassageiros', _localSelectedPassageiros);
      } else {
        _localSelectedPassageiros.add(passageiro);
        storage.write('selectedPassageiros', _localSelectedPassageiros);
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
              hintText: "Digite para pesquisar passageiros",
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
            itemCount: filteredPassageiros.length,
            itemBuilder: (context, index) {
              final passageiro = filteredPassageiros[index];
              final isSelected = _localSelectedPassageiros
              .map((p) => p.idPassageiro == passageiro.idPassageiro)
              .toList()
              .contains(true);
              return GestureDetector(
                onTap: () => _togglePassageiro(_localSelectedPassageiros.firstWhere((p) => p.idPassageiro == passageiro.idPassageiro, orElse: () => passageiro)),
                child: PassageiroCard(passageiro: passageiro, isSelected: isSelected),
              );
            },
          ),
        ),
      ],
    );
  }
}
