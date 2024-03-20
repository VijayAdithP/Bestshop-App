import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newbestshop/controllers/logout_controller.dart';
import 'package:get/get.dart';
import 'package:newbestshop/screens/stocks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'add_stock.dart';
import 'package:fl_chart/fl_chart.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  // @override
  // void initState() {
  //   super.initState();
  //   fetchData();
  // }

  int _currentTabIndex = 0;
  final screens = [
    const FlBarChartExample(),
    const Expandtile(),
    CategoryPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,

      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4860b5),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Add Stocks',
          ),
        ],
        currentIndex: _currentTabIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
      drawer: const Drawer_(),
      body: screens[_currentTabIndex],

      // Center(
      //   child: SubscriberChart(
      //     data: data,
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: const Color(0xFF4860b5),
      //   onPressed: () {
      //     setState(() {
      //       fetchDataFromAPI();
      //     });
      //   },
      //   child: const Icon(Icons.update, color: Colors.white, size: 28),
      // ),
    );
  }
}

class Drawer_ extends StatefulWidget {
  const Drawer_({super.key});
  @override
  State<Drawer_> createState() => _Drawer_State();
}

class _Drawer_State extends State<Drawer_> {
  final LogoutController _logoutController = Get.put(LogoutController());
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFF4860b5),
            ),
            child: Text(''),
          ),
          ListTile(
            title: const Text('DashBoard'),
            textColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: () {
              Get.off(() => Home_Page());
            },
          ),
          ListTile(
            title: const Text('Stocks'),
            textColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const Expandtile(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Add Stocks'),
            textColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CategoryPage(),
                ),
              );
            },
          ),
          const SizedBox(
            height: 270,
          ),
          const Divider(),
          ListTile(
            title: const Text('Logout'),
            textColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: () async {
              _logoutController.logout();
            },
          ),
        ],
      ),
    );
  }
}

// class FlBarChartExample extends StatefulWidget {
//   const FlBarChartExample({super.key});

//   @override
//   FlBarChartExampleState createState() => FlBarChartExampleState();
// }

// class FlBarChartExampleState extends State<FlBarChartExample> {
//   List<String>? _apiData;
//   String? _axisName;
//   bool _isLoading = true;
//   double _maxY = 25;

//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromAPI();
//   }

//   Future<void> fetchDataFromAPI() async {
//     try {
//       final response = await http.get(Uri.parse(
//           ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.dashboardData));
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body)['series'][0];
//         setState(
//           () {
//             _apiData = List<String>.from(jsonData['data']);
//             _axisName = jsonData['name'];
//             _maxY = _calculateMaxY(_apiData!);
//             _isLoading = false;
//           },
//         );
//       } else {
//         throw Exception('Failed to load data from API');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   double _calculateMaxY(List<String> data) {
//     double max = 0;
//     for (String value in data) {
//       double num = double.tryParse(value) ?? 0;
//       if (num > max) {
//         max = num;
//       }
//     }
//     return max * 1.2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: const Center(
//           child: CircularProgressIndicator(),
//         ),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor: const Color(0xFF4860b5),
//           onPressed: () async {
//             setState(() {
//               fetchDataFromAPI();
//             });
//           },
//           child: const Icon(Icons.update, color: Colors.white, size: 28),
//         ),
//       );
//     }

//     if (_apiData == null || _axisName == null) {
//       return const Scaffold(
//         body: Center(
//           child: Text('Failed to fetch data from API'),
//         ),
//       );
//     }

//     final barGroups = <BarChartGroupData>[
//       for (int i = 0; i < _apiData!.length; i++)
//         BarChartGroupData(
//           x: i + 1,
//           barRods: [
//             BarChartRodData(
//               toY: double.tryParse(_apiData![i]) ?? 0,
//               color: Colors.blue,
//               width: 50,
//               borderRadius: BorderRadius.circular(0),
//             ),
//           ],
//         ),
//     ];

//     final barChartData = BarChartData(
//       maxY: _maxY,
//       minY: 0,
//       barGroups: barGroups,
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey,
//         ),
//       ),
//       borderData: FlBorderData(show: true),
//       gridData: const FlGridData(show: false),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (value, titleMeta) {
//               return Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Text(
//                   _axisName!,
//                   style: const TextStyle(
//                       fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               );
//             },
//             reservedSize: 22,
//           ),
//         ),
//       ),
//     );

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         child: BarChart(barChartData),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF4860b5),
//         onPressed: () {
//           setState(() {
//             fetchDataFromAPI();
//           });
//         },
//         child: const Icon(Icons.update, color: Colors.white, size: 28),
//       ),
//     );
//   }
// }

// class FlBarChartExample extends StatefulWidget {
//   const FlBarChartExample({Key? key}) : super(key: key);

//   @override
//   FlBarChartExampleState createState() => FlBarChartExampleState();
// }

// class FlBarChartExampleState extends State<FlBarChartExample> {
//   List<Map<String, dynamic>>? _apiData;
//   List<String>? _axisNames;
//   List<String>? _bottomTitles;
//   bool _isLoading = true;
//   double _maxY = 25;

//   @override
//   void initState() {
//     super.initState();
//     fetchDataFromAPI();
//   }

//   Future<void> fetchDataFromAPI() async {
//     try {
//       final response = await http.get(Uri.parse(
//           ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.dashboardData));
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body) as List<dynamic>;
//         setState(() {
//           _apiData = List<Map<String, dynamic>>.from(jsonData);
//           _axisNames =
//               _apiData!.map((data) => data['time_interval'] as String).toList();
//           _bottomTitles = [
//             'total_quantity',
//             'total_price',
//             'rate_of_product',
//           ];
//           _maxY = _calculateMaxY(_apiData!);
//           _isLoading = false;
//         });
//       } else {
//         throw Exception('Failed to load data from API');
//       }
//     } catch (e) {
//       print('Error fetching data: $e');
//     }
//   }

//   double _calculateMaxY(List<Map<String, dynamic>> data) {
//     double max = 0;
//     for (final item in data) {
//       for (final key in _bottomTitles!) {
//         final num = double.tryParse(item[key].toString()) ?? 0;
//         if (num > max) {
//           max = num;
//         }
//       }
//     }
//     return max * 1.2;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Scaffold(
//         body: Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     }

//     if (_apiData == null || _axisNames == null || _bottomTitles == null) {
//       return Scaffold(
//         body: Center(
//           child: Text('Failed to fetch data from API'),
//         ),
//       );
//     }

//     final barGroups = <BarChartGroupData>[
//       for (int i = 0; i < _apiData!.length; i++)
//         BarChartGroupData(
//           x: i,
//           barRods: [
//             for (final key in _bottomTitles!)
//               BarChartRodData(
//                 toY: double.tryParse(_apiData![i][key].toString()) ?? 0,
//                 color: Colors.blue,
//                 width: 50,
//                 borderRadius: BorderRadius.circular(0),
//               ),
//           ],
//         ),
//     ];

//     final barChartData = BarChartData(
//       maxY: _maxY,
//       minY: 0,
//       barGroups: barGroups,
//       barTouchData: BarTouchData(
//         enabled: true,
//         touchTooltipData: BarTouchTooltipData(
//           tooltipBgColor: Colors.blueGrey,
//         ),
//       ),
//       borderData: FlBorderData(show: true),
//       gridData: const FlGridData(show: false),
//       titlesData: FlTitlesData(
//         show: true,
//         bottomTitles: AxisTitles(
//           sideTitles: SideTitles(
//             showTitles: true,
//             getTitlesWidget: (value, titleMeta) {
//               if (value.toInt() >= 0 && value.toInt() < _axisNames!.length) {
//                 return Padding(
//                   padding: const EdgeInsets.all(0),
//                   child: Text(
//                     _axisNames![value.toInt()],
//                     style: const TextStyle(
//                         fontSize: 10, fontWeight: FontWeight.bold),
//                   ),
//                 );
//               }
//               return const Text("safety");
//             },
//             reservedSize: 22,
//           ),
//         ),
//       ),
//     );

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(8),
//         child: BarChart(barChartData),
//       ),
//       floatingActionButton: FloatingActionButton(
//         backgroundColor: const Color(0xFF4860b5),
//         onPressed: () {
//           setState(() {
//             fetchDataFromAPI();
//           });
//         },
//         child: const Icon(Icons.update, color: Colors.white, size: 28),
//       ),
//     );
//   }
// }

class FlBarChartExample extends StatefulWidget {
  const FlBarChartExample({Key? key}) : super(key: key);

  @override
  FlBarChartExampleState createState() => FlBarChartExampleState();
}

class FlBarChartExampleState extends State<FlBarChartExample> {
  List<Map<String, dynamic>>? _apiData;
  List<String>? _axisNames;
  late List<String> _bottomTitles;
  int _selectedIntervalIndex = 0;
  bool _isLoading = true;
  double _maxY = 25;
  final List<Color> _barColors = [
    Colors.red,
    Colors.green,
    Colors.blue, // Add more colors as needed
  ];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await http.get(Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.dashboardData));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body) as List<dynamic>;
        setState(() {
          _apiData = List<Map<String, dynamic>>.from(jsonData);
          _axisNames =
              _apiData!.map((data) => data['time_interval'] as String).toList();
          _bottomTitles = ['total_quantity', 'total_price', 'rate_of_product'];
          _maxY = _calculateMaxY(_apiData!);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  double _calculateMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (final item in data) {
      for (final key in _bottomTitles!) {
        final num = double.tryParse(item[key].toString()) ?? 0;
        if (num > max) {
          max = num;
        }
      }
    }
    return max * 1;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_apiData == null || _axisNames == null || _bottomTitles == null) {
      return const Scaffold(
        body: Center(
          child: Text('Failed to fetch data from API'),
        ),
      );
    }

    final barGroups = <BarChartGroupData>[
      BarChartGroupData(
        x: 1,
        barRods: [
          for (int i = 0; i < _bottomTitles.length; i++)
            BarChartRodData(
              toY: double.tryParse(_apiData![_selectedIntervalIndex]
                          [_bottomTitles[i]]
                      .toString()) ??
                  0,
              color: _barColors[i % _barColors.length],
              width: 50,
              borderRadius: BorderRadius.circular(0),
            ),
        ],
      ),
    ];

    final barChartData = BarChartData(
      maxY: _maxY,
      minY: 0,
      barGroups: barGroups,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBorder: const BorderSide(
            color: Colors.blue,
          ),
          tooltipBgColor: Colors.white,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      gridData: const FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: const AxisTitles(
            sideTitles: SideTitles(
          // interval: calculateInterval(_maxY),
          showTitles: false,
        )),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, titleMeta) {
              if (value.toInt() == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Text(
                    _axisNames![_selectedIntervalIndex],
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text("safety");
            },
            reservedSize: 40,
          ),
        ),
      ),
    );

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 50, right: 70, left: 30, bottom: 10),
              child: BarChart(barChartData),
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 30),
              trackShape: const RectangularSliderTrackShape(),
            ),
            child: Slider(
              value: _selectedIntervalIndex.toDouble(),
              min: 0,
              max: _axisNames!.length.toDouble() - 1,
              onChanged: (value) {
                setState(() {
                  _selectedIntervalIndex = value.toInt();
                });
              },
              divisions: _axisNames!.length - 1,
              label: _axisNames![_selectedIntervalIndex],
              activeColor: Colors.blue,
              inactiveColor: Colors.blue,
              thumbColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  double? calculateInterval(double maxY) {
    if (maxY <= 10) {
      return 1; // Change to 0.1 if you want decimal intervals
    } else if (maxY <= 100) {
      return 10; // Change to 1 if you want decimal intervals
    } else if (maxY <= 1000) {
      return 100; // Change to 10 if you want decimal intervals
    } else {
      return 1000; // Change to 100 if you want decimal intervals
    }
  }
}