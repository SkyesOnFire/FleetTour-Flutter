import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/veiculo.dart';

class Manutencao {
  int? idManutencao;
  DateTime? dataManutencao;
  double? valor;
  String? observacao;
  double? km;
  String? nomeOficina;
  String? telefoneOficina;
  String? nomeResponsavel;
  Funcionario? funcionario;
  Veiculo? veiculo;

  Manutencao({
    this.idManutencao,
    this.dataManutencao,
    this.valor,
    this.observacao,
    this.km,
    this.nomeOficina,
    this.telefoneOficina,
    this.nomeResponsavel,
    this.funcionario,
    this.veiculo,
  });

  factory Manutencao.fromJson(Map<String, dynamic> json) {
    return Manutencao(
      idManutencao: json['idManutencao'],
      dataManutencao: json['dataManutencao'] != null ? DateTime.parse(json['dataManutencao']) : null,
      valor: json['valor']?.toDouble(),
      observacao: json['observacao'],
      km: json['km']?.toDouble(),
      nomeOficina: json['nomeOficina'],
      telefoneOficina: json['telefoneOficina'],
      nomeResponsavel: json['nomeResponsavel'],
      funcionario: json['funcionario'] != null ? Funcionario.fromJson(json['funcionario']) : null,
      veiculo: json['veiculo'] != null ? Veiculo.fromJson(json['veiculo']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idManutencao': idManutencao,
      'dataManutencao': dataManutencao?.toIso8601String(),
      'valor': valor,
      'observacao': observacao,
      'km': km,
      'nomeOficina': nomeOficina,
      'telefoneOficina': telefoneOficina,
      'nomeResponsavel': nomeResponsavel,
      'funcionario': funcionario?.toJson(),
      'veiculo': veiculo?.toJson(),
    };
  }
}
