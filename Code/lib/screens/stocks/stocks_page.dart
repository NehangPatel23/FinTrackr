import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fintrackr/screens/stocks/stock_chart.dart';
import 'dart:convert';

const String apiKey = 'OYNU1LA5APCCQ1I5';
const String apiUrl = 'https://www.alphavantage.co/query';

class Stock {
  final String name;
  final String ticker;
  final double price;
  final double percentChange;
  final double delta;
  bool isFavorite;

  Stock({
    required this.name,
    required this.ticker,
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
  List<Stock> filteredStocks = [];
  bool isLoading = false;
  TextEditingController searchController = TextEditingController();

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
            name: stock['name'] ?? stock['ticker'],
            ticker: stock['ticker'],
            price: double.tryParse(stock['price']) ?? 0.0,
            percentChange: double.tryParse(stock['change_percentage'].replaceAll('%', '')) ?? 0.0,
            delta: double.tryParse(stock['change_amount']) ?? 0.0,
          );
        }).toList();

        filteredStocks = stocks;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterStocks(String query) {
    setState(() {
      filteredStocks = query.isEmpty
          ? stocks
          : stocks.where((stock) =>
              stock.name.toLowerCase().contains(query.toLowerCase())).toList();
    });
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
        "Revenue": data["RevenueTTM"] ?? "N/A",
        "PERatio": data["PERatio"] ?? "N/A"
      };
    } else {
      return null;
    }
  }

  void toggleFavorite(int index) {
    setState(() {
      stocks[index].isFavorite = !stocks[index].isFavorite;

      stocks.sort((a, b) {
        if (a.isFavorite && !b.isFavorite) return -1;
        if (!a.isFavorite && b.isFavorite) return 1;
        return 0;
      });
    });
  }

  String getStockRating(Map<String, dynamic> companyInfo) {
    double peRatio = double.tryParse(companyInfo["PERatio"] ?? "0") ?? 0;
    double marketCap = double.tryParse(companyInfo["MarketCap"]?.replaceAll(',', '') ?? "0") ?? 0;
    double ebitda = double.tryParse(companyInfo["EBITDA"]?.replaceAll(',', '') ?? "0") ?? 0;

    if (peRatio > 30) {
      return "🔴 Sell (Overvalued)";
    } else if (peRatio < 15 && marketCap > 5000000000 && ebitda > 1000000000) {
      return "🟢 Strong Buy (Undervalued)";
    } else if (peRatio < 20) {
      return "🟡 Hold (Fairly Priced)";
    } else {
      return "⚪ Neutral";
    }
  }

  void showStockDetails(Stock stock) async {
    Map<String, dynamic>? companyInfo = await fetchCompanyInfo(stock.name);

    companyInfo ??= {
      "Name": stock.name,
      "Description": "No description available",
      "Industry": "N/A",
      "MarketCap": "N/A",
      "EBITDA": "N/A",
      "Revenue": "N/A",
      "PERatio": "N/A"
    };

    String rating = getStockRating(companyInfo);

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      stock.ticker,
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
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: rating.startsWith("🟢") ? Colors.green[100] :
                              rating.startsWith("🟡") ? Colors.yellow[100] :
                                rating.startsWith("🔴") ? Colors.red[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        "📊 Rating: $rating",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10),

                    SizedBox(
                      height: 200,
                      width: 300,
                      child: StockChart(ticker: stock.name),
                    ),
                    Divider(),

                    Text(
                      '🏢 Industry: ${(companyInfo ?? {})["Industry"] ?? "N/A"}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    Text(
                      '💰 Market Cap: \$${(companyInfo ?? {})["MarketCap"] ?? "N/A"}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 5),

                    Text(
                      '📊 EBITDA: \$${(companyInfo ?? {})["EBITDA"] ?? "N/A"}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '📈 Revenue (TTM): \$${(companyInfo ?? {})["Revenue"] ?? "N/A"}',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    Divider(),

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
          },
        );
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/stocks.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Stocks',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search stocks...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: filterStocks,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchStockData,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        return ListTile(
                          title: Text('${stock.name}', style: TextStyle(fontWeight: FontWeight.bold)),
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
