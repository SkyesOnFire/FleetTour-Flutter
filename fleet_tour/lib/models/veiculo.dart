import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/manutencao.dart';

class Veiculo {
  int? idVeiculo;
  String? placa;
  String? renavam;
  String? ano;
  String? quilometragem;
  String? codFrota;
  int? capacidade;
  String? taf;
  String? regEstadual;
  DateTime? ultimaVistoria;
  DateTime? seguro;
  DateTime? licenciamentoAntt;
  DateTime? licenciamentoDer;
  List<Manutencao>? manutencoes;
  Empresa? empresa;

  Veiculo({
    this.idVeiculo,
    this.placa,
    this.renavam,
    this.ano,
    this.quilometragem,
    this.codFrota,
    this.capacidade,
    this.taf,
    this.regEstadual,
    this.ultimaVistoria,
    this.seguro,
    this.licenciamentoAntt,
    this.licenciamentoDer,
    this.manutencoes,
    this.empresa,
  });

  factory Veiculo.fromJson(Map<String, dynamic> json) {
    return Veiculo(
      idVeiculo: json['idVeiculo'],
      placa: json['placa'],
      renavam: json['renavam'],
      ano: json['ano'],
      quilometragem: json['quilometragem'],
      codFrota: json['codFrota'],
      capacidade: json['capacidade'],
      taf: json['taf'],
      regEstadual: json['regEstadual'],
      ultimaVistoria: json['ultimaVistoria'] != null ? DateTime.parse(json['ultimaVistoria']) : null,
      seguro: json['seguro'] != null ? DateTime.parse(json['seguro']) : null,
      licenciamentoAntt: json['licenciamentoAntt'] != null ? DateTime.parse(json['licenciamentoAntt']) : null,
      licenciamentoDer: json['licenciamentoDer'] != null ? DateTime.parse(json['licenciamentoDer']) : null,
      manutencoes: json['manutencoes'] != null ? (json['manutencoes'] as List).map((i) => Manutencao.fromJson(i)).toList() : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idVeiculo': idVeiculo,
      'placa': placa,
      'renavam': renavam,
      'ano': ano,
      'quilometragem': quilometragem,
      'codFrota': codFrota,
      'capacidade': capacidade,
      'taf': taf,
      'regEstadual': regEstadual,
      'ultimaVistoria': ultimaVistoria?.toIso8601String(),
      'seguro': seguro?.toIso8601String(),
      'licenciamentoAntt': licenciamentoAntt?.toIso8601String(),
      'licenciamentoDer': licenciamentoDer?.toIso8601String(),
      'manutencoes': manutencoes?.map((e) => e.toJson()).toList(),
      'empresa': empresa?.toJson(),
    };
  }
}
