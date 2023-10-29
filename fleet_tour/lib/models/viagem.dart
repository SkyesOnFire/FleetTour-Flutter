import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/veiculo.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/models/contratante.dart';

class Viagem {
  int idViagem;
  DateTime dataViagem;
  DateTime horaSaida;
  DateTime horaChegada;
  double valor;
  String status;
  String? observacao;
  String destino;
  String origem;
  double km;
  String nfe;
  double valorNfe;
  List<Passageiro> passageiros;
  List<Funcionario> funcionarios;
  Veiculo veiculo;
  Empresa empresa;
  Contratante contratante;

  Viagem({
    required this.idViagem,
    required this.dataViagem,
    required this.horaSaida,
    required this.horaChegada,
    required this.valor,
    required this.status,
    required this.destino,
    required this.origem,
    required this.km,
    required this.nfe,
    required this.valorNfe,
    required this.passageiros,
    required this.funcionarios,
    required this.veiculo,
    required this.empresa,
    required this.contratante,
    this.observacao,
  });
}
