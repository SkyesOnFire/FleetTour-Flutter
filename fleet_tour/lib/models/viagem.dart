import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/passageiro.dart';
import 'package:fleet_tour/models/veiculo.dart';

class Viagem {
  int? idViagem;
  DateTime? dataViagem;
  DateTime? horaSaida;
  DateTime? horaChegada;
  double? valor;
  String? status;
  String? observacao;
  String? destino;
  String? origem;
  double? km;
  String? nfe;
  double? valorNfe;
  List<Passageiro>? passageiros;
  List<Funcionario>? funcionarios;
  Veiculo? veiculo;
  Empresa? empresa;
  Contratante? contratante;

  Viagem({
    this.idViagem,
    this.dataViagem,
    this.horaSaida,
    this.horaChegada,
    this.valor,
    this.status,
    this.observacao,
    this.destino,
    this.origem,
    this.km,
    this.nfe,
    this.valorNfe,
    this.passageiros,
    this.funcionarios,
    this.veiculo,
    this.empresa,
    this.contratante,
  });

  factory Viagem.fromJson(Map<String, dynamic> json) {
    return Viagem(
      idViagem: json['idViagem'],
      dataViagem: DateTime.parse(json['dataViagem']),
      horaSaida: DateTime.parse(json['horaSaida']),
      horaChegada: DateTime.parse(json['horaChegada']),
      valor: json['valor'],
      status: json['status'],
      observacao: json['observacao'],
      destino: json['destino'],
      origem: json['origem'],
      km: json['km'],
      nfe: json['nfe'],
      valorNfe: json['valorNfe'],
      passageiros: json['passageiros'] != null ? (json['passageiros'] as List).map((i) => Passageiro.fromJson(i)).toList() : null,
      funcionarios: json['funcionarios'] != null ? (json['funcionarios'] as List).map((i) => Funcionario.fromJson(i)).toList() : null,
      veiculo: json['veiculo'] != null ? Veiculo.fromJson(json['veiculo']) : null,
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
      contratante: json['contratante'] != null ? Contratante.fromJson(json['contratante']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idViagem': idViagem,
      'dataViagem': dataViagem?.toIso8601String(),
      'horaSaida': horaSaida?.toIso8601String(),
      'horaChegada': horaChegada?.toIso8601String(),
      'valor': valor,
      'status': status,
      'observacao': observacao,
      'destino': destino,
      'origem': origem,
      'km': km,
      'nfe': nfe,
      'valorNfe': valorNfe,
      'passageiros': passageiros?.map((e) => e.toJson()).toList(),
      'funcionarios': funcionarios?.map((e) => e.toJson()).toList(),
      'veiculo': veiculo?.toJson(),
      'empresa': empresa?.toJson(),
      'contratante': contratante?.toJson(),
    };
  }
}
