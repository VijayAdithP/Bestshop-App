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
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

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
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4860b5),
        //  backgroundColor: Colors.grey.shade300,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey.shade300,
        selectedLabelStyle: GoogleFonts.poppins(
          // fontSize: 24,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          // fontSize: 24,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.grey.shade300,
            icon: const Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey.shade300,
            icon: const Icon(Icons.inventory),
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.grey.shade300,
            icon: const Icon(Icons.shopping_cart),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                      "https://st3.depositphotos.com/6672868/13701/v/450/depositphotos_137014128-stock-illustration-user-profile-icon.jpg"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    username,
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text(
              'Logout',
              style: GoogleFonts.poppins(
                // fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF4860b5),
              ),
            ),
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
  // int _selectedIntervalIndex = 0;
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
    return max * 1.2;
  }

  final PageController _pageController = PageController(initialPage: 0);
  int currentpage = 0;
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),

        // Define how the card's content should be clipped
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Expanded(
              child: Container(
                // margin: const EdgeInsets.only(right: 60),
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Padding(
                  padding: EdgeInsets.only(
                      top: 5,
                      right: 30,
                      left: 10,
                      bottom: MediaQuery.of(context).size.height * 0.021),
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (int page) {
                      setState(() {
                        currentpage = page;
                      });
                    },
                    scrollDirection: Axis.horizontal,
                    itemCount: _axisNames!.length,
                    itemBuilder: (context, index) {
                      return buildPage(index);
                    },
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List<Widget>.generate(
                  _axisNames!.length,
                  (index) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        _pageController.animateToPage(index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn);
                      },
                      child: CircleAvatar(
                        radius: 5,
                        backgroundColor:
                            currentpage == index ? Colors.blue : Colors.grey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 5,
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    // radius: ,
                    backgroundColor: Colors.red,
                  ),
                  Text(
                    "Product Count",
                    // style: TextStyle(
                    //   fontSize: 10,
                    //   fontWeight: FontWeight.w500,
                    // ),
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.green,
                  ),
                  Text(
                    "Product Price",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const CircleAvatar(
                    backgroundColor: Colors.blue,
                  ),
                  Text(
                    "Rate of Product",
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // SliderTheme(
            //   data: SliderThemeData(
            //     activeTrackColor: const Color(0xFF4860b5),
            //     inactiveTrackColor: Colors.grey[300],
            //     trackShape: const RoundedRectSliderTrackShape(),
            //     trackHeight: 30,
            //     thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            //     thumbColor: const Color(0xFF4860b5),
            //     overlayColor: Colors.transparent,
            //     overlayShape: const RoundSliderOverlayShape(overlayRadius: 28.0),
            //     tickMarkShape: const RoundSliderTickMarkShape(),
            //     activeTickMarkColor: const Color(0xFF4860b5),
            //     inactiveTickMarkColor: Colors.transparent,
            //     valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
            //     valueIndicatorColor: const Color(0xFF4860b5),
            //     valueIndicatorTextStyle: const TextStyle(
            //       color: Colors.white,
            //     ),
            //   ),
            //   child: Slider(
            //     value: _selectedIntervalIndex.toDouble(),
            //     min: 0,
            //     max: _axisNames!.length.toDouble() - 1,
            //     onChanged: (value) {
            //       setState(() {
            //         _selectedIntervalIndex = value.toInt();
            //       });
            //     },
            //     divisions: _axisNames!.length - 1,
            //     label: _axisNames![_selectedIntervalIndex],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildPage(int index) {
    final barGroups = <BarChartGroupData>[
      BarChartGroupData(
        x: 1,
        barRods: [
          for (int i = 0; i < _bottomTitles.length; i++)
            BarChartRodData(
              toY: double.tryParse(
                      _apiData![index][_bottomTitles[i]].toString()) ??
                  0,
              color: _barColors[i % _barColors.length],
              width: 65,
              borderRadius: BorderRadius.circular(3),
            ),
        ],
      ),
    ];

    final barChartData = BarChartData(
      maxY: _maxY,
      minY: 0,
      barGroups: barGroups,
      backgroundColor: Colors.transparent,
      baselineY: 0.00000000000001,
      barTouchData: BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (BarChartGroupData group) => Colors.white,
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
          } else {
            return const FlLine(
              color: Colors.grey,
              strokeWidth: 2,
            );
          }
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 6,
          ),
        ),
        rightTitles:  AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, meta) {
              return const Text(
                ""
                // value.toInt().toString(),
                // textAlign: TextAlign.left,
              );
            },
            // reservedSize: 55,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: (value, titleMeta) {
              if (value.toInt() == 1) {
                return Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    _axisNames![index],
                    // style: const TextStyle(
                    //   fontSize: 20,
                    //   color: Colors.grey,
                    //   fontWeight: FontWeight.w500,
                    // ),
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }
              return const Text("safety");
            },
            reservedSize: 45,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            // getTitlesWidget: (value, meta) {
            //   return Text(
            //     value.toInt().toString(),
            //     // textAlign: TextAlign.left,
            //     style: GoogleFonts.poppins(
            //       // fontSize: 20,
            //       // color: Colors.grey,
            //       fontWeight: FontWeight.w500,
            //     ),
            //   );
            // },
            showTitles: true,
            reservedSize: 55,
          ),
        ),
      ),
      alignment: BarChartAlignment.center,
    );

    return BarChart(barChartData);
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
