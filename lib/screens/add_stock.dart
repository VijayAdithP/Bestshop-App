// import 'dart:convert';
// import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:newbestshop/screens/widgets/input_fields.dart';
// import 'package:newbestshop/models/api_data.dart';
// import 'package:get/get.dart';
// import 'main_page.dart';
import 'package:newbestshop/screens/each_stock.dart/bill_page.dart';
import 'package:newbestshop/screens/each_stock.dart/brand_page.dart';
import 'package:newbestshop/screens/each_stock.dart/categoty_page.dart';
import 'package:newbestshop/screens/each_stock.dart/itemname_page.dart';
import 'package:newbestshop/screens/each_stock.dart/subcategory_page.dart';
import 'package:easy_stepper/easy_stepper.dart';

class stockadder extends StatefulWidget {
  const stockadder({super.key});

  @override
  State<stockadder> createState() => _stockadderState();
}

class _stockadderState extends State<stockadder> {
  List<String> imgList = [];
  List<String> nameList = [];

  String Categoryname = '';
  String itemnamename = '';
  String Subcategoryname = '';
  String brandname = '';

  String CategoryImg = '';
  String itemnameImg = '';
  String SubcategoryImg = '';
  String brandnImg = '';

  int activeStep = 1;

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final selectedCategoryImg = prefs.getString('selectedCategoryImg') ?? '';
      final selecteditem_nameImg = prefs.getString('selecteditemnameImg') ?? '';
      final selectedSubcategoryImg =
          prefs.getString('selectedsubcategoryImg') ?? '';
      final selectedbrandImg = prefs.getString('selectedbrandImg') ?? '';

      final selectedCategoryname =
          prefs.getString('selectedCategoryname') ?? '';
      final selecteditemnamename = prefs.getString('selecteditemname') ?? '';
      final selectedSubcategoryname =
          prefs.getString('selectedsubcategoryname') ?? '';
      final selectedbrandname = prefs.getString('selectedbrandname') ?? '';

      Categoryname = selectedCategoryname;
      itemnamename = selecteditemnamename;
      Subcategoryname = selectedSubcategoryname;
      brandname = selectedbrandname;

      CategoryImg = selectedCategoryImg;
      itemnameImg = selecteditem_nameImg;
      SubcategoryImg = selectedSubcategoryImg;
      brandnImg = selectedbrandImg;

      imgList = [
        selectedCategoryImg,
        selecteditem_nameImg,
        selectedSubcategoryImg,
        selectedbrandImg,
      ];
      nameList = [
        selectedCategoryname,
        selecteditemnamename,
        selectedSubcategoryname,
        selectedbrandname,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 0.50,
                    spreadRadius: 0.1,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (nameList.isNotEmpty)
                    EasyStepper(
                      activeStep: activeStep,
                      lineStyle: const LineStyle(
                        lineLength: 10,
                      ),
                      // stepShape: StepShape.rRectangle,
                      // stepBorderRadius: 30,
                      borderThickness: 2,
                      // padding: const EdgeInsets.all(8),
                      stepRadius: 36,
                      // finishedStepBorderColor: Colors.deepOrange,
                      // finishedStepTextColor: Colors.deepOrange,
                      // finishedStepBackgroundColor: Colors.deepOrange,
                      // activeStepIconColor: Colors.deepOrange, 
                      showLoadingAnimation: false,
                      disableScroll: true,
                      showStepBorder: false,
                      steps: [
                        EasyStep(
                          customStep: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  '${ApiEndPoints.baseUrl}/$CategoryImg')),
                          customTitle: Text(
                            Categoryname,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  '${ApiEndPoints.baseUrl}/$itemnameImg')),
                          customTitle:  Text(
                            itemnamename,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  '${ApiEndPoints.baseUrl}/$SubcategoryImg')),
                          customTitle:  Text(
                            Subcategoryname,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        EasyStep(
                          customStep: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(
                                  '${ApiEndPoints.baseUrl}/$brandnImg')),
                          customTitle:  Text(
                            brandname,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                      onStepReached: (index) =>
                          setState(() => activeStep = index),
                    )
                  else
                    const Center(
                      child: Text(
                        "Select a Category",
                        style: TextStyle(fontSize: 19),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: PageViewCustom(reloadData: loadData),
          ),
        ],
      ),
    );
  }
}

class PageViewCustom extends StatefulWidget {
  final VoidCallback? reloadData;
  const PageViewCustom({super.key, this.reloadData});

  @override
  State<PageViewCustom> createState() => _PageViewCustomState();
}

class _PageViewCustomState extends State<PageViewCustom> {
  late int category_Id = 0;
  late int itemnameId = 0;
  late int brandId = 0;
  late int modelId = 0;

  void callReloadData() {
    if (widget.reloadData != null) {
      widget.reloadData!();
    }
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      final int selectedCategoryId = prefs.getInt('selectedCategoryId') ?? 0;
      final int selecteditem_nameId = prefs.getInt('selecteditemnameId') ?? 0;
      final int selectedsub_categoryId =
          prefs.getInt('selectedsubcategoryId') ?? 0;
      final int selectedbrandId = prefs.getInt('selectedbrandId') ?? 0;

      category_Id = selectedCategoryId;
      itemnameId = selecteditem_nameId;
      brandId = selectedsub_categoryId;
      modelId = selectedbrandId;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageViewChange);
  }

  void _onPageViewChange() {
    loadData();
    callReloadData();
  }

  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        scrollDirection: Axis.horizontal,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          CategoryPage(controller: _pageController),
          ItemNamePage(
            category_Id: category_Id,
            controller: _pageController,
          ),
          subcategoryPage(
            itemnameId: itemnameId,
            controller: _pageController,
          ),
          brandPage(
            brandId: brandId,
            controller: _pageController,
          ),
          BillingPage(
            modelId: modelId,
            controller: _pageController,
          ),
        ],
      ),
    );
  }
}
