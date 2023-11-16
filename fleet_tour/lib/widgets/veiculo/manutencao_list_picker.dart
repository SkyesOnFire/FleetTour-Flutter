import 'package:fleet_tour/models/manutencao.dart';
import 'package:fleet_tour/widgets/veiculo/manutencao_card.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class ManutencaoListPicker extends StatefulWidget {
  const ManutencaoListPicker({super.key, required this.manutencoes});

  final List<Manutencao> manutencoes;

  @override
  State<ManutencaoListPicker> createState() => _ManutencaoListPickerState();
}

class _ManutencaoListPickerState extends State<ManutencaoListPicker> {
  List<Manutencao> filteredManutencoes = [];
  TextEditingController searchController = TextEditingController();
  var storage = GetStorage();

  late List<Manutencao> _localSelectedManutencoes;

  @override
  void initState() {
    super.initState();
    filteredManutencoes = widget.manutencoes;
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredManutencoes = widget.manutencoes;
      });
      return;
    }

    List<Manutencao> dummyListData = [];
    widget.manutencoes.forEach((item) {
      if (item.nomeOficina!.toLowerCase().contains(query.toLowerCase())) {
        dummyListData.add(item);
      }
    });

    setState(() {
      filteredManutencoes = dummyListData;
    });
  }

  void _toggleManutencao(Manutencao manutencao) {
    setState(() {
      if (_localSelectedManutencoes.contains(manutencao)) {
        _localSelectedManutencoes.remove(manutencao);
        storage.write('selectedManutencoes', _localSelectedManutencoes);
      } else {
        _localSelectedManutencoes.add(manutencao);
        storage.write('selectedManutencoes', _localSelectedManutencoes);
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
            onChanged: (value) => filterSearchResults(value),
            controller: searchController,
            decoration: const InputDecoration(
              labelText: "Pesquisar",
              hintText: "Digite para pesquisar manutenções",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredManutencoes.length,
            itemBuilder: (context, index) {
              final manutencao = filteredManutencoes[index];
              final isSelected = _localSelectedManutencoes
                  .map((m) => m.idManutencao == manutencao.idManutencao)
                  .toList()
                  .contains(true);
              return GestureDetector(
                onTap: () => _toggleManutencao(
                    _localSelectedManutencoes.firstWhere(
                        (m) => m.idManutencao == manutencao.idManutencao,
                        orElse: () => manutencao)),
                child: ManutencaoCard(manutencao),
              );
            },
          ),
        ),
      ],
    );
  }
}
