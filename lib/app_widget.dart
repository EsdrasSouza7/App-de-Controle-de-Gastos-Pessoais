import 'package:controle_de_gasto/app_controler.dart';
import 'package:controle_de_gasto/screens/add_gasto_page.dart';
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
            colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 153, 94, 255)),
            brightness: Brightness.light,
          ),
          initialRoute: '/home',
          routes: {
           // '/': (context) => (),
            '/home': (context) => HomePage(),
            '/add': (context) => AddGastoPage()
          },
        );
      },
    );
  }
}
