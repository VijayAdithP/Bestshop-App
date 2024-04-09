import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';

class ItemNamePage extends StatefulWidget {
  final int category_Id;
  final PageController controller;

  const ItemNamePage({required this.category_Id, required this.controller});

  @override
  _ItemNamePageState createState() => _ItemNamePageState();
}

class _ItemNamePageState extends State<ItemNamePage> {
  late String _token;
  late List<apidata> _itemNames;
  late List<apidata> _filteredItemNames;
  bool _isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _filteredItemNames = [];
    _fetchTokenAndItemNames();
  }

  Future<void> _fetchTokenAndItemNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    _fetchItemNames();
  }

  Future<void> _fetchItemNames() async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.itemname}${widget.category_Id}');
      final response = await http.get(
        apiUri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _itemNames = data.map((item) => apidata.fromJson(item)).toList();
          _filteredItemNames = _itemNames;
          _isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  void _searchItem(String query) {
    setState(() {
      searchQuery = query;
      _filteredItemNames = _itemNames
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 40,
                  child: TextFormField(
                    onChanged: _searchItem,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(5),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 1.5,
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search...',
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: 55,
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 180,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: _filteredItemNames.length,
                    itemBuilder: (context, index) {
                      final itemName = _filteredItemNames[index];
                      return GestureDetector(
                        onTap: () async {
                          widget.controller.animateToPage(2,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('selectedsubcategoryname');
                          prefs.remove('selectedbrandname');

                          prefs.setInt('selecteditemnameId', itemName.id);
                          prefs.setString('selecteditemname', itemName.name);
                          prefs.setString(
                              'selecteditemnameImg', itemName.imagePath);
                        },
                        child: Card(
                          surfaceTintColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          margin: const EdgeInsets.all(10),
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                      '${ApiEndPoints.baseUrl}/${itemName.imagePath}'),
                                ),
                                Text(
                                  itemName.name,
                                  style: const TextStyle(fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
