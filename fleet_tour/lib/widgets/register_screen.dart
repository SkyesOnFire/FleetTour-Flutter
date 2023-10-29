import 'dart:convert';

import 'package:fleet_tour/configs/server.dart';
import 'package:flutter/material.dart';

class registerScreen extends StatefulWidget {
  const registerScreen({super.key});

  @override
  State<registerScreen> createState() => _registerScreenState();
}

class _registerScreenState extends State<registerScreen> {
  final _formKey = GlobalKey<FormState>();
  var _enteredCNPJ = '';
  var _enteredNomeFantasia = '';
  var _enteredRazaoSocial = '';
  var _enteredInscricaoMunicipal = '';
  var _enteredInscricaoEstadual = '';
  var _enteredEmail = '';
  var _enteredFoneEmpresa = '';
  var _enteredNomeResponsavel = '';
  var _enteredFoneResponsavel = '';
  var _enteredEmailResponsavel = '';

  get http => null;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final url = Uri.https(ip, 'empresas');
      print(url);
      final body = json.encode(
        <String, dynamic>{
          'cnpj': _enteredCNPJ,
          'nomeFantasia': _enteredNomeFantasia,
          'razaoSocial': _enteredRazaoSocial,
          'inscricaoMunicipal': _enteredInscricaoMunicipal,
          'inscricaoEstadual': _enteredInscricaoEstadual,
          'email': _enteredEmail,
          'foneEmpresa': _enteredFoneEmpresa,
          'nomeResponsavel': _enteredNomeResponsavel,
          'foneResponsavel': _enteredFoneResponsavel,
          'emailResponsavel': _enteredEmailResponsavel,
        },
      );
      print(body);
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: body,
      );
      print(response.body);

      if (response.statusCode == 200) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
