import 'package:controle_de_gasto/app_controler.dart';
import 'package:controle_de_gasto/screens/grafico_page.dart';
import 'package:controle_de_gasto/screens/historico_page.dart';
import 'package:controle_de_gasto/screens/home_page.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppControler.instance,
      builder: (context, child) {
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme:
                AppControler.instance.isdartTheme
                    ? ColorScheme.dark(
                      primary: Colors.orange,
                      brightness: Brightness.dark
                    )
                    : ColorScheme.light(
                      primary: Colors.yellow,
                      onPrimary: Colors.yellow,
                      brightness: Brightness.light
                    ),
          ),
          initialRoute: '/home',
          routes: {
            // '/': (context) => (),
            '/home': (context) => HomePage(),
            '/historico': (context) => HistoricoPage(),
            '/grafico': (context) => GraficoPage(),
          },
        );
      },
    );
  }
}
