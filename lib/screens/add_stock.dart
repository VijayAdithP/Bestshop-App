import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/screens/each_stock.dart/bill_page.dart';
import 'package:newbestshop/screens/each_stock.dart/brand_page.dart';
import 'package:newbestshop/screens/each_stock.dart/categoty_page.dart';
import 'package:newbestshop/screens/each_stock.dart/itemname_page.dart';
import 'package:newbestshop/screens/each_stock.dart/subcategory_page.dart';
import 'package:easy_stepper/easy_stepper.dart';
import 'package:google_fonts/google_fonts.dart';

final _pageController = PageController();

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
    if (mounted) {
      setState(() {
        final selectedCategoryImg =
            prefs.getString('selectedCategoryImg') ?? '';
        final selecteditem_nameImg =
            prefs.getString('selecteditemnameImg') ?? '';
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

        nameList = [
          selectedCategoryname,
          selecteditemnamename,
          selectedSubcategoryname,
          selectedbrandname,
        ];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: Text(
          "Add Stocks",
          style: GoogleFonts.poppins(
            // fontSize: 24,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        leading: InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          child: const Icon(
            Icons.menu,
            color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        // backgroundColor: const Color(0xFF4860b5),
        backgroundColor: HexColor("#6A42C2"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Container(
              width: double.infinity,
              height: 141,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 5,
                    spreadRadius: 0.5,
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (nameList.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: EasyStepper(
                        activeStep: activeStep,
                        lineStyle: const LineStyle(
                          lineLength: 10,
                        ),
                        borderThickness: 2,
                        stepRadius: 36,
                        showLoadingAnimation: false,
                        disableScroll: true,
                        showStepBorder: false,
                        steps: [
                          EasyStep(
                            customStep: GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('selecteditemname');
                                prefs.remove('selectedsubcategoryname');
                                prefs.remove('selectedbrandname');
                                prefs.remove('selectedCategoryId');
                                prefs.remove('selecteditemnameId');
                                prefs.remove('selectedsubcategoryId');
                                prefs.remove('selectedbrandId');

                                prefs.remove('selecteditemnameImg');
                                prefs.remove('selectedsubcategoryImg');
                                prefs.remove('selectedbrandImg');

                                _pageController.animateToPage(0,
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeIn);
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiEndPoints.baseUrl}/$CategoryImg',
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
                              //       '${ApiEndPoints.baseUrl}/$CategoryImg'),
                              // ),
                            ),
                            customTitle: Text(
                              Categoryname,
                              textAlign: TextAlign.center,
                              // style: const TextStyle(
                              //
                              // ),
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            // onTap: () {},
                          ),
                          EasyStep(
                            customStep: GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('selectedsubcategoryname');
                                prefs.remove('selectedbrandname');
                                prefs.remove('selectedsubcategoryId');
                                prefs.remove('selectedbrandId');

                                prefs.remove('selectedsubcategoryImg');
                                prefs.remove('selectedbrandImg');

                                if (prefs.getString('selecteditemname') !=
                                        null ||
                                    prefs.getString('selecteditemnameImg') !=
                                        null) {
                                  _pageController.animateToPage(1,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiEndPoints.baseUrl}/$itemnameImg',
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
                              //     radius: 50,
                              //     backgroundImage: NetworkImage(
                              //         '${ApiEndPoints.baseUrl}/$itemnameImg')),
                            ),
                            customTitle: Text(
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              itemnamename,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          EasyStep(
                            customStep: GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.remove('selectedbrandname');
                                prefs.remove('selectedbrandId');
                                prefs.remove('selectedbrandImg');

                                if (prefs.getString(
                                            'selectedsubcategoryname') !=
                                        null ||
                                    prefs.getString('selectedsubcategoryId') !=
                                        null ||
                                    prefs.getString('selectedsubcategoryImg') !=
                                        null) {
                                  _pageController.animateToPage(2,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiEndPoints.baseUrl}/$SubcategoryImg',
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
                              //     radius: 50,
                              //     backgroundImage: NetworkImage(
                              //         '${ApiEndPoints.baseUrl}/$SubcategoryImg')),
                            ),
                            customTitle: Text(
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              Subcategoryname,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          EasyStep(
                            customStep: GestureDetector(
                              onTap: () async {
                                final SharedPreferences prefs =
                                    await SharedPreferences.getInstance();

                                if (prefs.getString('selectedbrandname') !=
                                        null ||
                                    prefs.getString('selectedbrandId') !=
                                        null ||
                                    prefs.getString('selectedbrandImg') !=
                                        null) {
                                  _pageController.animateToPage(3,
                                      duration:
                                          const Duration(milliseconds: 300),
                                      curve: Curves.easeIn);
                                }
                              },
                              child: CircleAvatar(
                                radius: 50,
                                backgroundColor: Colors.white,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      '${ApiEndPoints.baseUrl}/$brandnImg',
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
                              //       '${ApiEndPoints.baseUrl}/$brandnImg'),
                              // ),
                            ),
                            customTitle: Text(
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                              brandname,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                        onStepReached: (index) =>
                            setState(() => activeStep = index),
                      ),
                    )
                  else
                    Center(
                      child: Text(
                        "Select a Category",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // const Divider(),
          Expanded(
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
    if (mounted) {
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
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_onPageViewChange);
    setState(() {});
  }

  void _onPageViewChange() {
    loadData();
    callReloadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: PageView(
        scrollBehavior: const ScrollBehavior(),
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
