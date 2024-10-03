import 'dart:convert';
import 'package:newbestshop/models/menuEnumModel.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/deleteProduct.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/floatingbutton.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/updateProduct.dart';
import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final quantity = TextEditingController(text: "1");
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
  int? selectedColorId;
  dynamic selectedsize;
  int? selectedsizeId;
  List<int> sizeId = [];
  String username = "";
  late String _token;

  TextEditingController editModelController = TextEditingController();
  TextEditingController editColorsController = TextEditingController();
  TextEditingController editSizeController = TextEditingController();

  TextEditingController addModelController = TextEditingController();
  TextEditingController addColorsController = TextEditingController();
  TextEditingController addSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchTokenAndbrand();
    getEmailFromPrefs();
  }

  Future<void> _fetchTokenAndbrand() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    fetchModelData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(3.5),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 5,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Model',
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ]),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return FloatingButton(
                                addImage: false,
                                controller: addModelController,
                                function: (modelName) {
                                  addModel(modelName);
                                },
                                titleText: "Add Model",
                                hintText: "Enter Model",
                              );
                            });
                      },
                      child: const Icon(Icons.add_circle),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.sizeOf(context).width,
                      child: DropdownButton(
                        isExpanded: true,
                        icon: const Visibility(
                          visible: false,
                          child: Icon(Icons.arrow_downward),
                        ),
                        borderRadius: BorderRadius.circular(10),
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        elevation: 1,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        hint: Text(
                          'Select a model',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
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
                            selectedsize = null;
                          });
                        },
                        items: _models.map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              item['name'],
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (selectedModel != null)
                      Positioned(
                        right: 0,
                        child: PopupMenuButton<String>(
                          elevation: 0,
                          iconColor: Colors.black,
                          color: Colors.white,
                          onSelected: (String choice) {
                            if (choice == MenuItems.update) {
                              editModelController = TextEditingController(
                                  text: selectedModel['name']);

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateproductDialog(
                                      controller: editModelController,
                                      function: (updatedModelName) {
                                        updateModel(
                                            updatedModelName, selectedModelId);
                                      },
                                    );
                                  });
                            } else if (choice == MenuItems.delete) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteproductDialog(
                                      id: selectedModelId!,
                                      function: (modelId) {
                                        deleteModel(modelId);
                                      },
                                    );
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Color',
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ]),
                    ),
                    if (selectedModel != null)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FloatingButton(
                                  addImage: false,
                                  controller: addColorsController,
                                  function: (colorName) {
                                    addColor(colorName, selectedModelId!);
                                  },
                                  titleText: "Add Color",
                                  hintText: "Enter color",
                                );
                              });
                        },
                        child: const Icon(Icons.add_circle),
                      )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey[400]!,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: DropdownButton(
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        icon: const Visibility(
                          visible: false,
                          child: Icon(Icons.arrow_downward),
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(10),
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        elevation: 1,
                        hint: Text(
                          'Select a color',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
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
                            selectedColorId = newValue['id'];
                            fetchColorSize(selectedColorId!);
                            selectedsize = null;
                          });
                        },
                        items: _colors.map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              item['name'],
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (selectedColor != null)
                      Positioned(
                        right: 0,
                        child: PopupMenuButton<String>(
                          elevation: 0,
                          iconColor: Colors.black,
                          color: Colors.white,
                          onSelected: (String choice) {
                            if (choice == MenuItems.update) {
                              editColorsController = TextEditingController(
                                  text: selectedColor['name']);

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateproductDialog(
                                      controller: editColorsController,
                                      function: (updatedColorName) {
                                        updateColor(updatedColorName,
                                            selectedColorId, selectedModelId!);
                                      },
                                    );
                                  });
                            } else if (choice == MenuItems.delete) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteproductDialog(
                                      id: selectedColorId!,
                                      function: (colorId) {
                                        deletecolor(colorId, selectedModelId!);
                                      },
                                    );
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
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Size',
                          style: TextStyle(
                            fontSize: 19,
                          ),
                        ),
                        TextSpan(
                          text: "*",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 19,
                          ),
                        ),
                      ]),
                    ),
                    if (selectedColor != null)
                      GestureDetector(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return FloatingButton(
                                  addImage: false,
                                  controller: addSizeController,
                                  function: (size) {
                                    addSize(size, selectedColorId!);
                                  },
                                  titleText: "Add Size",
                                  hintText: "Enter size",
                                );
                              });
                        },
                        child: const Icon(Icons.add_circle),
                      )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  alignment: Alignment.centerRight,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey[400]!),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.white,
                          ),
                        ],
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      width: MediaQuery.sizeOf(context).width,
                      child: DropdownButton(
                        icon: const Visibility(
                          visible: false,
                          child: Icon(Icons.arrow_downward),
                        ),
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(10),
                        underline: const SizedBox(),
                        dropdownColor: Colors.white,
                        elevation: 1,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        hint: Text(
                          'Select a size',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        value: selectedsize,
                        onChanged: (newValue) async {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('selectedsizename', newValue['name']);
                          sizeId = [newValue['id']];
                          setState(() {
                            selectedsize = newValue;
                            selectedsizeId = newValue['id'];
                          });
                        },
                        items: selectedsizelist
                            .map<DropdownMenuItem<dynamic>>((item) {
                          return DropdownMenuItem<dynamic>(
                            value: item,
                            child: Text(
                              item['name'],
                              style: GoogleFonts.poppins(),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    if (selectedsize != null)
                      Positioned(
                        right: 0,
                        child: PopupMenuButton<String>(
                          elevation: 0,
                          iconColor: Colors.black,
                          color: Colors.white,
                          onSelected: (String choice) {
                            if (choice == MenuItems.update) {
                              editSizeController = TextEditingController(
                                  text: selectedsize['name']);

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return UpdateproductDialog(
                                      controller: editSizeController,
                                      function: (updatedSize) {
                                        updateSize(updatedSize, selectedsizeId,
                                            selectedColorId!);
                                      },
                                    );
                                  });
                            } else if (choice == MenuItems.delete) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return DeleteproductDialog(
                                      id: selectedsizeId!,
                                      function: (sizeId) {
                                        deleteSize(sizeId, selectedColorId!);
                                      },
                                    );
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
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (selectedsize != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Quantity",
                                    style: TextStyle(
                                      // color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              TextFormField(
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
                                  hintText: "Enter the Quantity",
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
                                      color: Color.fromARGB(143, 0, 140, 255),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(143, 0, 140, 255),
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(10),
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(146, 87, 111, 168),
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  ),
                                  // hintText: "quantity",
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedsize != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Bill Number",
                                    style: TextStyle(
                                      // color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
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
                                    hintText: "Enter the BillNumber",
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
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(143, 0, 140, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(146, 87, 111, 168),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedsize != null)
                        // InputTextFieldWidget(
                        //     sellingpricecontroller, "sellingprice"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Selling Price",
                                    style: TextStyle(
                                      // color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
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
                                    hintText: "Enter the Selling price",
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
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(143, 0, 140, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(146, 87, 111, 168),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    // hintText: "sellingprice",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedsize != null)
                        // InputTextFieldWidget(
                        // purchasingpricecontroller, "purchasing price"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Purchasing Price",
                                    style: TextStyle(
                                      // color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
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
                                      color: Color.fromARGB(146, 87, 111, 168),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    hintText: "Enter the Purchasing price",
                                    isDense: true,
                                    contentPadding: EdgeInsets.only(
                                      left: 15,
                                      bottom: 39,
                                    ),
                                    alignLabelWithHint: true,
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(143, 0, 140, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(143, 0, 140, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(146, 87, 111, 168),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    // hintText: "purchasing_price",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      if (selectedsize != null)
                        // InputTextFieldWidget(mrpcontroller, "Mrp"),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 13),
                          child: Column(
                            children: [
                              const Row(
                                children: [
                                  Text(
                                    "Mrp",
                                    style: TextStyle(
                                      // color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                  Text(
                                    "*",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 19,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Container(
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
                                    hintText: "Enter the Mrp",
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
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey,
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(143, 0, 140, 255),
                                        width: 1.0,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    filled: true,
                                    fillColor: Colors.white,
                                    hintStyle: TextStyle(
                                      color: Color.fromARGB(146, 87, 111, 168),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16,
                                    ),
                                    // hintText: "mrp",
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      const SizedBox(
                        height: 10,
                      ),
                      if (selectedsize != null)
                        GestureDetector(
                          onTap: _showConfirmationDialog,
                          child: Container(
                            height: 60,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.add,
                                  color: Colors.white,
                                ),
                                Text(
                                  "Add",
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
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> getEmailFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  Future<void> fetchModelData() async {
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

  Future<void> updateModel(String? model, int? modelId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.branddrop}${widget.modelId}');
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": modelId,
            "name": model,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedModel = null;
          selectedModelId = null;
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchModelData();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> addModel(String? model) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.branddrop}${widget.modelId}');
      final response = await http.post(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "brand": widget.modelId,
            "name": model,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedModel = null;
          selectedModelId = null;
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchModelData();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deleteModel(int? modelId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.branddrop}${widget.modelId}');
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": modelId,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedModel = null;
          selectedModelId = null;
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchModelData();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
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

  Future<void> updateColor(
      String? color, int? colorId, int _selectedModelId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.modeldrop}$_selectedModelId');
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": colorId,
            "name": color,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorData(_selectedModelId);
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> addColor(String? color, int _selectedModelId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.modeldrop}$_selectedModelId');
      final response = await http.post(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "model": _selectedModelId,
            "name": color,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorData(_selectedModelId);
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deletecolor(int? colorId, int _selectedModelId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.modeldrop}$_selectedModelId');
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": colorId,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedColorId = null;
          selectedColor = null;
          _colors = [];
          selectedsizeId = null;
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorData(_selectedModelId);
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
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

  Future<void> updateSize(String? size, int? sizeId, int selectedsizeId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.colordrop}$selectedsizeId');
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": sizeId,
            "name": size,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorSize(selectedsizeId);
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> addSize(String? size, int selectedsizeId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.colordrop}$selectedsizeId');
      final response = await http.post(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "color": selectedsizeId,
            "name": size,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorSize(selectedsizeId);
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> deleteSize(int? sizeId, int selectedsizeId) async {
    try {
      final Uri apiUri = Uri.parse(
          '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.colordrop}$selectedsizeId');
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": sizeId,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          selectedsize = null;
          selectedsizelist = [];
        });
        fetchColorSize(selectedsizeId);

        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
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
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: const Text(
                "Error!",
              ),
              children: [
                Text(
                  e.toString(),
                ),
              ],
            );
          });
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
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        dismissDirection: DismissDirection.startToEnd,
        shape: const StadiumBorder(),
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showConfirmationDialog() {
    if (quantity.text.isEmpty ||
        billnumbercontroller.text.isEmpty ||
        sellingpricecontroller.text.isEmpty ||
        purchasingpricecontroller.text.isEmpty ||
        mrpcontroller.text.isEmpty) {
      _showSnackbar("Please fill in all fields.");
      return;
    }

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
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(
                      EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 32,
                      ),
                    ),
                    backgroundColor: WidgetStatePropertyAll(
                      Color(0xFF4860b5),
                    ),
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  child: Text(
                    "Yes",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
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
}
