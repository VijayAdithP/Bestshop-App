import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class Expandtile extends StatefulWidget {
  const Expandtile({Key? key}) : super(key: key);

  @override
  State<Expandtile> createState() => _ExpandtileState();
}

Future<Map<String, List<Map<String, dynamic>>>> fetchStockItemsGroupedByShop(
    DateTime selectedDate) async {
  String formattedDate =
      "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
  String api =
      '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stockview}$formattedDate';

  try {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final response = await http.get(
      Uri.parse(api),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      Map<String, List<Map<String, dynamic>>> groupedItems = {};
      for (var item in jsonData) {
        String shop = item['shop'];
        if (!groupedItems.containsKey(shop)) {
          groupedItems[shop] = [];
        }
        groupedItems[shop]!.add(item);
      }
      return groupedItems;
    } else {
      throw Exception('Failed to load stock items: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load stock items: $e');
  }
}

class _ExpandtileState extends State<Expandtile> {
  late Future<Map<String, List<Map<String, dynamic>>>>? _futureStockItems;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton.icon(
                label: Text(
                  "Pick a date",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  // style: TextStyle(
                  //   fontSize: 20,
                  //   color: Colors.white,
                  //   fontWeight: FontWeight.w600,
                  // ),
                ),
                icon: const Icon(
                  Icons.edit_calendar,
                  color: Colors.white,
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide.none,
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(
                    const Color(0xFF4860b5),
                  ),
                ),
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (BuildContext context, Widget? child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Colors.white,
                            onPrimary: Color(0xFF4860b5),
                            onSurface: Color(0xFF4860b5),
                            onBackground: Color(0xFF4860b5),
                            // background: Colors.white,
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xFF4860b5),
                            ),
                          ),
                          textTheme: TextTheme(
                            headlineLarge:
                                Theme.of(context).textTheme.headlineLarge,
                            titleLarge:
                                Theme.of(context).textTheme.headlineLarge,
                            // labelSmall: AppTextStyle
                            //     .style14wBlueButton, // Title - SELECT DATE
                            // bodyLarge: AppTextStyle
                            //     .style14wBlueButton, // year gridbview picker
                            // titleMedium:
                            //     AppTextStyle.style14wBlueButton, // input
                            // titleSmall: AppTextStyle
                            //     .style14wBlueButton, // month/year picker
                            // bodySmall: AppTextStyle.style14wBlueButton // days
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                      _futureStockItems =
                          fetchStockItemsGroupedByShop(_selectedDate!);
                    });
                  }
                },
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            if (_selectedDate != null && _futureStockItems != null)
              Expanded(
                child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                  future: _futureStockItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final Map<String, List<Map<String, dynamic>>>
                          groupedItems = snapshot.data!;
                      final tableHeaders = [
                        'User',
                        'ID',
                        'Shop',
                        'Date',
                        'Time',
                        'Name',
                        'Model Name',
                        'Color Name',
                        'Size Name',
                        'Quantity',
                        'MRP',
                        'Total Price',
                      ];
                      return ListView(
                        children: groupedItems.keys.map((shop) {
                          return Card(
                            surfaceTintColor: Colors.white,
                            child: ExpansionTile(
                              shape: const Border(),
                              title: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  shop,
                                  style: GoogleFonts.poppins(
                                    // fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    // color: Colors.white,
                                  ),
                                ),
                              ),
                              children: [
                                SingleChildScrollView(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 1, left: 5, right: 5, bottom: 5),
                                      child: Table(
                                        defaultVerticalAlignment:
                                            TableCellVerticalAlignment.top,
                                        border:
                                            // const TableBorder(
                                            //   horizontalInside:
                                            //       BorderSide(color: Colors.grey),
                                            //   verticalInside: BorderSide.none,
                                            // ),
                                            TableBorder.all(
                                          color: Colors.grey,
                                          // style: BorderStyle.solid,
                                        ),
                                        columnWidths: const {
                                          0: FixedColumnWidth(100.0),
                                          1: FixedColumnWidth(100.0),
                                          2: FixedColumnWidth(100.0),
                                          3: FixedColumnWidth(100.0),
                                          4: FixedColumnWidth(100.0),
                                          5: FixedColumnWidth(350.0),
                                          6: FixedColumnWidth(100.0),
                                          7: FixedColumnWidth(100.0),
                                          8: FixedColumnWidth(100.0),
                                          9: FixedColumnWidth(100.0),
                                          10: FixedColumnWidth(100.0),
                                          11: FixedColumnWidth(100.0),
                                        },
                                        children: [
                                          TableRow(
                                            decoration: BoxDecoration(
                                              color: Colors.grey[300],
                                            ),
                                            children: tableHeaders
                                                .map(
                                                  (header) => TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        header,
                                                        style:
                                                            GoogleFonts.poppins(
                                                          // fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: const Color(
                                                              0xFF4860b5),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                                .toList(),
                                          ),
                                          ...groupedItems[shop]!.map(
                                            (item) {
                                              return TableRow(
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    bottom: BorderSide(
                                                        color: Colors.grey),
                                                  ),
                                                ),
                                                children: [
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['user']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['id']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['shop']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['date']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['time']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['name']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['model_name']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['color_name']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['size_name']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['quantity']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['mrp']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  TableCell(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Text(
                                                        item['total_price']
                                                                ?.toString() ??
                                                            '',
                                                        style:
                                                            GoogleFonts.poppins(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StockItem {
  final String? user;
  final String? id;
  final String? shop;
  final String? date;
  final String? time;
  final String? name;
  final String? model_name;
  final String? color_name;
  final String? size_name;
  final String? quantity;
  final String? mrp;
  final String? total_price;
  StockItem({
    this.user,
    this.id,
    this.shop,
    this.date,
    this.time,
    this.name,
    this.model_name,
    this.color_name,
    this.size_name,
    this.quantity,
    this.mrp,
    this.total_price,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      user: json['user'],
      id: json['id'],
      shop: json['shop'],
      date: json['date'],
      time: json['time'],
      name: json['name'],
      model_name: json['model_name'],
      color_name: json['color_name'],
      size_name: json['size_name'],
      quantity: json['quantity'],
      mrp: json['mrp'],
      total_price: json['total_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "id": id,
      "shop": shop,
      "date": date,
      "time": time,
      "name": name,
      "model_name": model_name,
      "color_name": color_name,
      "size_name": size_name,
      "quantity": quantity,
      "mrp": mrp,
      "total_price": total_price,
    };
  }
}
