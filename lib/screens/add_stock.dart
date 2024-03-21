import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/screens/widgets/input_fields.dart';
import 'package:newbestshop/models/api_data.dart';
import 'package:get/get.dart';
import 'main_page.dart';

class stockadder extends StatefulWidget {
  const stockadder({super.key});

  @override
  State<stockadder> createState() => _stockadderState();
}

class _stockadderState extends State<stockadder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Colors.grey, blurRadius: 0.50, spreadRadius: 0.1)
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  "Select a Category",
                  style: TextStyle(fontSize: 19),
                ),
              ),
            ),
          ),
          const SizedBox(),
          const Expanded(
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: CategoryPage(),
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});
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
      // appBar: AppBar(
      //   title: const Text('Select a Category'),
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              height: MediaQuery.of(context).size.height / 4,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
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
                      // child: ListTile(
                      //   title: Text(category.name),
                      //   leading: Image.network(
                      //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                      // ),
                      elevation: 3,
                      shadowColor: Colors.black,
                      color: Colors.white,
                      margin: const EdgeInsets.all(10),
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  ApiEndPoints.baseUrl +
                                      '/' +
                                      category.imagePath),
                            ),
                            SizedBox(
                              height: 9,
                            ),
                            Text(category.name),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
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
      // appBar: AppBar(
      //   title: const Text('Select an Item'),
      //   automaticallyImplyLeading: false,
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              // scrollDirection: Axis.horizontal,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 180,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
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
                    // child: ListTile(
                    //   title: Text(category.name),
                    //   leading: Image.network(
                    //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                    // ),
                    elevation: 3,
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
                          // const SizedBox(
                          //   // height: 9,
                          // ),
                          Text(itemName.name),
                        ],
                      ),
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
      // appBar: AppBar(
      //   title: const Text('Select an subcategory'),
      //   automaticallyImplyLeading: false,
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 180,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
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
                    // child: ListTile(
                    //   title: Text(category.name),
                    //   leading: Image.network(
                    //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                    // ),
                    elevation: 10,
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
                                  '${ApiEndPoints.baseUrl}/${subcategory.imagePath}')),
                          Text(subcategory.name),
                        ],
                      ),
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
      // appBar: AppBar(
      //   title: const Text('Select an brand'),
      //   automaticallyImplyLeading: false,
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 180,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
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
                    // child: ListTile(
                    //   title: Text(category.name),
                    //   leading: Image.network(
                    //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                    // ),
                    elevation: 10,
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
                          Text(brand.name),
                        ],
                      ),
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
    final token = prefs.getString('token') ?? '';
    final selectedCategoryId = prefs.getInt('selectedCategoryId');
    final selecteditem_nameId = prefs.getInt('selecteditemnameId');
    final selectedsub_categoryId = prefs.getInt('selectedsubcategoryId');
    final selectedbrandId = prefs.getInt('selectedbrandId');
    final selectedmodelId = prefs.getInt('selectedmodelId');
    final selectedcolorId = prefs.getInt('selectedcolorId');
    // final selectedsizeId = prefs.getInt('selectedsizeId') ?? 0;

    final selectedCategoryname = prefs.getString('selectedCategoryname');
    final selecteditem_namename = prefs.getString('selecteditemnamename');
    final selectedsub_categoryname = prefs.getString('selectedsubcategoryname');
    final selectedbrandname = prefs.getString('selectedbrandname');
    final selectedmodelname = prefs.getString('selectedmodelname');
    final selectedcolorname = prefs.getString('selectedcolorname');
    final selectedsizename = prefs.getString('selectedsizename');

    final name =
        "$selectedCategoryname-$selecteditem_namename-$selectedsub_categoryname-$selectedbrandname-$selectedmodelname-$selectedcolorname-$selectedsizename";

    var headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    try {
      var url = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stocksadd);

      var body = json.encode({
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
        // print(int.parse(billnumbercontroller.text));
        // print(selectedCategoryId);
        // print(selecteditem_nameId);
        // print(selectedsub_categoryId);
        // print(selectedbrandId);
        // print(selectedmodelId);
        // print(selectedcolorId);
        // print(sizeId);
        // print(quantityList);
        // print(name);
        // print(int.parse(purchasingpricecontroller.text));
        // print(int.parse(sellingpricecontroller.text));
        // print(int.parse(mrpcontroller.text));
        // print(response.body);
        quantity.clear();
        billnumbercontroller.clear();
        sellingpricecontroller.clear();
        purchasingpricecontroller.clear();
        mrpcontroller.clear();
        // quantityList = [];
        Get.offAll(() => const Home_Page());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      // print(int.parse(billnumbercontroller.text));
      // print(selectedCategoryId);
      // print(selecteditem_nameId);
      // print(selectedsub_categoryId);
      // print(selectedbrandId);
      // print(selectedmodelId);
      // print(selectedcolorId);
      // print(sizeId);
      // print(quantityList);
      // print(name);
      // print(int.parse(purchasingpricecontroller.text));
      // print(int.parse(sellingpricecontroller.text));
      // print(int.parse(mrpcontroller.text));
      // throw Exception('Failed to add stocks');
      print(e);
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
      // appBar: AppBar(
      //   // title: const Text('Dropdowns'),
      //   automaticallyImplyLeading: false,
      // ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton(
              hint: const Text('Select a model'),
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
            // const SizedBox(height: 10),
            DropdownButton(
              hint: const Text('Select a color'),
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
            // const SizedBox(height: 20),
            DropdownButton(
              hint: const Text('Select a size'),
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
            // const SizedBox(height: 20),
            SizedBox(
              width: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (selectedsize != null)
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
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              onChanged: (value) => {
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
                      InputTextFieldWidget(
                          sellingpricecontroller, "sellingprice"),
                    if (selectedsize != null)
                      InputTextFieldWidget(
                          purchasingpricecontroller, "purchasing price"),
                    if (selectedsize != null)
                      InputTextFieldWidget(mrpcontroller, "Mrp"),
                  ]),
            ),
            GestureDetector(
              onTap: () => postStocks(),
              child: Container(
                width: 200,
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
                    // SizedBox(
                    //   width: 5,
                    // ),
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
