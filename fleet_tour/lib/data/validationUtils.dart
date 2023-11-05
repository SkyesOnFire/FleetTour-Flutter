import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

bool validarRenavam(String renavam) {
  // Remove caracteres não numéricos
  renavam = renavam.replaceAll(RegExp(r'[^0-9]'), '');

  // Verifica o tamanho do RENAVAM
  if (renavam.length != 9 && renavam.length != 11) {
    return false;
  }

  // Completa com zeros à esquerda se necessário
  renavam = renavam.padLeft(11, '0');

  // Inverte os dígitos do número, exceto o último (dígito verificador)
  String renavamInvertido =
      renavam.substring(0, 10).split('').reversed.join('');

  // Multiplicadores (de 2 a 10, de acordo com a regra)
  final multiplicadores = List.generate(8, (i) => i + 2);

  // Realiza a soma dos produtos
  int soma = 0;
  for (int i = 0; i < renavamInvertido.length; i++) {
    soma += int.parse(renavamInvertido[i]) * multiplicadores[i % 8];
  }

  // Calcula o dígito verificador
  int mod11 = soma % 11;
  int digitoVerificador = mod11 < 2 ? 0 : 11 - mod11;

  // Compara o dígito verificador calculado com o fornecido
  return renavam[10] == digitoVerificador.toString();
}

/// Formata o valor do campo com a máscara de `000.000.000`.
class CustomKmInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 11) {
      return oldValue;
    }
    // Removendo pontos existentes para obter apenas números
    String rawText = newValue.text.replaceAll('.', '');
    int cursorIndex = newValue.selection.end;

    // Verificando se o texto é maior que o permitido
    if (rawText.length > 9) {
      rawText = rawText.substring(0, 9);
    }

    // Adicionando pontos
    StringBuffer newText = StringBuffer();
    for (int i = 0; i < rawText.length; i++) {
      if (i > 0 && (rawText.length - i) % 3 == 0) {
        newText.write('.');
        if (i < cursorIndex) {
          cursorIndex++;
        }
      }
      newText.write(rawText[i]);
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: cursorIndex),
    );
  }
}

String formatCPF(String cpf) {
  if (cpf.length != 11){
    if (kDebugMode) {
      print('Error converting $cpf to CPF.');
    }
    return cpf;
  }
  return cpf
      .replaceRange(3, 3, '.')
      .replaceRange(7, 7, '.')
      .replaceRange(11, 11, '-');
}

String formatCNPJ(String cnpj) {
  if (cnpj.length != 14){
    if (kDebugMode) {
      print('Error converting $cnpj to CNPJ.');
    }
    return cnpj;
  }
  return cnpj
      .replaceRange(2, 2, '.')
      .replaceRange(6, 6, '.')
      .replaceRange(10, 10, '/')
      .replaceRange(15, 15, '-');
}

String formatTelefone(String telefone) {
  if (telefone.length != 10 && telefone.length != 11) {
    if (kDebugMode) {
      print('Error converting $telefone to phone number.');
    }
    return telefone;
  }
  var formatted = '(${telefone.substring(0, 2)}) ';
  if (telefone.length == 11) {
    formatted += '${telefone.substring(2, 3)} ';
  }
  formatted +=
      '${telefone.substring(telefone.length - 9, telefone.length - 4)}-';
  formatted += telefone.substring(telefone.length - 4);
  return formatted;
}

String decodeUtf8String(String nonUtf8String) {
  List<int> bytes = nonUtf8String.codeUnits;
  return utf8.decode(bytes);
}

String formatCep(String cep) {
  // Remove any non-digit character.
  var digits = cep.replaceAll(RegExp(r'\D'), '');
  
  // If there are more or fewer than 8 digits, return the original string.
  if (digits.length != 8) {
    return cep;
  }

  // Insert the hyphen after the fifth digit.
  return digits.replaceRange(5, 5, '-');
}

String? formatDateForInput(DateTime? date) {
  if (date == null) {
    return null; // or some default message indicating no date is available
  }

  // Extract day, month, and year from ultimaVistoria
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  final year = date.year.toString();

  // Return the formatted string
  return '$day/$month/$year';
}
