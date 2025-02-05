import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String apiKey = 'OYNU1LA5APCCQ1I5';
const String apiUrl = 'https://www.alphavantage.co/query';

class StockChart extends StatefulWidget {
  final String ticker;

  StockChart({required this.ticker});

  @override
  _StockChartState createState() => _StockChartState();
}

class _StockChartState extends State<StockChart> {
  List<FlSpot> chartData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchChartData();
  }

  Future<void> fetchChartData() async {
    final response = await http.get(
      Uri.parse('$apiUrl?function=TIME_SERIES_INTRADAY&symbol=${widget.ticker}&interval=5min&apikey=$apiKey')
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final timeSeries = data["Time Series (5min)"];

      if (timeSeries != null) {
        List<FlSpot> spots = [];
        int index = 0;

        timeSeries.forEach((time, values) {
          double price = double.tryParse(values["1. open"]) ?? 0.0;
          spots.add(FlSpot(index.toDouble(), price));
          index++;
        });

        setState(() {
          chartData = spots.reversed.toList();
          isLoading = false;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      width: double.infinity,
      child: isLoading
          ? Center(child: CircularProgressIndicator())
          : LineChart(
              LineChartData(
                titlesData: FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: chartData,
                    isCurved: true,
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.blueAccent],
                    ),
                    barWidth: 2,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
            ),
    );
  }
}
