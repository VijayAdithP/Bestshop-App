import 'dart:convert';
import 'package:newbestshop/screens/widgets/buttons.dart';
import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/screens/widgets/input_fields.dart';
import 'package:provider/provider.dart';
import 'package:newbestshop/models/api_data.dart';
import 'package:get/get.dart';
import 'main_page.dart';

// class Category {
//   int id;
//   String imgPath;
//   String label;

//   Category(this.id, this.imgPath, this.label);
// }

// class CategoryFields {
//   int id;
//   String label;

//   CategoryFields(this.id, this.label);
// }

// class AddStock extends StatefulWidget {
//   const AddStock({super.key});

//   @override
//   State<AddStock> createState() => _AddStockState();
// }

// class _AddStockState extends State<AddStock> {
//   dynamic categories = 0;
//   List<Category> pinnedCategories = [];
//   List<CategoryFields> categoryFields = [];
//   bool isLoading = true, isCategorySelected = false, fileSelected = false;
//   int selectedCategory = 0;
//   int selectedFieldIndex = 0;
//   late CategoryFields selectedField;

//   fetchCategories() async {
//     try {
//       Uri apiUri = Uri.parse(
//           ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories);
//       var res = await get(apiUri);
//       if (res.statusCode == 200) {
//         var body = json.decode(res.body);
//         setState(() {
//           categories = body;
//           isLoading = false;
//         });
//       } else {
//         print("Request failed with status: ${res.statusCode}");
//       }
//     } catch (e) {
//       print("Error occurred: $e");
//     }

//     // Uri apiUri = Uri.parse(
//     //     ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categoriesAdd);
//     // var res = await get(apiUri);
//     // var body = json.decode(res.body);
//     // setState(() {
//     //   categories = body;
//     //   isLoading = false;
//     // });
//   }

//   handlePinItem(index) async {
//     if (!isCategorySelected) {
//       pinnedCategories.add(Category(
//           categories[index]['category_id'],
//           categories[index]['category_image'],
//           categories[index]['category_name']));
//     } else {
//       pinnedCategories.add(Category(
//           categories[index]['detail_id'],
//           categories[index]['details_image'],
//           categories[index]['details_name']));
//     }

//     isLoading = true;

//     setState(() {});

//     if (selectedCategory == 0) {
//       selectedCategory = categories[index]['category_id'];
//       categories = 0;

//       var res = await get(
//         Uri.parse(
//             "${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categories}/$selectedCategory"),
//       );

//       var result = json.decode(res.body);
//       for (var element in result) {
//         categoryFields
//             .add(CategoryFields(element['field_id'], element['field_name']));
//       }

//       if (categoryFields.isNotEmpty) {
//         selectedField = categoryFields[0];
//         fetchCategorySubFields();
//         isCategorySelected = true;
//       }
//     } else {
//       selectedFieldIndex++;
//       selectedField = categoryFields[selectedFieldIndex];
//       fetchCategorySubFields();
//     }

//     isLoading = false;
//     setState(() {});
//   }

//   fetchCategorySubFields() async {
//     var res = await get(
//       Uri.parse(
//           "${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categoriesAdd}/$selectedCategory/${selectedField.id}"),
//     );
//     categories = json.decode(res.body);
//     setState(() {});
//   }

//   @override
//   void initState() {
//     super.initState();
//     fetchCategories();
//   }

//   void showAddCategory() async {
//     await showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//             backgroundColor: backgroundColor,
//             shape:
//                 RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Column(
//                   children: [
//                     const Text(
//                       "Add Category",
//                       style:
//                           TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     fileSelected
//                         ? const CircleAvatar(
//                             radius: 80,
//                           )
//                         : InkWell(
//                             onTap: () {
//                               print("object");
//                               final ImagePicker picker = ImagePicker();
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                   color: Colors.white,
//                                   borderRadius: BorderRadius.circular(500)),
//                               padding: const EdgeInsets.all(50),
//                               child: const Icon(
//                                 Icons.camera_alt_rounded,
//                                 size: 40,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                           ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     const Align(
//                       alignment: Alignment.centerLeft,
//                       child: Text(
//                         "Product Name",
//                         style: TextStyle(fontSize: 17),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 10,
//                     ),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 10),
//                       decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8)),
//                       child: TextFormField(
//                         decoration:
//                             const InputDecoration(border: InputBorder.none),
//                       ),
//                     ),
//                     const SizedBox(
//                       height: 20,
//                     ),
//                     customButton("label")
//                   ],
//                 ),
//               ),
//             ),
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       backgroundColor: backgroundColor,
//       // appBar: AppBar(
//       //   foregroundColor: Colors.white,
//       //   backgroundColor: primaryColor,
//       //   title: const Text(
//       //     "Best Shop",
//       //     style: TextStyle(color: Colors.white, fontSize: 20),
//       //   ),
//       // ),
//       body: Padding(
//         padding: const EdgeInsets.all(15),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Container(
//               width: double.infinity,
//               height: 130,
//               decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(10),
//                   boxShadow: const [
//                     BoxShadow(
//                         color: Colors.grey, blurRadius: 0.50, spreadRadius: 0.1)
//                   ]),
//               child: pinnedCategories.isEmpty
//                   ? const Center(
//                       child: Text(
//                       "Select your Category",
//                       style: TextStyle(fontSize: 19),
//                     ))
//                   : ListView.builder(
//                       scrollDirection: Axis.horizontal,
//                       itemCount: pinnedCategories.length,
//                       itemBuilder: (builder, index) {
//                         return Padding(
//                           padding: const EdgeInsets.all(10),
//                           child: CircleAvatar(
//                             radius: 45,
//                             backgroundImage: NetworkImage(
//                                 "${ApiEndPoints.baseUrl}/${pinnedCategories[index].imgPath}"),
//                           ),
//                         );
//                       }),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Text(
//                   isCategorySelected ? selectedField.label : "Category",
//                   style: const TextStyle(
//                       fontSize: 20, fontWeight: FontWeight.w500),
//                 ),
//                 GestureDetector(
//                   onTap: () => showAddCategory(),
//                   child: Container(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//                     decoration: BoxDecoration(
//                         color: primaryColor,
//                         borderRadius: BorderRadius.circular(8)),
//                     child: const Row(
//                       children: [
//                         Icon(
//                           Icons.add,
//                           color: Colors.white,
//                         ),
//                         SizedBox(
//                           width: 5,
//                         ),
//                         Text(
//                           "Add",
//                           style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 16,
//                               fontWeight: FontWeight.w500),
//                         ),
//                       ],
//                     ),
//                   ),
//                 )
//               ],
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//             if (isLoading)
//               Column(
//                 children: [
//                   const SizedBox(
//                     height: 50,
//                   ),
//                   Center(
//                       child: SizedBox(
//                           height: 60,
//                           width: 60,
//                           child: CircularProgressIndicator(
//                             color: primaryColor,
//                             strokeWidth: 5,
//                           ))),
//                 ],
//               ),
//             if (!isLoading)
//               Expanded(
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(15),
//                       boxShadow: const [
//                         BoxShadow(
//                             color: Colors.grey,
//                             blurRadius: 0.50,
//                             spreadRadius: 0.1)
//                       ]),
//                   child: RefreshIndicator(
//                     onRefresh: () => fetchCategories(),
//                     child: categories != 0
//                         ? ListView.builder(
//                             padding: const EdgeInsets.all(10),
//                             itemCount: categories.length,
//                             itemBuilder: (builder, index) {
//                               return categoryCard(index);
//                             },
//                           )
//                         : const Center(
//                             child: Text("No Categories Found"),
//                           ),
//                   ),
//                 ),
//               )
//           ],
//         ),
//       ),
//     );
//   }

//   Widget categoryCard(int index) {
//     String imageKey = isCategorySelected ? 'details_image' : 'category_image';
//     print(categories[0]);
//     return GestureDetector(
//       onTap: () => handlePinItem(index),
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 15),
//         padding: const EdgeInsets.all(10),
//         decoration: BoxDecoration(color: backgroundColor),
//         child: Row(
//           children: [
//             CircleAvatar(
//               radius: 45,
//               backgroundImage: NetworkImage(
//                   '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.categoriesAdd}/${categories[index][imageKey]}'),
//             ),
//             const SizedBox(
//               width: 40,
//             ),
//             Text(
//               categories[index]
//                   [isCategorySelected ? 'details_name' : 'category_name'],
//               style: const TextStyle(fontSize: 18),
//             ),
//           ],
//         ),
//       ),
//     );
//     // return Text("data");
//   }
// }

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late String _token;
  late List<apidata> _categories;
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Category'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setInt('selectedCategoryId', category.id);
                    prefs.setString('selectedCategoryname', category.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ItemNamePage(
                          category_Id: category.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(category.name),
                      leading: Image.network(
                          ApiEndPoints.baseUrl + '/' + category.imagePath),
                    ),
                    // CircleAvatar(
                    //   radius: 45,
                    //   backgroundImage: NetworkImage(
                    //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                  ),
                );
              },
            ),
    );
  }
}

class ItemNamePage extends StatefulWidget {
  final int category_Id;

  const ItemNamePage({required this.category_Id});

  @override
  _ItemNamePageState createState() => _ItemNamePageState();
}

class _ItemNamePageState extends State<ItemNamePage> {
  late String _token;
  late List<apidata> _itemNames;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
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
          _isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an Item'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _itemNames.length,
              itemBuilder: (context, index) {
                final itemName = _itemNames[index];
                return GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setInt('selecteditemnameId', itemName.id);
                    prefs.setString('selecteditemname', itemName.name);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => subcategoryPage(
                          itemnameId: itemName.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(itemName.name),
                      leading: itemName.imagePath.isNotEmpty
                          ? Image.network(
                              '${ApiEndPoints.baseUrl}/${itemName.imagePath}')
                          : SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class subcategoryPage extends StatefulWidget {
  final int itemnameId;

  const subcategoryPage({required this.itemnameId});

  @override
  _subcategoryPageState createState() => _subcategoryPageState();
}

class _subcategoryPageState extends State<subcategoryPage> {
  late String _token;
  late List<apidata> _subcategory;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndsubcategory();
  }

  Future<void> _fetchTokenAndsubcategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    _fetchsubcategory();
  }

  Future<void> _fetchsubcategory() async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.subcategory}${widget.itemnameId}');
      final response = await http.get(
        apiUri,
        headers: {'Authorization': 'Bearer $_token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _subcategory = data.map((item) => apidata.fromJson(item)).toList();
          _isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an subcategory'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _subcategory.length,
              itemBuilder: (context, index) {
                final subcategory = _subcategory[index];
                return GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setInt('selectedsubcategoryId', subcategory.id);
                    prefs.setString(
                        'selectedsubcategoryname', subcategory.name);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => brandPage(
                          brandId: subcategory.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(subcategory.name),
                      leading: subcategory.imagePath.isNotEmpty
                          ? Image.network(
                              '${ApiEndPoints.baseUrl}/${subcategory.imagePath}')
                          : SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class brandPage extends StatefulWidget {
  final int brandId;

  const brandPage({required this.brandId});

  @override
  _brandPageState createState() => _brandPageState();
}

class _brandPageState extends State<brandPage> {
  late String _token;
  late List<apidata> _brand;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchTokenAndbrand();
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
          _isLoading = false;
        });
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select an brand'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _brand.length,
              itemBuilder: (context, index) {
                final brand = _brand[index];
                return GestureDetector(
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setInt('selectedbrandId', brand.id);
                    prefs.setString('selectedbrandname', brand.name);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyHomePage(
                          modelId: brand.id,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      title: Text(brand.name),
                      leading: brand.imagePath.isNotEmpty
                          ? Image.network(
                              '${ApiEndPoints.baseUrl}/${brand.imagePath}')
                          : SizedBox.shrink(),
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int modelId;

  const MyHomePage({required this.modelId});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final quantity = TextEditingController();
  final billnumbercontroller = TextEditingController();
  final sellingpricecontroller = TextEditingController();
  final purchasingpricecontroller = TextEditingController();
  final mrpcontroller = TextEditingController();

  List<dynamic> _models = [];
  dynamic selectedModel;
  List<dynamic> _colors = [];
  dynamic selectedColor;
  int? selectedModelId;
  List<dynamic> selectedsizelist = [];
  dynamic selectedsize;
  int? selectedsizeId;
  List<int> sizeId = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final Uri apiUri = Uri.parse(
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.branddrop}${widget.modelId}');
    final response = await http.get(
      apiUri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _models = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> fetchColorData(int _selectedModelId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final Uri apiUri = Uri.parse(
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.modeldrop}$_selectedModelId');
    final response = await http.get(
      apiUri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        _colors = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load color data');
    }
  }

  Future<void> fetchColorSize(int selectedsizeId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final Uri apiUri = Uri.parse(
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.colordrop}$selectedsizeId');
    final response = await http.get(
      apiUri,
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      setState(() {
        selectedsizelist = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load color data');
    }
  }

  Future<void> postStocks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedCategoryId = prefs.getInt('selectedCategoryId');
    final selecteditem_nameId = prefs.getInt('selecteditemnameId');
    final selectedsub_categoryId = prefs.getInt('selectedsubcategoryId');
    final selectedbrandId = prefs.getInt('selectedbrandId');
    final selectedmodelId = prefs.getInt('selectedmodelId');
    final selectedcolorId = prefs.getInt('selectedcolorId');
    // final selectedsizeId = prefs.getInt('selectedsizeId') ?? 0;

    final selectedCategoryname = prefs.getString('selectedCategoryname');
    final selecteditem_namename = prefs.getString('selecteditemnamename');
    final selectedsub_categoryname =
        prefs.getString('selectedsubcategoryname') ?? 0;
    final selectedbrandname = prefs.getString('selectedbrandname');
    final selectedmodelname = prefs.getString('selectedmodelname');
    final selectedcolorname = prefs.getString('selectedcolorname');
    final selectedsizename = prefs.getString('selectedsizename');

    final name =
        "$selectedCategoryname-$selecteditem_namename -$selectedsub_categoryname-$selectedbrandname-$selectedmodelname-$selectedcolorname-$selectedsizename";

    var headers = {'Content-Type': 'application/json'};
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stocksadd);

      var body = json.encode({
        // "location": 1,
        "bill_number": int.parse(billnumbercontroller.text),
        "category": selectedCategoryId,
        "item_name": selecteditem_nameId,
        "sub_category": selectedsub_categoryId,
        "brand": selectedbrandId,
        "model": selectedmodelId,
        "color": selectedcolorId,
        "size": sizeId,
        "quantity": quantityList,
        "name": name,
        "purchasing_price": int.parse(purchasingpricecontroller.text),
        "selling_price": int.parse(sellingpricecontroller.text),
        "mrp": int.parse(mrpcontroller.text),
      });

      var response = await http.post(url, body: body, headers: headers);

      if (response.statusCode == 200) {
        quantity.clear();
        billnumbercontroller.clear();
        sellingpricecontroller.clear();
        purchasingpricecontroller.clear();
        mrpcontroller.clear();
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CategoryPage(),
        //   ),
        // );
        Get.offAll(() => const Home_Page());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      throw Exception('Failed to add stocks');
    }
  }

  List<int> quantityList = [];

  void convertAndPassToList() {
    setState(() {
      String input = quantity.text;
      // Use regular expression to match digits
      RegExp digitRegExp = RegExp(r'\d+');
      // Find all matches in the input string
      Iterable<Match> matches = digitRegExp.allMatches(input);
      // Convert matches to list of integers
      quantityList =
          matches.map((match) => int.parse(match.group(0)!)).toList();
      print('Quantity List: $quantityList');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Dropdowns'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: Text('Select a model'),
              value: selectedModel,
              onChanged: (newValue) async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setInt('selectedmodelId', newValue['id']);
                prefs.setString('selectedmodelname', newValue['name']);
                setState(() {
                  selectedModel = newValue;
                  selectedModelId = newValue['id'];
                  fetchColorData(selectedModelId!);
                  selectedColor = null;
                });
              },
              items: _models.map<DropdownMenuItem<dynamic>>((item) {
                return DropdownMenuItem<dynamic>(
                  value: item,
                  child: Text(item['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton(
              hint: Text('Select a color'),
              value: selectedColor,
              onChanged: (newValue) async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                prefs.setInt('selectedcolorId', newValue['id']);
                prefs.setString('selectedcolorname', newValue['name']);
                setState(() {
                  selectedColor = newValue;
                  selectedsizeId = newValue['id'];
                  fetchColorSize(selectedsizeId!);
                  selectedsize = null;
                });
              },
              items: _colors.map<DropdownMenuItem<dynamic>>((item) {
                return DropdownMenuItem<dynamic>(
                  value: item,
                  child: Text(item['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            DropdownButton(
              hint: Text('Select a size'),
              value: selectedsize,
              onChanged: (newValue) async {
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                // prefs.setIntList('selectedsizeId', newValue['id']);
                prefs.setString('selectedsizename', newValue['name']);
                sizeId = [newValue['id']];
                setState(() {
                  selectedsize = newValue;
                });
              },
              items: selectedsizelist.map<DropdownMenuItem<dynamic>>((item) {
                return DropdownMenuItem<dynamic>(
                  value: item,
                  child: Text(item['name']),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            if (selectedsize != null)
              // InputTextFieldWidget(quantity, "quantity"),
              Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  height: 60,
                  child: Material(
                    borderRadius: BorderRadius.circular(20),
                    elevation: 20,
                    shadowColor: const Color.fromARGB(141, 33, 149, 243),
                    child: TextField(
                      onSubmitted: (value) => {
                        setState(() {
                          convertAndPassToList();
                        })
                      },
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.justify,
                      controller: quantity,
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.only(
                          left: 15,
                          bottom: 39,
                        ),
                        alignLabelWithHint: true,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(143, 0, 140, 255),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(143, 0, 140, 255),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(143, 0, 140, 255),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.transparent,
                        hintStyle: TextStyle(
                          color: Color.fromARGB(146, 87, 111, 168),
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                        hintText: "quantity",
                      ),
                    ),
                  ),
                ),
              ),
            if (selectedsize != null)
              InputTextFieldWidget(billnumbercontroller, "bill_number"),
            if (selectedsize != null)
              InputTextFieldWidget(sellingpricecontroller, "sellingprice"),
            if (selectedsize != null)
              InputTextFieldWidget(
                  purchasingpricecontroller, "purchasing price"),
            if (selectedsize != null)
              InputTextFieldWidget(mrpcontroller, "Mrp"),
            GestureDetector(
              onTap: () => postStocks(),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(8)),
                child: const Row(
                  children: [
                    Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "Add",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
