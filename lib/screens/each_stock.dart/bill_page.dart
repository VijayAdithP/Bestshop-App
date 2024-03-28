import 'dart:convert';
import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/screens/widgets/input_fields.dart';
import 'package:get/get.dart';
import 'package:newbestshop/screens/main_page.dart';

class BillingPage extends StatefulWidget {
  final int modelId;
  final PageController controller;

  const BillingPage({required this.modelId, required this.controller});

  @override
  _BillingPageState createState() => _BillingPageState();
}

class _BillingPageState extends State<BillingPage> {
  final quantity = TextEditingController();
  final billnumbercontroller = TextEditingController();
  final sellingpricecontroller = TextEditingController();
  final purchasingpricecontroller = TextEditingController(text: "1");
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
    final selecteditem_namename = prefs.getString('selecteditemname');
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
        quantity.clear();
        billnumbercontroller.clear();
        sellingpricecontroller.clear();
        purchasingpricecontroller.clear();
        mrpcontroller.clear();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.remove('selectedCategoryname');
        prefs.remove('selecteditemname');
        prefs.remove('selectedsubcategoryname');
        prefs.remove('selectedbrandname');
        prefs.remove('selectedmodelname');
        prefs.remove('selectedcolorname');
        prefs.remove('selectedsizename');
        Get.offAll(() => const Home_Page());
      } else {
        throw jsonDecode(response.body)["Message"] ?? "Unknown Error Occured";
      }
    } catch (e) {
      print(e);
    }
  }

  List<int> quantityList = [];

  void convertAndPassToList() {
    setState(() {
      String input = quantity.text;
      RegExp digitRegExp = RegExp(r'\d+');
      Iterable<Match> matches = digitRegExp.allMatches(input);
      quantityList =
          matches.map((match) => int.parse(match.group(0)!)).toList();
      // print('Quantity List: $quantityList');
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
      floatingActionButton: GestureDetector(
        onTap: () => postStocks(),
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(8)),
          child: const Row(
            children: [
              Icon(
                Icons.add,
                color: Colors.white,
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
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 210,
                child: Card(
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: DropdownButton(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          underline: const Text(""),
                          // dropdownColor: Colors.black,
                          focusColor: Colors.black,
                          // elevation: 10,
                          style: const TextStyle(color: Colors.black),
                          hint: const Text(
                            'Select a model',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: selectedModel,
                          onChanged: (newValue) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setInt('selectedmodelId', newValue['id']);
                            prefs.setString(
                                'selectedmodelname', newValue['name']);
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
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 10),
              SizedBox(
                width: 210,
                child: Card(
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: DropdownButton(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(color: Colors.black),
                          hint: const Text(
                            'Select a color',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: selectedColor,
                          onChanged: (newValue) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            prefs.setInt('selectedcolorId', newValue['id']);
                            prefs.setString(
                                'selectedcolorname', newValue['name']);
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
                      ),
                    ),
                  ),
                ),
              ),
              // const SizedBox(height: 20),
              SizedBox(
                width: 210,
                child: Card(
                  child: Center(
                    child: DropdownButtonHideUnderline(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10, left: 10),
                        child: DropdownButton(
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          // underline: const Text(""),
                          style: const TextStyle(color: Colors.black),
                          hint: const Text(
                            'Select a size',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          value: selectedsize,
                          onChanged: (newValue) async {
                            final SharedPreferences prefs =
                                await SharedPreferences.getInstance();
                            // prefs.setIntList('selectedsizeId', newValue['id']);
                            prefs.setString(
                                'selectedsizename', newValue['name']);
                            sizeId = [newValue['id']];
                            setState(() {
                              selectedsize = newValue;
                            });
                          },
                          items: selectedsizelist
                              .map<DropdownMenuItem<dynamic>>((item) {
                            return DropdownMenuItem<dynamic>(
                              value: item,
                              child: Text(item['name']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
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
                              Radius.circular(10),
                            ),
                          ),
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => {
                                setState(() {
                                  convertAndPassToList();
                                })
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.justify,
                              controller: quantity,
                              decoration: const InputDecoration(
                                labelText: "Quantity",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
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
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                // hintText: "quantity",
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectedsize != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 13),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          height: 60,
                          child: Material(
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              onChanged: (value) => {
                                setState(() {
                                  convertAndPassToList();
                                })
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.justify,
                              controller: billnumbercontroller,
                              decoration: const InputDecoration(
                                labelText: "BillNumber",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
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
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectedsize != null)
                      // InputTextFieldWidget(
                      //     sellingpricecontroller, "sellingprice"),
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
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.justify,
                              controller: sellingpricecontroller,
                              decoration: const InputDecoration(
                                labelText: "SellingPrice",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
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
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                // hintText: "sellingprice",
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectedsize != null)
                      // InputTextFieldWidget(
                      // purchasingpricecontroller, "purchasing price"),
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
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              textInputAction: TextInputAction.next,

                              onChanged: (value) => {
                                setState(() {
                                  convertAndPassToList();
                                })
                              },
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.justify,
                              controller: purchasingpricecontroller,
                              // initialValue: "1",
                              decoration: const InputDecoration(
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                labelText: "PurchasingPrice",
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
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                // hintText: "purchasing_price",
                              ),
                            ),
                          ),
                        ),
                      ),
                    if (selectedsize != null)
                      // InputTextFieldWidget(mrpcontroller, "Mrp"),
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
                            borderRadius: BorderRadius.circular(10),
                            elevation: 3,
                            shadowColor:
                                const Color.fromARGB(141, 33, 149, 243),
                            child: TextFormField(
                              textInputAction: TextInputAction.done,
                              textAlignVertical: TextAlignVertical.center,
                              textAlign: TextAlign.justify,
                              controller: mrpcontroller,
                              decoration: const InputDecoration(
                                labelText: "Mrp",
                                labelStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
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
                                    Radius.circular(10),
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(143, 0, 140, 255),
                                    width: 2.0,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10),
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.transparent,
                                hintStyle: TextStyle(
                                  color: Color.fromARGB(146, 87, 111, 168),
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
                                ),
                                // hintText: "mrp",
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
