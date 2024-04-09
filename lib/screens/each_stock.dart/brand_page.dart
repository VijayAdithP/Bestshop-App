import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';

class brandPage extends StatefulWidget {
  final int brandId;
  final PageController controller;

  const brandPage({required this.brandId, required this.controller});

  @override
  _brandPageState createState() => _brandPageState();
}

class _brandPageState extends State<brandPage> {
  late String _token;
  late List<apidata> _brand;
  bool _isLoading = true;
  late List<apidata> filteredItemNames;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchTokenAndbrand();
    filteredItemNames = [];
  }

  Future<void> _fetchTokenAndbrand() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    _fetchbrand();
  }

  Future<void> _fetchbrand() async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.brand}${widget.brandId}');
      final response = await http.get(
        apiUri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _brand = data.map((item) => apidata.fromJson(item)).toList();
          filteredItemNames = _brand;
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
      filteredItemNames = _brand
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
        alignment: Alignment.topCenter,
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
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 180,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    itemCount: filteredItemNames.length,
                    itemBuilder: (context, index) {
                      final brand = filteredItemNames[index];
                      return GestureDetector(
                        onTap: () async {
                          widget.controller.animateToPage(4,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeIn);

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setInt('selectedbrandId', brand.id);
                          prefs.setString('selectedbrandname', brand.name);
                          prefs.setString('selectedbrandImg', brand.imagePath);

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MyHomePage(
                          //       modelId: brand.id,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Card(
                          surfaceTintColor: Colors.white,

                          // child: ListTile(
                          //   title: Text(category.name),
                          //   leading: Image.network(
                          //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                          // ),
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
                                        '${ApiEndPoints.baseUrl}/${brand.imagePath}')),
                                Text(
                                  brand.name,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}
