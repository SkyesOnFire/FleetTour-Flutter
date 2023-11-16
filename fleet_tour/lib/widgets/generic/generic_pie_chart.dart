import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:intl/intl.dart';

class LucroDespesaPieChart extends StatelessWidget {
  const LucroDespesaPieChart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, double> dataMap = {
      "Lucros": 10000,
      "Despesas": 7500,
    };

    String formatarValorMonetario(double valor) {
      final formatador = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
      return formatador.format(valor);
    }

    // Transformar em dados formatados
    Map<String, double> dataMapFormatted = { 
      for (var item in dataMap.keys) item : dataMap[item]! };


    return PieChart(
      dataMap: dataMapFormatted,
      animationDuration: const Duration(milliseconds: 800),
      chartLegendSpacing: 32,
      chartRadius: MediaQuery.of(context).size.width / 2,
      colorList: const [Colors.blueAccent, Colors.redAccent],
      initialAngleInDegree: 0,
      chartType: ChartType.ring,
      ringStrokeWidth: 32,
      centerText: "Lucros vs Despesas",
      legendOptions: const LegendOptions(
        showLegendsInRow: false,
        legendPosition: LegendPosition.right,
        showLegends: true,
        legendTextStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      chartValuesOptions: const ChartValuesOptions(
        showChartValueBackground: true,
        showChartValues: true,
        showChartValuesInPercentage: false,
        showChartValuesOutside: true,
        chartValueStyle: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        decimalPlaces: 0,
      ),
    );
  }
}
