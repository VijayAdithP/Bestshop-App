import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newbestshop/controllers/logout_controller.dart';
import 'package:get/get.dart';
import 'package:newbestshop/screens/stocks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'add_stock.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home_Page extends StatefulWidget {
  const Home_Page({super.key});
  @override
  State<Home_Page> createState() => _Home_PageState();
}

class _Home_PageState extends State<Home_Page> {
  int _currentTabIndex = 0;
  final screens = [
    const FlBarChartExample(),
    const Expandtile(),
    const stockadder(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
  String username = "";
  @override
  void initState() {
    super.initState();
    getEmailFromPrefs();
  }

  Future<void> getEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF4860b5),
            ),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: Text(
                  username,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          ListTile(
            title: const Text('Logout'),
            textColor: const Color.fromARGB(255, 0, 0, 0),
            onTap: () async {
              _logoutController.logout();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}

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
    Colors.blue,
  ];

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.dashboardData),
        headers: {'Authorization': 'Bearer $token'},
      );
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
        // print(token);
        throw Exception('Failed to load data from API');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  double _calculateMaxY(List<Map<String, dynamic>> data) {
    double max = 0;
    for (final item in data) {
      for (final key in _bottomTitles) {
        final num = double.tryParse(item[key].toString()) ?? 0;
        if (num > max) {
          max = num;
        }
      }
    }
    return max * 1.1;
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

    // if (_apiData == null || _axisNames == null || _bottomTitles == null) {
    //   return const Scaffold(
    //     body: Center(
    //       child: Text('Failed to fetch data from API'),
    //     ),
    //   );
    // }

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
              width: 60,
              borderRadius: BorderRadius.circular(3),
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
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (value) {
          if (value == 1) {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 2,
            );
          } 
          else {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 2,
            );
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(
            sideTitles: SideTitles(
          showTitles: false,
        )),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
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
                  top: 45, right: 70, left: 30, bottom: 10),
              child: BarChart(barChartData),
            ),
          ),
          const SizedBox(
            height: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  // radius: 6,
                  backgroundColor: Colors.red,
                ),
                Text(
                  "Product Count",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  // radius: 6,
                  backgroundColor: Colors.green,
                ),
                Text(
                  "Product Price",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                CircleAvatar(
                  // radius: 6,
                  backgroundColor: Colors.blue,
                ),
                Text(
                  "Rate of Product",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
              activeColor: const Color(0xFF4860b5),
              inactiveColor: const Color(0xFF4860b5),
              thumbColor: const Color(0xFF4860b5),
            ),
          ),
        ],
      ),
    );
  }

  double? calculateInterval(double maxY) {
    if (maxY <= 10) {
      return 1;
    } else if (maxY <= 100) {
      return 10;
    } else if (maxY <= 1000) {
      return 100;
    } else {
      return 1000;
    }
  }
}
