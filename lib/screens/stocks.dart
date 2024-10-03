import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/models/locationModel.dart';
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class Expandtile extends StatefulWidget {
  const Expandtile({super.key});

  @override
  State<Expandtile> createState() => _ExpandtileState();
}

class _ExpandtileState extends State<Expandtile> {
  @override
  void initState() {
    super.initState();
    _futureStockItems = fetchStockItemsGroupedByShop(_selectedDate!);
    getShopLocation();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchStockItemsGroupedByShop(
      DateTime selectedDate) async {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    String api = 
    // selectedShopIds.isEmpty
        // ?
         '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stockview}$formattedDate';
        // : '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stockview}$formattedDate&shop_location=$selectedLocationId';

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      print(token);
      final response = await http.get(
        Uri.parse(api),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
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

  Future<void> getShopLocation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    try {
      final response = await http.get(
        Uri.parse(
            ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getLocation),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          locations = data.map((shop) => Location.fromJson(shop)).toList();
        });
      } else {
        throw Exception('Failed to load shop locations');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> downloadCsvFile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    String formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";
    try {
      if (await _requestStoragePermission()) {}
      final Uri uri = Uri.parse(
              ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.downloadCSV)
          .replace(
        queryParameters: {
          'date': formattedDate,
          'shop_location': selectedShopIds.toList(),
        },
      );

      final response =
          await http.get(uri, headers: {'Authorization': 'Bearer $token'});

      if (response.statusCode == 200) {
        final directory = await getExternalStorageDirectory();
        final filePath = '${directory!.path}/exported_stock.csv';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                Text(e.toString()),
              ],
            );
          });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else {
      print('Storage permission denied.');
    }

    return false;
  }

  late Future<Map<String, List<Map<String, dynamic>>>>? _futureStockItems;
  DateTime? _selectedDate = DateTime.now();
  List<Location> locations = [];
  Set<String> selectedShopIds = {};
  int? selectedLocationId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inventory",
          style: GoogleFonts.poppins(
            // fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF4860b5),
        actions: [
          GestureDetector(
            onTap: downloadCsvFile,
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Icon(
                Icons.download,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locations.isNotEmpty
                ? Wrap(
                    spacing: 8.0,
                    runSpacing: 4.0,
                    children: locations
                        .map((shop) => ChoiceChip(
                              label: Text(shop.name!),
                              selected: selectedLocationId == shop.id,
                              onSelected: (bool selected) {
                                setState(() {
                                  selectedLocationId =
                                      selected ? shop.id : null;
                                });
                                _futureStockItems =
                                    fetchStockItemsGroupedByShop(
                                        _selectedDate!);
                              },
                            ))
                        .toList(),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton.icon(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pick a date",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (_selectedDate != null)
                        FittedBox(
                          child: Text(
                            DateFormat.yMEd().format(_selectedDate!),
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  icon: const Icon(
                    Icons.edit_calendar,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
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
                              // onBackground: Color(0xFF4860b5),
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
            ),
            const SizedBox(
              height: 5,
            ),
            // if (_futureStockItems == null)
            if (_selectedDate != null && _futureStockItems != null)
              Expanded(
                child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                  future: _futureStockItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (_futureStockItems == null) {
                      return const Text("no data");
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
                            color: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 0,
                            surfaceTintColor: Colors.white,
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              shape: const Border(),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  shop,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SingleChildScrollView(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1,
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                        ),
                                        child: DataTable(
                                          // border: TableBorder(
                                          //   verticalInside: BorderSide(
                                          //     color: Colors.grey[400]!,
                                          //   ),
                                          // ),
                                          columnSpacing: 30.0,
                                          horizontalMargin: 12.0,
                                          dataRowMaxHeight: 70,
                                          columns: tableHeaders
                                              .map(
                                                (header) => DataColumn(
                                                  label: Text(
                                                    header,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xFF4860b5),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          rows: groupedItems[shop]!.map((item) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(
                                                    item['user']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['id']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['shop']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['date']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['time']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['name']?.toString() ??
                                                        '')),
                                                DataCell(Text(item['model_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['color_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['size_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['quantity']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(
                                                    item['mrp']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['total_price']
                                                            ?.toString() ??
                                                        '')),
                                              ],
                                            );
                                          }).toList(),
                                        ),
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
