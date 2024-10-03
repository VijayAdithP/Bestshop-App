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

class CategoryPage extends StatefulWidget {
  final PageController controller;
  const CategoryPage({super.key, required this.controller});
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String _token;
  late List<apidata> _categories;
  bool _isLoading = true;
  TextEditingController editCategoryController = TextEditingController();
  TextEditingController addCategoryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTokenAndCategories();
  }

  Future<void> _fetchTokenAndCategories() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);
      final response = await http.get(
        apiUri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.map((item) => apidata.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> updateCategories(String? categoryName, int? categoryId) async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": categoryId,
            "name": categoryName,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchCategories();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deleteCategories(int? categoryId) async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json'
        },
        body: json.encode(
          {
            "id": categoryId,
          },
        ),
      );
      if (response.statusCode == 200) {
        _fetchCategories();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> addCategories(String? categoryName) async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);
      final response = await http.post(
        apiUri,
        body: json.encode(
          {
            "name": typedCategoryName,
          },
        ),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        _fetchCategories();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  String? typedCategoryName;
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
                    controller: addCategoryController,
                    function: (typedText) {
                      setState(() {
                        typedCategoryName = typedText;
                      });
                      addCategories(typedCategoryName);
                    },
                    titleText: "Add Category",
                    hintText: "Enter the category name");
              });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 188,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  child: Card(
                    color: Colors.white,
                    surfaceTintColor: Colors.white,
                    elevation: 2,
                    shadowColor: Colors.black,
                    margin: const EdgeInsets.all(10),
                    child: Stack(
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundImage: NetworkImage(
                                    category.imagePath.isEmpty
                                        ? "https://media.istockphoto.com/id/1226328537/vector/image-place-holder-with-a-gray-camera-icon.jpg?s=612x612&w=0&k=20&c=qRydgCNlE44OUSSoz5XadsH7WCkU59-l-dwrvZzhXsI="
                                        : '${ApiEndPoints.baseUrl}/${category.imagePath}',
                                  ),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                                Text(
                                  category.name,
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
                                editCategoryController =
                                    TextEditingController(text: category.name);

                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return UpdateproductDialog(
                                        controller: editCategoryController,
                                        function: (updatedCategoryName) {
                                          updateCategories(
                                              updatedCategoryName, category.id);
                                        },
                                      );

                                      // SimpleDialog(
                                      //   backgroundColor: Colors.white,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(15.0),
                                      //   ),
                                      //   title: const Text("Category Name:"),
                                      //   titleTextStyle: const TextStyle(
                                      //       fontSize: 17, color: Colors.black),
                                      //   children: [
                                      //     Padding(
                                      //       padding: const EdgeInsets.symmetric(
                                      //         horizontal: 20,
                                      //       ),
                                      //       child: TextField(
                                      //         controller:
                                      //             editCategoryController,
                                      //         textInputAction:
                                      //             TextInputAction.done,
                                      //         decoration: InputDecoration(
                                      //           filled: true,
                                      //           fillColor: Colors.white,
                                      //           enabledBorder:
                                      //               OutlineInputBorder(
                                      //             borderRadius:
                                      //                 const BorderRadius.all(
                                      //               Radius.circular(10),
                                      //             ),
                                      //             borderSide: BorderSide(
                                      //               color: Colors.grey[400]!,
                                      //             ),
                                      //           ),
                                      //           focusedBorder:
                                      //               OutlineInputBorder(
                                      //             borderRadius:
                                      //                 const BorderRadius.all(
                                      //               Radius.circular(10),
                                      //             ),
                                      //             borderSide: BorderSide(
                                      //               color: Colors.grey[400]!,
                                      //             ),
                                      //           ),
                                      //           border: InputBorder.none,
                                      //           hintText: "category name",
                                      //           hintStyle: const TextStyle(
                                      //             fontWeight: FontWeight.w500,
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Padding(
                                      //       padding: const EdgeInsets.symmetric(
                                      //         vertical: 15,
                                      //       ),
                                      //       child: IntrinsicHeight(
                                      //         child: Row(
                                      //           mainAxisAlignment:
                                      //               MainAxisAlignment
                                      //                   .spaceEvenly,
                                      //           children: [
                                      //             GestureDetector(
                                      //               onTap: () {
                                      //                 Navigator.of(context)
                                      //                     .pop();
                                      //               },
                                      //               child: const Padding(
                                      //                 padding: EdgeInsets.only(
                                      //                   left: 10,
                                      //                   right: 10,
                                      //                 ),
                                      //                 child: Text(
                                      //                   "No",
                                      //                   style: TextStyle(
                                      //                       color: Colors.red,
                                      //                       fontWeight:
                                      //                           FontWeight.w500,
                                      //                       fontSize: 17),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //             VerticalDivider(
                                      //               color: Colors.grey
                                      //                   .withOpacity(0.5),
                                      //               thickness: 1,
                                      //             ),
                                      //             GestureDetector(
                                      //               onTap: () {
                                      //                 updateCategories(
                                      //                     editCategoryController
                                      //                         .text,
                                      //                     category.id);
                                      //               },
                                      //               child: const Padding(
                                      //                 padding: EdgeInsets.only(
                                      //                   left: 10,
                                      //                   right: 10,
                                      //                 ),
                                      //                 child: Text(
                                      //                   "yes",
                                      //                   style: TextStyle(
                                      //                       color:
                                      //                           Color.fromRGBO(
                                      //                               72,
                                      //                               96,
                                      //                               181,
                                      //                               1),
                                      //                       fontWeight:
                                      //                           FontWeight.bold,
                                      //                       fontSize: 17),
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ],
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // );
                                    });
                              } else if (choice == MenuItems.delete) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return DeleteproductDialog(
                                        id: category.id,
                                        function: (categoryId) {
                                          deleteCategories(categoryId);
                                        },
                                      );
                                      // return Dialog(
                                      //   backgroundColor: Colors.white,
                                      //   shape: RoundedRectangleBorder(
                                      //     borderRadius:
                                      //         BorderRadius.circular(15.0),
                                      //   ),
                                      //   child: ClipRRect(
                                      //     borderRadius:
                                      //         BorderRadius.circular(15.0),
                                      //     child: Padding(
                                      //       padding: const EdgeInsets.only(
                                      //         top: 3,
                                      //         left: 3,
                                      //         right: 3,
                                      //         bottom: 3,
                                      //       ),
                                      //       child: Container(
                                      //         width: 150,
                                      //         decoration: const BoxDecoration(
                                      //           color: Colors.white,
                                      //         ),
                                      //         child: Padding(
                                      //           padding:
                                      //               const EdgeInsets.symmetric(
                                      //             horizontal: 20.0,
                                      //             vertical: 20,
                                      //           ),
                                      //           child: Column(
                                      //             mainAxisSize:
                                      //                 MainAxisSize.min,
                                      //             crossAxisAlignment:
                                      //                 CrossAxisAlignment.center,
                                      //             children: [
                                      //               const Text(
                                      //                 "Are you sure?",
                                      //                 style: TextStyle(
                                      //                   color: Colors.black,
                                      //                   fontSize: 23,
                                      //                   fontWeight:
                                      //                       FontWeight.bold,
                                      //                 ),
                                      //               ),
                                      //               const SizedBox(
                                      //                 height: 30,
                                      //               ),
                                      //               IntrinsicHeight(
                                      //                 child: Row(
                                      //                   mainAxisAlignment:
                                      //                       MainAxisAlignment
                                      //                           .spaceEvenly,
                                      //                   children: [
                                      //                     GestureDetector(
                                      //                       onTap: () {
                                      //                         Navigator.of(
                                      //                                 context)
                                      //                             .pop();
                                      //                       },
                                      //                       child:
                                      //                           const Padding(
                                      //                         padding:
                                      //                             EdgeInsets
                                      //                                 .only(
                                      //                           left: 10,
                                      //                           right: 10,
                                      //                         ),
                                      //                         child: Text(
                                      //                           "No",
                                      //                           style: TextStyle(
                                      //                               color: Colors
                                      //                                   .red,
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .w500,
                                      //                               fontSize:
                                      //                                   17),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                     VerticalDivider(
                                      //                       color: Colors.grey
                                      //                           .withOpacity(
                                      //                               0.5),
                                      //                       thickness: 1,
                                      //                     ),
                                      //                     GestureDetector(
                                      //                       onTap: () {
                                      // deleteCategories(
                                      //     category.id);
                                      //                       },
                                      //                       child:
                                      //                           const Padding(
                                      //                         padding:
                                      //                             EdgeInsets
                                      //                                 .only(
                                      //                           left: 10,
                                      //                           right: 10,
                                      //                         ),
                                      //                         child: Text(
                                      //                           "yes",
                                      //                           style: TextStyle(
                                      //                               color: Color
                                      //                                   .fromRGBO(
                                      //                                       72,
                                      //                                       96,
                                      //                                       181,
                                      //                                       1),
                                      //                               fontWeight:
                                      //                                   FontWeight
                                      //                                       .bold,
                                      //                               fontSize:
                                      //                                   17),
                                      //                         ),
                                      //                       ),
                                      //                     ),
                                      //                   ],
                                      //                 ),
                                      //               ),
                                      //             ],
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // );
                                    });
                              }
                            },
                            itemBuilder: (BuildContext context) {
                              return MenuItems.choices.map((String choice) {
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
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('selecteditemname');
                    prefs.remove('selectedsubcategoryname');
                    prefs.remove('selectedbrandname');

                    prefs.setInt('selectedCategoryId', category.id);
                    prefs.setString('selectedCategoryname', category.name);
                    prefs.setString('selectedCategoryImg', category.imagePath);
                    widget.controller.animateToPage(1,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeIn);
                  },
                );
              },
            ),
    );
  }
}
