import 'package:fleet_tour/providers/dropdown_state.dart';
import 'package:fleet_tour/widgets/empresa/edit_empresa.dart';
import 'package:fleet_tour/widgets/empresa/empresas.dart';
import 'package:fleet_tour/widgets/funcionario/edit_funcionario.dart';
import 'package:fleet_tour/widgets/funcionario/funcionarios.dart';
import 'package:fleet_tour/widgets/funcionario/new_funcionario.dart';
import 'package:fleet_tour/widgets/generic/generic_address_screen.dart';
import 'package:fleet_tour/widgets/passageiro/new_passageiro_compras.dart';
import 'package:fleet_tour/widgets/passageiro/new_passageiro_turismo.dart';
import 'package:fleet_tour/widgets/passageiro/passageiros.dart';
import 'package:fleet_tour/widgets/register/register_screen.dart';
import 'package:fleet_tour/widgets/register/resgister_address_screen.dart';
import 'package:fleet_tour/widgets/register/user_register_screen.dart';
import 'package:fleet_tour/widgets/veiculo/edit_veiculo.dart';
import 'package:fleet_tour/widgets/veiculo/new_veiculo.dart';
import 'package:fleet_tour/widgets/veiculo/veiculo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Importe o GetX
import 'package:fleet_tour/widgets/login_screen.dart';
import 'package:get_storage/get_storage.dart';

void main() {
  runApp(
    GetMaterialApp(
      initialBinding: InitialBinding(), // Inicialize o controlador aqui
      title: 'Fleet Tour',
      theme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 72, 0, 255),
          brightness: Brightness.light,
          primary: const Color.fromARGB(255, 0, 67, 97),
          secondary: const Color.fromARGB(255, 255, 94, 0),
          error: const Color.fromARGB(255, 255, 0, 0),
          surface: const Color.fromARGB(255, 255, 255, 255),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 105, 200, 218),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          fillColor: Color.fromARGB(255, 255, 255, 255),
          counterStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          hintStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          labelStyle: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
          disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),
        cardTheme: CardTheme(
          color: const Color.fromARGB(255, 39, 142, 178),
          shadowColor: const Color.fromARGB(255, 0, 67, 97),
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
        ),
      ),
      home: const LoginScreen(),
      getPages: [
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(
            name: '/registro/endereco',
            page: () => const RegisterAddressScreen()),
        GetPage(name: '/registro/empresa', page: () => const RegisterScreen()),
        GetPage(
            name: '/registro/usuario', page: () => const UserRegisterScreen()),
        GetPage(name: '/endereco', page: () => const GenericAddressScreen()),
        GetPage(name: '/veiculos', page: () => const Veiculos()),
        GetPage(name: '/veiculos/novo', page: () => const NewVeiculo()),
        GetPage(name: '/veiculos/editar', page: () => const EditVeiculo()),
        GetPage(name: '/funcionarios', page: () => const Funcionarios()),
        GetPage(name: '/funcionario/novo', page: () => const NewFuncionario()),
        GetPage(
            name: '/funcionarios/editar', page: () => const EditFuncionario()),
        GetPage(name: '/empresas', page: () => const Empresas()),
        GetPage(name: '/empresas/editar', page: () => const EditEmpresa()),
        GetPage(name: '/passageiros', page: () => const Passageiros()),
        GetPage(name: '/passageiros/novo/compras',
            page: () => const NewPassageiroCompras()),
        GetPage(name: '/passageiros/novo/turismo',
            page: () => const NewPassageiroTurismo()),
      ],
    ),
  );
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    GetStorage.init();
    Get.put(DropdownState(defaultValue: "Gerenciamento de Frota"));
  }
}
