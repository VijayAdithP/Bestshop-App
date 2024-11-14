import 'dart:convert';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:newbestshop/models/menuEnumModel.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/deleteProduct.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/floatingbutton.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/updateProduct.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';
import 'package:google_fonts/google_fonts.dart';

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
  TextEditingController editItemNameController = TextEditingController();
  TextEditingController addItemNameCategoryController = TextEditingController();
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

  Future<void> updateItemname(String? itemName, int? itemId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateItemname}${widget.category_Id}');
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": itemId,
            "name": itemName,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchItemNames();
        // Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  File? _selectedImage;

  Future<void> addItemname(String? itemName, {File? imageFile}) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.itemname}${widget.category_Id}');

      // Create a multipart request
      var request = http.MultipartRequest('POST', apiUri);

      request.headers.addAll({
        'Authorization': 'Bearer $_token',
        'Content-Type': 'multipart/form-data',
      });

      if (itemName != null) {
        request.fields['name'] = itemName;
        request.fields['category'] = widget.category_Id.toString();
      }
      if (imageFile != null) {
        var stream = http.ByteStream(imageFile.openRead());
        var length = await imageFile.length();
        var multipartFile = http.MultipartFile(
          'image', // This must match the field name on the server-side (in your case, 'image')
          stream,
          length,
          filename: path.basename(
              imageFile.path), // Extract the filename using path.basename
        );
        request.files.add(multipartFile);
      }
      // Send the request
      var response = await request.send();

      // Handle the response
      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        print("Response: $responseBody"); // Print the response for debugging
        _fetchItemNames(); // Refresh the category list
      } else {
        // Handle error responses
        print("Request failed with status: ${response.statusCode}");
        print("Reason: ${response.reasonPhrase}");
        final responseBody = await response.stream.bytesToString();
        print("Response body: $responseBody");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }
  // final response = await http.post(
  //   apiUri,
  //   headers: {
  //     'Authorization': 'Bearer $_token',
  //     'Content-Type': 'application/json',
  //   },
  //   body: json.encode(
  //     {
  //       "category": widget.category_Id,
  //       "name": itemName,
  //     },
  //   ),
  // );
  // if (response.statusCode == 200) {
  //   _fetchItemNames();
  //   Navigator.of(context).pop();
  // } else {
  //   print("Request failed with status: ${response.statusCode}");
  // }

  Future<void> deleteItemname(int? itemNameId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.updateItemname}${widget.category_Id}');
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": itemNameId,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchItemNames();
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
      _filteredItemNames = _itemNames
          .where(
              (item) => item.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  String? categoryname;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      floatingActionButton: FloatingActionButton(
        backgroundColor: HexColor("#563A9C"),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return FloatingButton(
                imageFunction: (image) {
                  _selectedImage = image; // Store the selected image locally
                },
                controller: addItemNameCategoryController,
                function: (categoryName) {
                  categoryname = categoryName;
                },
                titleText: "Add Item",
                hintText: "Enter Item name",
              );
            },
          ).then((_) {
            addItemname(categoryname, imageFile: _selectedImage);
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: Stack(
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
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    padding: EdgeInsets.zero,
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
                              duration: const Duration(milliseconds: 100),
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
                          elevation: 5,
                          shadowColor: Colors.black.withOpacity(0.5),
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
                                        backgroundColor: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              '${ApiEndPoints.baseUrl}/${itemName.imagePath}',
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          errorWidget: (context, url, error) =>
                                              const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                                "https://media.istockphoto.com/id/1226328537/vector/image-place-holder-with-a-gray-camera-icon.jpg?s=612x612&w=0&k=20&c=qRydgCNlE44OUSSoz5XadsH7WCkU59-l-dwrvZzhXsI="),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      // CircleAvatar(
                                      //   radius: 50,
                                      //   backgroundImage: NetworkImage(
                                      //       '${ApiEndPoints.baseUrl}/${itemName.imagePath}'),
                                      // ),
                                      Text(
                                        itemName.name,
                                        style: GoogleFonts.poppins(
                                          fontSize: 13,
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
                                      editItemNameController =
                                          TextEditingController(
                                              text: itemName.name);

                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return UpdateproductDialog(
                                              controller:
                                                  editItemNameController,
                                              function: (updatedCategoryName) {
                                                updateItemname(
                                                    updatedCategoryName,
                                                    itemName.id);
                                              },
                                            );
                                          });
                                    } else if (choice == MenuItems.delete) {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return DeleteproductDialog(
                                              id: itemName.id,
                                              function: (categoryId) {
                                                deleteItemname(categoryId);
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
          ),
        ],
      ),
    );
  }
}
