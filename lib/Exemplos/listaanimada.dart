import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: ListaAnimada()));

class ListaAnimada extends StatefulWidget {
  @override
  _ListaAnimadaState createState() => _ListaAnimadaState();
}

class _ListaAnimadaState extends State<ListaAnimada> {
  // Um mapa para guardar o estado de expansão de cada item
  final Map<int, bool> _expandidos = {};

  @override
  Widget build(BuildContext context) {
    final itens = ['Produto A', 'Produto B', 'Produto C'];

    return Scaffold(
      appBar: AppBar(title: Text('Lista com Animação')),
      body: ListView.builder(
        itemCount: itens.length,
        itemBuilder: (context, index) {
          final item = itens[index];
          final expandido = _expandidos[index] ?? false;

          return Column(
            children: [
              ListTile(
                title: Text(item),
                subtitle: Text('Clique para ver detalhes'),
                trailing: Icon(
                  expandido ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _expandidos[index] = !expandido;
                  });
                },
              ),
              AnimatedCrossFade(
                firstChild: Container(),
                secondChild: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Text('Descrição detalhada de $item'),
                      SizedBox(height: 8),
                      Text('Preço: R\$ ${(index + 1) * 10},00'),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                crossFadeState: expandido
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: Duration(milliseconds: 300),
              ),
            ],
          );
        },
      ),
    );
  }
}
