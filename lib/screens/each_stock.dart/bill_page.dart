import 'dart:convert';
import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:newbestshop/screens/widgets/input_fields.dart';
import 'package:get/get.dart';
import 'package:newbestshop/screens/main_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        prefs.remove('selectedCategoryId');
        prefs.remove('selecteditemnameId');
        prefs.remove('selectedsubcategoryId');
        prefs.remove('selectedbrandId');

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

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmationDialog() {
    // Check if any of the text fields are empty
    if (quantity.text.isEmpty ||
        billnumbercontroller.text.isEmpty ||
        sellingpricecontroller.text.isEmpty ||
        purchasingpricecontroller.text.isEmpty ||
        mrpcontroller.text.isEmpty) {
      _showSnackbar("Please fill in all fields.");
      return;
    }

    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          insetPadding: const EdgeInsets.all(10),
          title: Align(
            alignment: Alignment.center,
            child: Column(
              children: [
                const Icon(
                  Icons.add_task_rounded,
                  size: 70,
                  color: Color(0xFF4860b5),
                ),
                Text(
                  "Are you sure?",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 23,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 32,
                    ),
                    foregroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    side: const BorderSide(
                      color: Colors.red,
                    ),
                  ),
                  child: Text(
                    "No",
                    style: GoogleFonts.poppins(
                      color: const Color.fromARGB(255, 255, 0, 0),
                      // fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                    // style: TextStyle(
                    //   color: Color.fromARGB(255, 255, 0, 0),
                    // ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: MaterialStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 32,
                      ),
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      Color(0xFF4860b5),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    // style: TextStyle(color: Colors.white),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      // fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    postStocks();
                  },
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      resizeToAvoidBottomInset: false,
      floatingActionButton: GestureDetector(
        onTap: _showConfirmationDialog,
        child: Container(
          width: 100,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          decoration: BoxDecoration(
              color: primaryColor, borderRadius: BorderRadius.circular(8)),
          child: Row(
            children: [
              const Icon(
                Icons.add,
                color: Colors.white,
              ),
              Text(
                "Add",
                // style: TextStyle(
                //     color: Colors.white,
                //     fontSize: 16,
                //     fontWeight: FontWeight.w500),
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      body: Padding(
        padding: const EdgeInsets.all(3.5),
        child: Card(
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5), // if you need this
            side: BorderSide(
              color: Colors.grey.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Stack(
            children: [
              // const Positioned(
              //   right: 340,
              //   top: 10,
              //   child: CircleAvatar(
              //     radius: 80,
              //     backgroundColor: Color.fromARGB(90, 33, 149, 243),
              //   ),
              // ),
              // const Positioned(
              //   right: 270,
              //   top: -50,
              //   child: CircleAvatar(
              //     radius: 80,
              //     backgroundColor: Color.fromARGB(90, 33, 149, 243),
              //   ),
              // ),
              Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 210,
                        child: Card(
                          // surfaceTintColor: Colors.white,
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: DropdownButton(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(10),
                                  underline: const Text(""),
                                  // dropdownColor: Colors.black,
                                  focusColor: Colors.black,
                                  // elevation: 10,
                                  style: const TextStyle(color: Colors.black),
                                  hint: Text(
                                    'Select a model',
                                    style: GoogleFonts.poppins(
                                      // fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  value: selectedModel,
                                  onChanged: (newValue) async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(
                                        'selectedmodelId', newValue['id']);
                                    prefs.setString(
                                        'selectedmodelname', newValue['name']);
                                    setState(() {
                                      selectedModel = newValue;
                                      selectedModelId = newValue['id'];
                                      fetchColorData(selectedModelId!);
                                      selectedColor = null;
                                    });
                                  },
                                  items: _models
                                      .map<DropdownMenuItem<dynamic>>((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item,
                                      child: Text(
                                        item['name'],
                                        style: GoogleFonts.poppins(
                                            // fontSize: 23,
                                            // fontWeight: FontWeight.w500,
                                            ),
                                      ),
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
                          // surfaceTintColor: Colors.white,
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: DropdownButton(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(10),
                                  style: const TextStyle(color: Colors.black),
                                  hint: Text(
                                    'Select a color',
                                    style: GoogleFonts.poppins(
                                      // fontSize: 23,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  value: selectedColor,
                                  onChanged: (newValue) async {
                                    final SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setInt(
                                        'selectedcolorId', newValue['id']);
                                    prefs.setString(
                                        'selectedcolorname', newValue['name']);
                                    setState(() {
                                      selectedColor = newValue;
                                      selectedsizeId = newValue['id'];
                                      fetchColorSize(selectedsizeId!);
                                      selectedsize = null;
                                    });
                                  },
                                  items: _colors
                                      .map<DropdownMenuItem<dynamic>>((item) {
                                    return DropdownMenuItem<dynamic>(
                                      value: item,
                                      child: Text(
                                        item['name'],
                                        style: GoogleFonts.poppins(
                                            // fontSize: 23,
                                            // fontWeight: FontWeight.w500,
                                            ),
                                      ),
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
                          // surfaceTintColor: Colors.white,
                          child: Center(
                            child: DropdownButtonHideUnderline(
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(right: 10, left: 10),
                                child: DropdownButton(
                                  isExpanded: true,
                                  borderRadius: BorderRadius.circular(10),
                                  // underline: const Text(""),
                                  style: const TextStyle(color: Colors.black),
                                  hint: Text(
                                    'Select a size',
                                    style: GoogleFonts.poppins(
                                      // fontSize: 23,
                                      fontWeight: FontWeight.w500,
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
                                      child: Text(
                                        item['name'],
                                        style: GoogleFonts.poppins(
                                            // fontSize: 23,
                                            // fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                        color: Color.fromARGB(146, 84, 87, 94),
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
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      // hintText: "quantity",
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
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
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.justify,
                                    controller: sellingpricecontroller,
                                    decoration: const InputDecoration(
                                      labelText: "SellingPrice",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
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
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      // hintText: "sellingprice",
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
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
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
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
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      // hintText: "purchasing_price",
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
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.done,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.justify,
                                    controller: mrpcontroller,
                                    decoration: const InputDecoration(
                                      labelText: "Mrp",
                                      labelStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
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
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(143, 0, 140, 255),
                                          width: 2.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                      ),
                                      filled: true,
                                      fillColor: Colors.transparent,
                                      hintStyle: TextStyle(
                                        color:
                                            Color.fromARGB(146, 87, 111, 168),
                                        fontWeight: FontWeight.w400,
                                        fontSize: 16,
                                      ),
                                      // hintText: "mrp",
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
            ],
          ),
        ),
      ),
    );
  }
}
