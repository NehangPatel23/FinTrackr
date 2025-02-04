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
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http.get(Uri.parse('$apiUrl?function=TOP_GAINERS_LOSERS&apikey=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      // Mergeing multiple stock lists
      List<dynamic> allStocks = [
        ...data['top_gainers'],
        ...data['top_losers'],
        ...data['most_actively_traded']
      ];

      setState(() {
        stocks = allStocks.map((stock) {
          return Stock(
            name: stock['ticker'],
            price: double.tryParse(stock['price']) ?? 0.0,
            percentChange: double.tryParse(stock['change_percentage'].replaceAll('%', '')) ?? 0.0,
            delta: double.tryParse(stock['change_amount']) ?? 0.0,
          );
        }).toList();

        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      stocks[index].isFavorite = !stocks[index].isFavorite;
      stocks.sort((a, b) {
        if (a.isFavorite == b.isFavorite) {
          return 0;
        }
        return b.isFavorite ? -1 : 1;
      });
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
      body: Column(
        children: [
          SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/stocks-graphic.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchStockData,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: stocks.length,
                      itemBuilder: (context, index) {
                        final stock = stocks[index];
                        return ListTile(
                          title: Text('${stock.name} (${stock.name})', style: TextStyle(fontWeight: FontWeight.bold)),
                          // subtitle: Text(
                          //   'Price: \$${stock.price.toStringAsFixed(2)} | Change: '
                          //   '${stock.percentChange.toStringAsFixed(2)}% (Δ${stock.delta})',
                          // ),
                          subtitle: Row(
                            children: [
                              Text(
                                'Price: \$${stock.price.toStringAsFixed(2)} | Change: ',
                              ),
                              Text(
                                '${stock.percentChange.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: stock.percentChange >= 0 ? Colors.green : Colors.red,
                                ),
                              ),
                              Text(
                                ' (Δ${stock.delta})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: stock.delta > 0 ? Colors.green : stock.delta < 0 ? Colors.red : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(stock.isFavorite ? Icons.star : Icons.star_border),
                            onPressed: () => toggleFavorite(index),
                          ),
                          onTap: () => showStockDetails(stock),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: StockPage(),
  ));
}
