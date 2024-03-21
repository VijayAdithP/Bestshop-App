import 'package:flutter/material.dart';
import 'package:newbestshop/models/data_table.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Expandtile extends StatefulWidget {
  const Expandtile({super.key});

  @override
  State<Expandtile> createState() => _ExpandtileState();
}

Future<List<Map<String, dynamic>>> fetchStockItems(
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
      print(token);
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.cast<Map<String, dynamic>>();
    } else {
      print(token);
      throw Exception('Failed to load stock items: ${response.statusCode}');
    }
  } catch (e) {
    throw Exception('Failed to load stock items: $e');
  }
}

class _ExpandtileState extends State<Expandtile> {
  late Future<List<Map<String, dynamic>>>? _futureStockItems;
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ElevatedButton.icon(
              label: const Text(
                "Pick a date",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
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
                );
                if (picked != null) {
                  setState(() {
                    _selectedDate = picked;
                    _futureStockItems = fetchStockItems(_selectedDate!);
                  });
                }
              },
              // child: const Text(
              //   "Pick a date",
              //   style: TextStyle(
              //     fontSize: 20,
              //     color: Colors.white,
              //     fontWeight: FontWeight.w600,
              //   ),
              // ),
            ),
          ),
          if (_selectedDate != null && _futureStockItems != null)
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _futureStockItems,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final List<Map<String, dynamic>> categorizedItems =
                        snapshot.data!;
                    return ListView(
                      children: categorizedItems.map((item) {
                        return ExpansionTile(
                          title: Text(item['shop'] ?? ''),
                          children: [
                            SingleChildScrollView(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: MyDataTable(
                                  categoryItems: [item],
                                ),
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    );
                  }
                },
              ),
            ),
        ],
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
