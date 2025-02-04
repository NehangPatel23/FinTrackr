import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fintrackr/screens/stocks/stock_chart.dart';
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

  Future<Map<String, dynamic>?> fetchCompanyInfo(String ticker) async {
    final response = await http.get(Uri.parse(
        '$apiUrl?function=OVERVIEW&symbol=$ticker&apikey=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      return {
        "Name": data["Name"] ?? "N/A",
        "Description": data["Description"] ?? "No description available",
        "Industry": data["Industry"] ?? "N/A",
        "MarketCap": data["MarketCapitalization"] ?? "N/A",
        "EBITDA": data["EBITDA"] ?? "N/A",
        "Revenue": data["RevenueTTM"] ?? "N/A"
      };
    } else {
      return null;
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      stocks[index].isFavorite = !stocks[index].isFavorite;

      // Sort: Favorited stocks go to the top, others keep their original order
      stocks.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1; // a comes before b
        if (!a.isFavorite && b.isFavorite) return 1; // b comes before a
        return 0; // Keep original order
      });
    });
  }

  void showStockDetails(Stock stock) async {
    Map<String, dynamic>? companyInfo = await fetchCompanyInfo(stock.name);

    companyInfo ??= {
      "Name": stock.name,
      "Description": "No description available",
      "Industry": "N/A",
      "MarketCap": "N/A",
      "EBITDA": "N/A",
      "Revenue": "N/A"
    };

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded( 
              child: Text(
                (companyInfo ?? {})["Name"] ?? "N/A",
                style: TextStyle(fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Stock Price Chart
            SizedBox(
              height: 200,
              child: StockChart(ticker: stock.name),
            ),
            Divider(),

            // Industry
            Text(
              '🏢 Industry: ${(companyInfo ?? {})["Industry"] ?? "N/A"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // Market Cap
            Text(
              '💰 Market Cap: \$${(companyInfo ?? {})["Market Cap"] ?? "N/A"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 5),

            // EBITDA & Revenue
            Text(
              '📊 EBITDA: \$${(companyInfo ?? {})["EBIDTA"] ?? "N/A"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              '📈 Revenue (TTM): \$${(companyInfo ?? {})["Revenue"] ?? "N/A"}',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Divider(),

            // Description
            Text(
              '🌍 About the Company:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            Text(
              (companyInfo ?? {})["Description"] ?? "No Description Available",
              textAlign: TextAlign.justify,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 13),
            ),
          ],
        ),
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
              'assets/stocks.png',
              width: 200,
              height: 200,
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
