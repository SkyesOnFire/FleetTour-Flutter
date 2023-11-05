import 'package:fleet_tour/models/contratante.dart';
import 'package:fleet_tour/models/empresa.dart';
import 'package:fleet_tour/models/funcionario.dart';
import 'package:fleet_tour/models/passageiro.dart';

class Endereco {
  int? idEndereco;
  String? cep;
  String? rua;
  String? bairro;
  String? numero;
  String? complemento;
  String? estado;
  String? cidade;
  String? pais;
  Passageiro? passageiro;
  Passageiro? passageiroLoja;
  Funcionario? funcionario;
  Contratante? contratante;
  Empresa? empresa;

  Endereco({
    this.idEndereco,
    this.cep,
    this.rua,
    this.bairro,
    this.numero,
    this.complemento,
    this.estado,
    this.cidade,
    this.pais,
    this.passageiro,
    this.passageiroLoja,
    this.funcionario,
    this.contratante,
    this.empresa,
  });

  factory Endereco.fromJson(Map<String, dynamic> json) {
    return Endereco(
      idEndereco: json['idEndereco'],
      cep: json['cep'],
      rua: json['rua'],
      bairro: json['bairro'],
      numero: json['numero'],
      complemento: json['complemento'],
      estado: json['estado'],
      cidade: json['cidade'],
      pais: json['pais'],
      passageiro: json['passageiro'] != null ? Passageiro.fromJson(json['passageiro']) : null,
      passageiroLoja: json['passageiroLoja'] != null ? Passageiro.fromJson(json['passageiroLoja']) : null,
      funcionario: json['funcionario'] != null ? Funcionario.fromJson(json['funcionario']) : null,
      contratante: json['contratante'] != null ? Contratante.fromJson(json['contratante']) : null,
      empresa: json['empresa'] != null ? Empresa.fromJson(json['empresa']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idEndereco': idEndereco,
      'cep': cep,
      'rua': rua,
      'bairro': bairro,
      'numero': numero,
      'complemento': complemento,
      'estado': estado,
      'cidade': cidade,
      'pais': pais,
      'passageiro': passageiro?.toJson(),
      'passageiroLoja': passageiroLoja?.toJson(),
      'funcionario': funcionario?.toJson(),
      'contratante': contratante?.toJson(),
      'empresa': empresa?.toJson(),
    };
  }
}
