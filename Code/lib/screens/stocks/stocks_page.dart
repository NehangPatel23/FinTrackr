import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'OYNU1LA5APCCQ1I5';
const String apiUrl = 'https://www.alphavantage.co/query';

class Stock {
  final String name;
  final double price;
  final double percentChange;
  final double delta;
  bool isFavorite;

  Stock({
    required this.name,
    required this.price,
    required this.percentChange,
    required this.delta,
    this.isFavorite = false,
  });
}

class StockPage extends StatefulWidget {
  @override
  _StockPageState createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  List<Stock> stocks = [];

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    final response = await http.get(Uri.parse('$apiUrl?function=TOP_GAINERS_LOSERS&apikey=$apiKey'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        stocks = List.generate(10, (index) => Stock(
          name: 'Stock ${index + 1}',
          price: (100 + index * 2).toDouble(),
          percentChange: (index % 5 - 2).toDouble(),
          delta: (index % 3 - 1).toDouble(),
        ));
      });
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      stocks[index].isFavorite = !stocks[index].isFavorite;
      stocks.sort((a, b) => b.isFavorite ? -1 : a.isFavorite ? 1 : 0);
    });
  }

  void showStockDetails(Stock stock) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(stock.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(height: 100, color: Colors.grey[300], child: Center(child: Text('Graph Placeholder'))),
            SizedBox(height: 10),
            Text('Price: \$${stock.price.toStringAsFixed(2)}'),
            Text('Change: ${stock.percentChange.toStringAsFixed(2)}% (Δ${stock.delta})'),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Close')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stocks'),
        actions: [
          IconButton(
            icon: Icon(Icons.info_outline),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          final stock = stocks[index];
          return ListTile(
            title: Text(stock.name),
            subtitle: Text('Price: \$${stock.price.toStringAsFixed(2)} | Change: ${stock.percentChange.toStringAsFixed(2)}% (Δ${stock.delta})'),
            trailing: IconButton(
              icon: Icon(stock.isFavorite ? Icons.star : Icons.star_border),
              onPressed: () => toggleFavorite(index),
            ),
            onTap: () => showStockDetails(stock),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StockPage(),
  ));
}
