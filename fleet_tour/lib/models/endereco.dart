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
    };
  }
}
