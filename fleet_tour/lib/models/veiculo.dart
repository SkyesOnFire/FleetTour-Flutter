// ignore_for_file: public_member_api_docs, sort_constructors_first


class Veiculo {
  final int id;
  final String placa;
  final String km;
  final String ano;
  final String renavam;
  final String numeroFrota;
  final int capacidade;
  final String taf;
  final String regEstadual;

  Veiculo({
    required this.id,
    required this.placa,
    required this.km,
    required this.renavam,
    required this.numeroFrota,
    required this.capacidade,
    required this.taf,
    required this.regEstadual,
    required this.ano,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'placa': placa,
      'km': km,
      'ano': ano,
      'renavam': renavam,
      'numeroFrota': numeroFrota,
      'capacidade': capacidade,
      'taf': taf,
      'regEstadual': regEstadual,
    };
  }

  Veiculo.fromJson(Map<String, dynamic> json)
      : id = json['idVeiculo'],
        placa = json['placa'],
        km = json['km'],
        ano = json['ano'],
        renavam = json['renavam'],
        numeroFrota = json['numeroFrota'],
        capacidade = json['capacidade'],
        taf = json['taf'],
        regEstadual = json['regEstadual'];
}
