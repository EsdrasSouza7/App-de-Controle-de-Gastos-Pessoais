import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: CarrinhoPage(),
  ));
}

class CarrinhoPage extends StatelessWidget {
  final List<String> produtos = ['Produto A', 'Produto B', 'Produto C'];
  final double total = 123.45;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Carrinho')),
      body: ListView.builder(
        itemCount: produtos.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(produtos[index]),
            subtitle: Text('R\$ ${(index + 1) * 10},00'),
          );
        },
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total: R\$ ${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                // ação de finalizar compra
              },
              child: Text('Finalizar'),
            )
          ],
        ),
      ),
    );
  }
}
