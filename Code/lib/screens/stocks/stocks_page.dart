import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fintrackr/screens/stocks/stock_chart.dart';
import 'dart:convert';
import 'dart:math';

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
  const StockPage({super.key});

  @override
  StockPageState createState() => StockPageState();
}

class StockPageState extends State<StockPage> {
  List<Stock> stocks = [];
  List<Stock> filteredStocks = [];
  bool isLoading = false;
  bool isSearching = false;
  TextEditingController searchController = TextEditingController();
  String selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    setState(() {
      isLoading = true;
    });

    final response = await http
        .get(Uri.parse('$apiUrl?function=TOP_GAINERS_LOSERS&apikey=$apiKey'));

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
            percentChange: double.tryParse(
                    stock['change_percentage'].replaceAll('%', '')) ??
                0.0,
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
          : stocks
              .where((stock) =>
                  stock.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  String formatNumber(dynamic value) {
    if (value == null || value.isEmpty || value == "N/A") {
      return "N/A";
    }

    double number = double.tryParse(value.toString()) ?? 0.0;
    bool isNegative = number < 0;
    number = number.abs();

    String formatted;
    if (number >= 1e9) {
      formatted = "${(number / 1e9).toStringAsFixed(2)}B";
    } else if (number >= 1e6) {
      formatted = "${(number / 1e6).toStringAsFixed(2)}M";
    } else if (number >= 1e3) {
      formatted = "${(number / 1e3).toStringAsFixed(2)}K";
    } else {
      formatted = number.toStringAsFixed(2);
    }

    return isNegative ? "-\$$formatted" : "\$$formatted";
  }

  String formatNumber(dynamic value) {
    if (value == null || value.isEmpty || value == "N/A") {
      return "N/A";
    }

    double number = double.tryParse(value.toString()) ?? 0.0;
    bool isNegative = number < 0;
    number = number.abs();

    String formatted;
    if (number >= 1e9) {
      formatted = "${(number / 1e9).toStringAsFixed(2)}B";
    } else if (number >= 1e6) {
      formatted = "${(number / 1e6).toStringAsFixed(2)}M";
    } else if (number >= 1e3) {
      formatted = "${(number / 1e3).toStringAsFixed(2)}K";
    } else {
      formatted = number.toStringAsFixed(2);
    }

    return isNegative ? "-\$$formatted" : "\$$formatted";
  }

  Future<Map<String, dynamic>?> fetchCompanyInfo(String ticker) async {
    final response = await http.get(
        Uri.parse('$apiUrl?function=OVERVIEW&symbol=$ticker&apikey=$apiKey'));

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
      List<Stock> targetList = isSearching ? filteredStocks : stocks;
      targetList[index].isFavorite = !targetList[index].isFavorite;

      if (targetList[index].isFavorite) {
        targetList.insert(0, targetList.removeAt(index));
      } else {
        int randomIndex = Random().nextInt(targetList.length);
        targetList.insert(randomIndex, targetList.removeAt(index));
      }

      if (isSearching) {
        int mainIndex = stocks.indexWhere((stock) => stock.ticker == targetList[index].ticker);
        if (mainIndex != -1) stocks[mainIndex].isFavorite = targetList[index].isFavorite;
      } else {
        filteredStocks = List.from(stocks);
      }
    });
  }

  String getStockRating(Map<String, dynamic> companyInfo) {
    double peRatio = double.tryParse(companyInfo["PERatio"] ?? "0") ?? 0;
    double marketCap =
        double.tryParse(companyInfo["MarketCap"]?.replaceAll(',', '') ?? "0") ??
            0;
    double ebitda =
        double.tryParse(companyInfo["EBITDA"]?.replaceAll(',', '') ?? "0") ?? 0;

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

  void applyFilter() {
    if (selectedFilter == 'All') {
      setState(() {
        filteredStocks = List.from(stocks); // Reset to all stocks
      });
      return;
    }

    setState(() {
      switch (selectedFilter) {
        case 'Gainers':
          filteredStocks = stocks.where((stock) => stock.percentChange > 0).toList();
          break;
        case 'Losers':
          filteredStocks = stocks.where((stock) => stock.percentChange < 0).toList();
          break;
        case 'Positive Change':
          filteredStocks = stocks.where((stock) => stock.delta > 0).toList();
          break;
        case 'Negative Change':
          filteredStocks = stocks.where((stock) => stock.delta < 0).toList();
          break;
      }
    });
  }
  void showFilterMenu(BuildContext context, Offset position) async {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position), // Position relative to tap
        Offset.zero & overlay.size,
      ),
      items: [
        PopupMenuItem(value: 'All', child: Text('Show All')),
        PopupMenuItem(value: 'Gainers', child: Text('Gainers')),
        PopupMenuItem(value: 'Losers', child: Text('Losers')),
        PopupMenuItem(value: 'Positive Change', child: Text('Positive Change')),
        PopupMenuItem(value: 'Negative Change', child: Text('Negative Change')),
      ],
    );

    if (result != null) {
      setState(() {
        selectedFilter = result;
        applyFilter(); // Apply filter ONLY when the user selects an option
      });
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
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.8,
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                stock.ticker,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        Divider(),

                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: rating.startsWith("🟢")
                            ? Colors.green[100]
                                : rating.startsWith("🟡")
                                ? Colors.yellow[100]
                                    : rating.startsWith("🔴")
                                    ? Colors.red[100]
                                    : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            "📊 Rating: $rating",
                            style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          width: double.infinity,
                          //width: 300,
                          child: StockChart(ticker: stock.name),
                        ),
                        Divider(),
                        Text(
                          '🏢 Industry: ${(companyInfo ?? {})["Industry"] ?? "N/A"}',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '💰 Market Cap: ${formatNumber((companyInfo ?? {})["MarketCap"])}',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '📊 EBITDA: ${formatNumber((companyInfo ?? {})["EBITDA"])}',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '📈 Revenue (TTM): ${formatNumber((companyInfo ?? {})["Revenue"])}',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        Text(
                          '🌍 About the Company:',
                          style:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          (companyInfo ?? {})["Description"] ??
                          "No Description Available",
                          textAlign: TextAlign.justify,
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildFilterDropdown() {
    return DropdownButton<String>(
      value: selectedFilter,
      onChanged: (String? newValue) {
        if (newValue != null) {
          setState(() {
            selectedFilter = newValue;
            applyFilter();
          });
        }
      },
      items: [
        'All',
        'Gainers',
        'Losers',
        'Positive Change',
        'Negative Change'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
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
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search stocks...',
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  searchController.clear();
                                  isSearching = false;
                                  filteredStocks = List.from(stocks);
                                });
                              },
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (query) {
                      setState(() {
                        isSearching = query.isNotEmpty;
                        filteredStocks = stocks
                            .where((stock) => stock.name.toLowerCase().contains(query.toLowerCase()) ||
                                              stock.ticker.toLowerCase().contains(query.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showFilterMenu(context, details.globalPosition);
                  },
                  child: ElevatedButton.icon(
                    onPressed: null,
                    icon: Icon(Icons.filter_list),
                    label: Text("Filter"),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: RefreshIndicator(
              onRefresh: fetchStockData,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: isSearching ? filteredStocks.length : stocks.length,
                      itemBuilder: (context, index) {
                        final stock = isSearching ? filteredStocks[index] : stocks[index];
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
                                  color: stock.percentChange >= 0
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                              Text(
                                ' (Δ${stock.delta})',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: stock.delta > 0
                                      ? Colors.green
                                      : stock.delta < 0
                                          ? Colors.red
                                          : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: Icon(stock.isFavorite
                                ? Icons.star
                                : Icons.star_border),
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
