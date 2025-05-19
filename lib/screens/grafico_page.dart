import 'package:controle_de_gasto/models/gastos_models.dart';
import 'package:controle_de_gasto/services/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class GraficoPage extends StatelessWidget {
  const GraficoPage({super.key});

  Future<Map<String, double>> getEntradasVsSaidas() async {
    final agora =  DateTime.now();
    List<Gastos> gastosDoMes = await DatabaseHelper.getGastosDoMes(agora.year,agora.month);
    double entradas = 0;
    double saidas = 0;
    for (int i = 0; i < gastosDoMes.length; i++) {
      if (gastosDoMes[i].entrada == 1) {
        entradas += gastosDoMes[i].valor;
      } else {
        saidas += gastosDoMes[i].valor;
      }
    }

    return {'Entradas': entradas, 'Saídas': saidas};
  }

  Future<Map<String, double>> getEntradasPorMes() async {
    List<String> mesesGasto = await DatabaseHelper().getMesesComGastos();
    if (mesesGasto.isEmpty) return {};
    Map<String, double> entradasDosMeses = {};

    for (int i = mesesGasto.length - 1; i >= 0; i--) {
      double entradas = 0;
      List<String> partes = mesesGasto[i].split('-');
      List<int> listFinal = List.filled(2, 0);
      listFinal[0] = int.parse(partes[0]);
      listFinal[1] = int.parse(partes[1]);

      List<Gastos> gastosDoMes =
          await DatabaseHelper.getGastosDoMes(listFinal[0], listFinal[1]);
      for (int i = 0; i < gastosDoMes.length; i++) {
        if (gastosDoMes[i].entrada == 1) {
          entradas += gastosDoMes[i].valor;
        }
      }
      entradasDosMeses[formatarMes(mesesGasto[i])] = entradas;
    }

    return entradasDosMeses;
  }

  Future<Map<String, double>> getBalancoPorMes() async {
    List<String> mesesGasto = await DatabaseHelper().getMesesComGastos();
    if (mesesGasto.isEmpty) return {};
    Map<String, double> entradasDosMeses = {};

    for (int i = mesesGasto.length - 1; i >= 0; i--) {
      double entradas = 0;
      double saidas = 0;
      List<String> partes = mesesGasto[i].split('-');
      List<int> listFinal = List.filled(2, 0);
      listFinal[0] = int.parse(partes[0]);
      listFinal[1] = int.parse(partes[1]);

      List<Gastos> gastosDoMes =
          await DatabaseHelper.getGastosDoMes(listFinal[0], listFinal[1]);
      for (int i = 0; i < gastosDoMes.length; i++) {
        if (gastosDoMes[i].entrada == 1) {
          entradas += gastosDoMes[i].valor;
        }else if (gastosDoMes[i].entrada == 0) {
          saidas += gastosDoMes[i].valor;
        }
      }
      entradasDosMeses[formatarMes(mesesGasto[i])] = entradas - saidas;
    }

    return entradasDosMeses;
  }

  Future<Map<String, double>> getSaidasPorMes() async {
    List<String> mesesGasto = await DatabaseHelper().getMesesComGastos();
    if (mesesGasto.isEmpty) return {};
    Map<String, double> entradasDosMeses = {};

    for (int i = mesesGasto.length - 1; i >= 0; i--) {
      double saidas = 0;
      List<String> partes = mesesGasto[i].split('-');
      List<int> listFinal = List.filled(2, 0);
      listFinal[0] = int.parse(partes[0]);
      listFinal[1] = int.parse(partes[1]);

      List<Gastos> gastosDoMes =
          await DatabaseHelper.getGastosDoMes(listFinal[0], listFinal[1]);
      for (int i = 0; i < gastosDoMes.length; i++) {
        if (gastosDoMes[i].entrada == 0) {
          saidas += gastosDoMes[i].valor;
        }
      }
      entradasDosMeses[formatarMes(mesesGasto[i])] = saidas;
    }

    return entradasDosMeses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Graficos")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Gráfico de Pizza
              FutureBuilder<Map<String, double>>(
                future: getEntradasVsSaidas(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final data = snapshot.data!;
                  final total = data.values.fold(0.0, (a, b) => a + b);
                  final colors = [Colors.green, Colors.red];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Entradas vs Saídas do Mês",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: PieChart(
                          PieChartData(
                            sections:
                                data.entries.map((e) {
                                  final i = data.keys.toList().indexOf(e.key);
                                  final percent = (e.value / total) * 100;
                                  return PieChartSectionData(
                                    color: colors[i],
                                    value: e.value,
                                    title:
                                        '${e.key}\n${percent.toStringAsFixed(1)}%',
                                    titleStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    radius: 80,
                                  );
                                }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),

              // Gráfico de Linha
              FutureBuilder<Map<String, double>>(
                future: getBalancoPorMes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final data = snapshot.data!;
                  final keys = data.keys.toList();
                  final values = data.values.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Balanço por Mês",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= keys.length)
                                      return Text('');
                                    return Text(keys[index]);
                                  },
                                  interval: 1,
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  values.length,
                                  (index) =>
                                      FlSpot(index.toDouble(), values[index]),
                                ),
                                isCurved: false,
                                barWidth: 2,
                                color: Colors.blue,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              // Gráfico de Linha
              SizedBox(height: 40),
              FutureBuilder<Map<String, double>>(
                future: getEntradasPorMes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final data = snapshot.data!;
                  final keys = data.keys.toList();
                  final values = data.values.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Entradas por Mês",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= keys.length)
                                      return Text('');
                                    return Text(keys[index]);
                                  },
                                  interval: 1,
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  values.length,
                                  (index) =>
                                      FlSpot(index.toDouble(), values[index]),
                                ),
                                isCurved: false,
                                barWidth: 2,
                                color: Colors.green,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 40),

              // Gráfico de Linha
              FutureBuilder<Map<String, double>>(
                future: getSaidasPorMes(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();
                  final data = snapshot.data!;
                  final keys = data.keys.toList();
                  final values = data.values.toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "Saidas por Mês",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: LineChart(
                          LineChartData(
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, _) {
                                    final index = value.toInt();
                                    if (index < 0 || index >= keys.length)
                                      return Text('');
                                    return Text(keys[index]);
                                  },
                                  interval: 1,
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: List.generate(
                                  values.length,
                                  (index) =>
                                      FlSpot(index.toDouble(), values[index]),
                                ),
                                isCurved: false,
                                barWidth: 2,
                                color: Colors.red,
                                dotData: FlDotData(show: true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String formatarMes(String mes) {
  final partes = mes.split('-');
  final mesNumero = int.parse(partes[1]);

  const nomesMeses = [
    '',
    'Jan',
    'Fev',
    'Mar',
    'Abr',
    'Mai',
    'Jun',
    'Jul',
    'Ago',
    'Set',
    'Out',
    'Nov',
    'Dez',
  ];

  return nomesMeses[mesNumero];
}
