import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:newbestshop/models/valuable-stock.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Valuablestock extends StatefulWidget {
  const Valuablestock({super.key});

  @override
  State<Valuablestock> createState() => _ValuablestockState();
}

class _ValuablestockState extends State<Valuablestock> {
  @override
  void initState() {
    super.initState();
    fetchValuableStock();
  }

  Future<ValuableStock?> fetchValuableStock() async {
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
        return ValuableStock.fromJson(jsonResponse);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  // List<ChartData> prepareChartData(List<RankedStocks> stocks) {
  //   // Sort stocks by rank to identify top 3
  //   stocks.sort((a, b) => a.rank!.compareTo(b.rank!));

  //   List<ChartData> chartData = [];
  //   int othersValue = 0;

  //   // Add top 3 ranked stocks directly to chart data
  //   for (int i = 0; i < stocks.length; i++) {
  //     if (i < 3) {
  //       chartData
  //           .add(ChartData(stocks[i].name!, stocks[i].stockValue!.toDouble()));
  //     } else {
  //       othersValue += stocks[i].stockValue!;
  //     }
  //   }

  //   // Add the "Others" category
  //   if (othersValue > 0) {
  //     chartData.add(ChartData('Others', othersValue.toDouble()));
  //   }

  //   return chartData;
  // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Doughnut Chart')),
//       body: FutureBuilder<ValuableStock?>(
//         future: fetchValuableStock(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError ||
//               !snapshot.hasData ||
//               snapshot.data!.rankedStocks == null) {
//             return Center(child: Text('Error fetching data'));
//           } else {
//             // Prepare data for the chart
//             final chartData = prepareChartData(snapshot.data!.rankedStocks!);

//             return

//             SfCircularChart(
//               title: ChartTitle(text: 'Top 3 Stocks with Others'),
//               legend: Legend(isVisible: true, position: LegendPosition.bottom),
//               series: <CircularSeries>[
//                 DoughnutSeries<ChartData, String>(
//                   dataSource: chartData,
//                   xValueMapper: (ChartData data, _) => data.category,
//                   yValueMapper: (ChartData data, _) => data.value,
//                   dataLabelSettings: DataLabelSettings(isVisible: true),
//                 )
//               ],
//             );
//           }
//         },
//       ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("#6A42C2"),
        title: Text(
          'Ranked Stocks',
          style: GoogleFonts.poppins(
            // fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<ValuableStock?>(
        future: fetchValuableStock(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data'));
          } else if (!snapshot.hasData || snapshot.data?.rankedStocks == null) {
            return const Center(child: Text('No data available'));
          } else {
            List<RankedStocks> rankedStocks = snapshot.data!.rankedStocks!;
            return ListView.builder(
              itemCount: rankedStocks.length,
              itemBuilder: (context, index) {
                final stock = rankedStocks[index];
                return ListTile(
                  leading: Text(stock.rank.toString()),
                  title: Text(stock.name ?? 'No name'),
                  subtitle: Text(
                      'Quantity: ${stock.quantity}, Price: \$${stock.sellingPrice}'),
                  trailing: Text('Value: \$${stock.stockValue}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}

// class ChartData {
//   final String category;
//   final double value;

//   ChartData(this.category, this.value);
// }
