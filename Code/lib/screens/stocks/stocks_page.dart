import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:fintrackr/screens/stocks/stock_chart.dart';
import 'dart:convert';
import 'dart:math';

import '../ui_elements/header.dart';
import '../ui_elements/launch_url.dart';

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
  bool isFiltering = false;
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
        int mainIndex = stocks
            .indexWhere((stock) => stock.ticker == targetList[index].ticker);
        if (mainIndex != -1)
          stocks[mainIndex].isFavorite = targetList[index].isFavorite;
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
        isFiltering = false;
        filteredStocks = List.from(stocks);
      });
      return;
    }

    setState(() {
      isFiltering = true;
      switch (selectedFilter) {
        case 'Gainers':
          filteredStocks =
              stocks.where((stock) => stock.percentChange > 0).toList();
          break;
        case 'Losers':
          filteredStocks =
              stocks.where((stock) => stock.percentChange < 0).toList();
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
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final result = await showMenu<String>(
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromPoints(position, position),
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
        isFiltering = result != 'All';
        applyFilter();
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
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
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
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18),
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
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '💰 Market Cap: ${formatNumber((companyInfo ?? {})["MarketCap"])}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '📊 EBITDA: ${formatNumber((companyInfo ?? {})["EBITDA"])}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '📈 Revenue (TTM): ${formatNumber((companyInfo ?? {})["Revenue"])}',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                        Divider(),
                        Text(
                          '🌍 About the Company:',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.bold),
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
      items: ['All', 'Gainers', 'Losers', 'Positive Change', 'Negative Change']
          .map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }

  void _showMoreInfoPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InfoPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(FontAwesomeIcons.circleInfo),
            onPressed: () {
              _showMoreInfoPage();
            },
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
                        if (isFiltering) {
                          filteredStocks = stocks
                              .where((stock) =>
                                  stock.name
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  stock.ticker
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                              .toList();
                        } else {
                          filteredStocks = stocks
                              .where((stock) =>
                                  stock.name
                                      .toLowerCase()
                                      .contains(query.toLowerCase()) ||
                                  stock.ticker
                                      .toLowerCase()
                                      .contains(query.toLowerCase()))
                              .toList();
                        }
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      itemCount: isFiltering
                          ? filteredStocks.length
                          : isSearching
                              ? filteredStocks.length
                              : stocks.length,
                      itemBuilder: (context, index) {
                        final stock = isFiltering
                            ? filteredStocks[index]
                            : isSearching
                                ? filteredStocks[index]
                                : stocks[index];
                        return ListTile(
                          title: Text('${stock.name}',
                              style: TextStyle(fontWeight: FontWeight.bold)),
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

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset('assets/debt-info-page.png', height: 200, width: 200),
              Header(text: 'Helpful Links & Information'),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Disclaimer: ',
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    const TextSpan(
                      text:
                          'We are not providing any recommendations on buying/selling stocks. All the information displayed here is representational and for demonstration purposes only.\n\n',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const TextSpan(
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 18),
                        text:
                            'Investing in stocks carries risks, as the value of a stock can decrease, and investors could lose money!')
                  ],
                ),
              ),
              SizedBox(height: 50),
              Text('What Are Stocks?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 15),
              Text(
                  'Stocks, also known as shares or equities, represent ownership in a company, and when you buy stock, you become a shareholder with a stake in the company\'s assets and potential profits.\n\nWhen a company issues stock, it\'s essentially selling a piece of itself to investors. Investors who purchase these shares become shareholders, meaning they have a claim on the company\'s assets and profits.'),
              SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://www.schwab.com/stocks/understand-stocks'),
                child: const Text(
                  'What are Stocks?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://www.investor.gov/introduction-investing/investing-basics/investment-products/stocks'),
                child: const Text(
                  'INVESTOR.GOV - What Are Stocks?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://www.td.com/ca/en/investing/direct-investing/articles/what-is-stock-market'),
                child: const Text(
                  'Stock Market 101',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () => launchURL(
                    'https://www.rbcgam.com/en/ca/learn-plan/investment-basics/what-are-stocks-and-how-do-they-work/detail'),
                child: const Text(
                  'What Are Stocks & How Do They Work?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              Text('Want to Learn More About Stocks?',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://dfi.wa.gov/financial-education/information/basics-investing-stocks'),
                child: const Text(
                  'Basics of Investing in Stocks',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () =>
                    launchURL('https://n26.com/en-eu/blog/what-are-stocks'),
                child: const Text(
                  'What Are Stocks - A Walkthrough For Beginner Investors',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.getsmarteraboutmoney.ca/learning-path/getting-started/how-the-stock-market-works/'),
                child: const Text(
                  'How The Stock Market Works',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://finred.usalearning.gov/Saving/StocksBondsMutualFunds'),
                child: const Text(
                  'Investing Basics',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.usbank.com/investing/financial-perspectives/investing-insights/how-do-i-invest-in-stocks.html'),
                child: const Text(
                  'How Do I Invest In Stocks?',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.nerdwallet.com/article/investing/how-to-invest-in-stocks'),
                child: const Text(
                  'How To Invest In Stocks - Beginner\'s Guide',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.schwab.com/learn/story/stock-investment-tips-beginners'),
                child: const Text(
                  'Stock Market Tips For Beginners',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.sec.gov/investor/pubs/tenthingstoconsider.htm'),
                child: const Text(
                  '10 Things To Consider Before Making Investing Decisions',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.lloydsbank.com/investing/understanding-investing/investing-for-beginners.html'),
                child: const Text(
                  'Investing For Beginners',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () => launchURL(
                    'https://www.investopedia.com/articles/basics/06/invest1000.asp'),
                child: const Text(
                  'How To Start Investing in Stocks in 2025 and Beyond',
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              SizedBox(height: 50),
              RichText(
                text: TextSpan(
                  children: [
                    const TextSpan(
                      text: 'More information is just a simple ',
                      style: TextStyle(color: Colors.black),
                    ),
                    TextSpan(
                      text: 'Google Search',
                      style: const TextStyle(
                        color: Colors.blue,
                        decoration: TextDecoration.underline,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => launchURL(
                            'https://www.google.com/search?q=stock+market+investment&sca_esv=cd731438e95bc999&biw=1728&bih=992&sxsrf=AHTn8zo2lbr6IkgFxTa6kvaSgFg2w7pgtQ%3A1743541666414&ei=olXsZ7-AGYz8ptQPn6bXyQU&ved=0ahUKEwi_2bXt3reMAxUMvokEHR_TNVk4HhDh1QMIEA&oq=stock+market+investment&gs_lp=Egxnd3Mtd2l6LXNlcnAiF3N0b2NrIG1hcmtldCBpbnZlc3RtZW50SABQAFgAcAB4AJABAJgBAKABAKoBALgBDMgBAJgCAKACAJgDAJIHAKAHAA&sclient=gws-wiz-serp'),
                    ),
                    const TextSpan(
                      text: ' a simple Google Search away!\n\n',
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
