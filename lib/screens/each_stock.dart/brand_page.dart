import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/models/menuEnumModel.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/deleteProduct.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/floatingbutton.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/updateProduct.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController editBrandController = TextEditingController();
  TextEditingController addBrandCategoryController = TextEditingController();

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

  Future<void> updateBrand(String? brand, int? brandId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.brand}${widget.brandId}');
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": brandId,
            "name": brand,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchbrand();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> addBrand(String? brand) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.brand}${widget.brandId}');
      final response = await http.post(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "sub_category": widget.brandId,
            "name": brand,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchbrand();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deleteBrand(int? brandId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.brand}${widget.brandId}');
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": brandId,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchbrand();
        Navigator.of(context).pop();
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
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(72, 96, 181, 1),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return FloatingButton(
                  controller: addBrandCategoryController,
                  function: (brandName) {
                    addBrand(brandName);
                  },
                  titleText: "Add Item",
                  hintText: "Enter Item name",
                );
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  onChanged: _searchItem,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.5,
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    prefixIcon: Icon(Icons.search),
                    hintText: 'Search...',
                  ),
                ),
              ),
            ],
          ),
          Positioned.fill(
            top: 60,
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
                              duration: const Duration(milliseconds: 100),
                              curve: Curves.easeIn);

                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setInt('selectedbrandId', brand.id);
                          prefs.setString('selectedbrandname', brand.name);
                          prefs.setString('selectedbrandImg', brand.imagePath);
                        },
                        child: Card(
                          surfaceTintColor: Colors.white,
                          elevation: 2,
                          shadowColor: Colors.black,
                          color: Colors.white,
                          margin: const EdgeInsets.all(10),
                          child: Stack(
                            children: [
                              Center(
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
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: PopupMenuButton<String>(
                                  elevation: 0,
                                  iconColor: Colors.black,
                                  color: Colors.white,
                                  onSelected: (String choice) {
                                    if (choice == MenuItems.update) {
                                      editBrandController =
                                          TextEditingController(
                                              text: brand.name);

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UpdateproductDialog(
                                              controller: editBrandController,
                                              function: (updatedBrandName) {
                                                updateBrand(updatedBrandName,
                                                    brand.id);
                                              },
                                            );
                                          });
                                    } else if (choice == MenuItems.delete) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteproductDialog(
                                              id: brand.id,
                                              function: (BrandId) {
                                                deleteBrand(BrandId);
                                              },
                                            );
                                          });
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return MenuItems.choices
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: ListTile(
                                          title: Text(
                                            choice,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: choice == "Delete"
                                                  ? Colors.red
                                                  : Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          leading: Icon(
                                            color: choice == "Delete"
                                                ? Colors.red
                                                : Colors.black,
                                            MenuItems.choiceIcons[choice],
                                          ),
                                        ),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
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
