import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newbestshop/models/valuable-stock.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Valuablestock extends StatefulWidget {
  const Valuablestock({super.key});

  @override
  State<Valuablestock> createState() => _ValuablestockState();
}

class _ValuablestockState extends State<Valuablestock> {
  ValuableStock? valuableStock;
  String rank1Value = "";
  bool isLoading = true;
  List<StockPercentage> stockPercentages = [];

  @override
  void initState() {
    super.initState();
    fetchValuableStock();
  }

  Future<void> fetchValuableStock() async {
    final url = Uri.parse(
        ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.valuableStock);

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        url,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final data = ValuableStock.fromJson(jsonResponse);

        setState(() {
          valuableStock = data;
          if (data.rankedStocks != null && data.rankedStocks!.isNotEmpty) {
            rank1Value = "\₹${data.rankedStocks!.first.stockValue}";
            calculatePercentages(data.rankedStocks!);
          } else {
            rank1Value = "No data";
          }
          isLoading = false;
        });
      } else {
        setState(() {
          rank1Value = "Error";
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching stock data: $e");
      setState(() {
        rank1Value = "Error";
        isLoading = false;
      });
    }
  }

  void calculatePercentages(List<RankedStocks> stocks) {
    double totalValue = stocks.fold(0, (sum, stock) => sum + stock.stockValue!);

    List<StockPercentage> topStocks = stocks.take(3).map((stock) {
      double percentage = (stock.stockValue! / totalValue) * 100;
      return StockPercentage(
        title: getLastThreeSegments(stock.name!),
        percentage: percentage,
      );
    }).toList();

    double othersValue =
        stocks.skip(3).fold(0, (sum, stock) => sum + stock.stockValue!);
    if (othersValue > 0) {
      double othersPercentage = (othersValue / totalValue) * 100;
      topStocks.add(StockPercentage(
        title: "Others",
        percentage: othersPercentage,
      ));
    }

    setState(() {
      stockPercentages = topStocks;
    });
  }

  String getLastThreeSegments(String name) {
    List<String> segments = name.split('-');
    return segments.length >= 3
        ? segments.sublist(segments.length - 3).join('-')
        : name;
  }

  List<PieChartSectionData> prepareChartData(List<RankedStocks> stocks) {
    stocks.sort((a, b) => a.rank!.compareTo(b.rank!));

    List<PieChartSectionData> chartData = [];
    int othersValue = 0;

    List<Color> colors = [
      Colors.red,
      Colors.green,
      Colors.orange,
      Colors.grey,
    ];

    for (int i = 0; i < stocks.length; i++) {
      if (i < 3) {
        chartData.add(
          PieChartSectionData(
            title: "",
            value: stocks[i].stockValue!.toDouble(),
            color: colors[i],
            radius: 60,
          ),
        );
      } else {
        othersValue += stocks[i].stockValue!;
      }
    }

    if (othersValue > 0) {
      chartData.add(
        PieChartSectionData(
          title: "",
          value: othersValue.toDouble(),
          color: colors[3],
          radius: 60,
        ),
      );
    }
    return chartData;
  }

  List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.orange,
    Colors.grey,
  ];
  List<Color> colors1 = [
    Colors.red,
    Colors.green,
    Colors.orange,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: HexColor("#6A42C2"),
        title: Text(
          'Ranked Stocks',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 16,
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 5,
                      spreadRadius: -5,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Highest Value",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: HexColor("#8B5DFF"),
                        ),
                      ),
                      Text(
                        isLoading ? "Loading..." : rank1Value,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(
                        height: 300,
                        child: valuableStock != null && !isLoading
                            ? PieChart(
                                PieChartData(
                                  sections: prepareChartData(
                                      valuableStock!.rankedStocks!),
                                  centerSpaceRadius: 50,
                                  sectionsSpace: 2,
                                  borderData: FlBorderData(show: false),
                                ),
                              )
                            : Center(
                                child: isLoading
                                    ? const CircularProgressIndicator()
                                    : const Text('Error fetching data'),
                              ),
                      ),
                      Text(
                        "Stock Coverage:",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          color: HexColor("#6A42C2"),
                        ),
                      ),
                      stockPercentages.isEmpty
                          ? Text(
                              "No data available",
                              style: GoogleFonts.poppins(fontSize: 14),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...stockPercentages
                                            .asMap()
                                            .entries
                                            .map((entry) {
                                          int index = entry.key;
                                          StockPercentage stock = entry.value;
                                          Color color = index < colors.length
                                              ? colors[index]
                                              : colors.last;

                                          return Row(
                                            children: [
                                              Container(
                                                width: 12,
                                                height: 12,
                                                margin: const EdgeInsets.only(
                                                    right: 8),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: color,
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 4.0),
                                                child: Text(
                                                  stock.title,
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ],
                                          );
                                        })
                                      ]),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ...stockPercentages.map((stock) {
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4.0),
                                            child: Text(
                                              "${stock.percentage.toStringAsFixed(1)}%",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 14),
                                            ),
                                          );
                                        })
                                      ])
                                ])
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : valuableStock == null || valuableStock!.rankedStocks == null
                      ? const Center(child: Text("No data available"))
                      : SizedBox(
                          height: 700,
                          child: ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: valuableStock!.rankedStocks!.length,
                            itemBuilder: (context, index) {
                              final stock = valuableStock!.rankedStocks![index];
                              final isTopThree = index < 3;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: isTopThree
                                              ? Colors.grey
                                              : Colors.transparent,
                                          width: 1,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            if (isTopThree)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 10),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              100),
                                                      border: Border.all(
                                                        color: Colors.grey,
                                                      )),
                                                  child: CircleAvatar(
                                                    backgroundColor:
                                                        colors1[index]
                                                            .withOpacity(0.5),
                                                    radius: 15,
                                                    child: Text(
                                                      stock.id.toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.black),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            Flexible(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    stock.name ?? "Unknown",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 16,
                                                      fontWeight: isTopThree
                                                          ? FontWeight.w500
                                                          : FontWeight.normal,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Value: \$${stock.stockValue ?? 0}",
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 14,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    if (!isTopThree)
                                      const Divider(
                                        color: Colors.grey,
                                        height: 1,
                                        thickness: 1,
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
            )
          ],
        ),
      ),
    );
  }
}

class StockPercentage {
  final String title;
  final double percentage;

  StockPercentage({required this.title, required this.percentage});
}
