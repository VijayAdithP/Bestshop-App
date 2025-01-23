import 'dart:io';

import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/models/locationModel.dart';
import 'package:newbestshop/screens/widgets/Add%20Stock/deleteProduct.dart';
import 'dart:convert';
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:newbestshop/utils/color.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:uuid/uuid.dart';

class Expandtile extends StatefulWidget {
  const Expandtile({super.key});

  @override
  State<Expandtile> createState() => _ExpandtileState();
}

class _ExpandtileState extends State<Expandtile> {
  late TextEditingController idController;
  late TextEditingController quantityController;
  late TextEditingController sellingPriceController;
  late TextEditingController mrpController;

  @override
  void initState() {
    super.initState();
    _futureStockItems = fetchStockItemsGroupedByShop(_selectedDate!);
    _fetchTokenAndItemNames();
    getShopLocation();
  }

  late String _token;
  Future<void> _fetchTokenAndItemNames() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    setState(() {
      _token = token;
    });
    getShopLocation();
  }

  Future<Map<String, List<Map<String, dynamic>>>> fetchStockItemsGroupedByShop(
      DateTime selectedDate) async {
    String formattedDate =
        "${selectedDate.year}-${selectedDate.month}-${selectedDate.day}";
    String api =
        '${ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stockview}$formattedDate&shop_location=$selectedLocation';

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse(api),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        Map<String, List<Map<String, dynamic>>> groupedItems = {};
        for (var item in jsonData) {
          String shop = item['shop'];
          if (!groupedItems.containsKey(shop)) {
            groupedItems[shop] = [];
          }
          groupedItems[shop]!.add(item);
        }
        return groupedItems;
      } else {
        throw Exception('Failed to load stock items: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load stock items: $e');
    }
  }

  Future<void> getShopLocation() async {
    if (mounted) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';

      try {
        final response = await http.get(
          Uri.parse(
              ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.getLocation),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          final List<dynamic> data = jsonDecode(response.body);
          setState(() {
            locations = data.map((shop) => Location.fromJson(shop)).toList();
          });
        } else {
          throw Exception('Failed to load shop locations');
        }
      } catch (e) {
        throw Exception('Error: $e');
      }
    }
  }

  Future<void> downloadCsvFile(int? locationIndex) async {
    var uuid = Uuid();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    String formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";

    try {
      if (!await _requestStoragePermission()) {
        print('Storage permission denied');
        return;
      }
      if (true) {
        final Uri uri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.downloadCSV,
        ).replace(
          queryParameters: {
            'date': formattedDate,
            'shop_location': locationIndex.toString(),
          },
        );

        final response =
            await http.get(uri, headers: {'Authorization': 'Bearer $token'});

        if (response.statusCode == 200) {
          final directory = await getExternalStorageDirectory();
          final filePath = '${directory!.path}/$formattedDate';
          final file = File(filePath);

          await file.writeAsBytes(response.bodyBytes);

          print('File saved at: $filePath');

          // Try opening the file
          final result = await OpenFile.open(filePath);
          if (result.type != ResultType.done) {
            print('Error opening PDF: ${result.message}');
          }
          print('OpenFile result: ${result.type}, message: ${result.message}');
        }
      }
    } catch (e) {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              children: [
                Text(e.toString()),
              ],
            );
          });
    }
  }

  Future<bool> _requestStoragePermission() async {
    if (await Permission.manageExternalStorage.isGranted) {
      return true;
    }

    final status = await Permission.manageExternalStorage.request();

    if (status.isGranted) {
      return true;
    } else {
      print('Storage permission denied.');
    }

    return false;
  }
//   Future<void> downloadCsvFile(int? locationIndex) async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final token = prefs.getString('token') ?? '';
//     String formattedDate =
//         "${_selectedDate!.year}-${_selectedDate!.month}-${_selectedDate!.day}";

//     try {
//       if (await _requestStoragePermission()) {}

//       final Uri uri = Uri.parse(
//         ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.downloadCSV,
//       ).replace(
//         queryParameters: {
//           'date': formattedDate,
//           'shop_location': locationIndex.toString(),
//         },
//       );

//       final response =
//           await http.get(uri, headers: {'Authorization': 'Bearer $token'});

//       if (response.statusCode == 200) {
//         final directory =
//             await getExternalStorageDirectory(); // Ensure correct directory
//         final filePath =
//             '${directory!.path}/exported_stock.csv'; // Define the file path
//         final file = File(filePath);

//         await file.writeAsBytes(response.bodyBytes); // Save the file

//         print('File saved at: $filePath'); // Debugging to check file path

// // Open the file
//         final result = await OpenFile.open(filePath);
  // if (result.type != ResultType.done) {
  //   print('Error opening PDF: ${result.message}');
  // }
//       }
//     } catch (e) {
//       showDialog(
//           context: context,
//           builder: (context) {
//             return SimpleDialog(
//               children: [
//                 Text(e.toString()),
//               ],
//             );
//           });
//     }
//   }

  Future<void> deleteStock(int? stockId) async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stocksDelete);
      final response = await http.delete(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": stockId,
          },
        ),
      );
      if (response.statusCode == 200) {
        setState(() {
          _futureStockItems = fetchStockItemsGroupedByShop(_selectedDate!);
        });
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  Future<void> updateStock(String? quantity, String? stockId,
      String? sellingPrice, String? mrp) async {
    try {
      final Uri apiUri = Uri.parse(
          ApiEndPoints.baseUrl + ApiEndPoints.authEndpoints.stocksedit);
      final response = await http.put(
        apiUri,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            "id": stockId,
            "quantity": quantity,
            "selling_price": sellingPrice,
            "mrp": mrp,
          },
        ),
      );
      if (response.statusCode == 200) {
        // _fetchItemNames();
        Navigator.of(context).pop();
      } else {
        print("Request failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print("Error occurred: $e");
    }
  }

  late Future<Map<String, List<Map<String, dynamic>>>>? _futureStockItems;
  DateTime? _selectedDate = DateTime.now();
  List<Location> locations = [];
  List<Location> downloadLocations = [];
  Set<String> selectedShopIds = {};
  int? selectedLocationId;
  int tag = 1;
  List<String> tags = [];
  bool isSelected = false;
  int selectedLocation = 1;
  GlobalKey<FormState> editStockKey = GlobalKey<FormState>();
  Set<int> selectedIndices = {};
  int? selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Inventory",
          style: GoogleFonts.poppins(
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

        actions: [
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, stfSetState) {
                      return Dialog(
                        child: SizedBox(
                          height: 400,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              right: 10,
                              left: 10,
                              bottom: 20,
                              top: 10,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: locations.length,
                                    itemBuilder: (context, index) {
                                      return RadioListTile<int>(
                                        selectedTileColor: HexColor("#563A9C"),
                                        shape: const RoundedRectangleBorder(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(15))),
                                        title: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          child: Text(
                                            locations[index].name!,
                                            style: TextStyle(
                                              color: selectedIndex == index
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                        ),
                                        value: index,
                                        groupValue: selectedIndex,
                                        activeColor: Colors.white,
                                        tileColor: selectedIndex == index
                                            ? HexColor("#563A9C")
                                            : Colors.transparent,
                                        selected: selectedIndex == index,
                                        onChanged: (int? value) {
                                          stfSetState(() {
                                            selectedIndex = value;
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 30,
                                ),
                                IntrinsicHeight(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 17),
                                          ),
                                        ),
                                      ),
                                      VerticalDivider(
                                        color:
                                            Colors.grey.withValues(alpha: 0.5),
                                        thickness: 1,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          downloadCsvFile(selectedIndex! + 1);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                          ),
                                          child: Text(
                                            "yes",
                                            style: TextStyle(
                                                color: Color.fromRGBO(
                                                    72, 96, 181, 1),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 17),
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
                    },
                  );
                },
              );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Icon(
                Icons.download,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.grey.shade200,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            locations.isNotEmpty
                ? ChipsChoice.single(
                    padding: EdgeInsets.zero,
                    choiceStyle: C2ChipStyle.toned(
                      foregroundColor: Colors.black,
                      selectedStyle: const C2ChipStyle(
                        elevation: 0,
                      ),
                    ),
                    value: tag.toString(),
                    onChanged: (val) {
                      setState(() {
                        tag = int.tryParse(val) ?? 0;
                        selectedLocation = tag;
                        _futureStockItems =
                            fetchStockItemsGroupedByShop(_selectedDate!);
                      });
                    },
                    choiceCheckmark: true,
                    choiceItems: C2Choice.listFrom<String, Location>(
                      style: (index, location) => const C2ChipStyle(
                        height: 40,
                        avatarForegroundStyle: TextStyle(fontSize: 15),
                        foregroundStyle: TextStyle(fontSize: 15),
                      ),
                      source: locations,
                      value: (index, location) => location.id?.toString() ?? '',
                      label: (index, location) => location.name ?? 'Unknown',
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ElevatedButton.icon(
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Pick a date",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (_selectedDate != null)
                        FittedBox(
                          child: Text(
                            DateFormat.yMEd().format(_selectedDate!),
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),
                  icon: const Icon(
                    Icons.edit_calendar,
                    color: Colors.white,
                  ),
                  style: ButtonStyle(
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide.none,
                      ),
                    ),
                    backgroundColor: WidgetStateProperty.all<Color>(
                      const Color.fromRGBO(106, 66, 194, 1),
                    ),
                  ),
                  onPressed: () async {
                    DateTime? picked = await showDialog<DateTime>(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          backgroundColor: lighterbackgroundblue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.0),
                            child: Container(
                              height: 400,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SfDateRangePicker(
                                  view: DateRangePickerView.month,
                                  selectionMode:
                                      DateRangePickerSelectionMode.single,
                                  initialSelectedDate: _selectedDate,
                                  onSelectionChanged:
                                      (DateRangePickerSelectionChangedArgs
                                          args) {
                                    Navigator.of(context).pop(args.value);
                                  },
                                  todayHighlightColor: greyblue,
                                  backgroundColor: lighterbackgroundblue,
                                  selectionTextStyle: TextStyle(
                                    color: lighterbackgroundblue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  selectionColor: greyblue,
                                  monthCellStyle: DateRangePickerMonthCellStyle(
                                    todayTextStyle: TextStyle(
                                      color: greyblue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    textStyle: TextStyle(
                                      color: greyblue,
                                    ),
                                  ),
                                  headerStyle: DateRangePickerHeaderStyle(
                                    backgroundColor: lighterbackgroundblue,
                                    textStyle: TextStyle(
                                      color: greyblue,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  monthViewSettings:
                                      DateRangePickerMonthViewSettings(
                                    viewHeaderStyle:
                                        DateRangePickerViewHeaderStyle(
                                      textStyle: TextStyle(
                                        color: greyblue,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );

                    if (picked != null) {
                      setState(() {
                        _selectedDate = picked;
                        _futureStockItems =
                            fetchStockItemsGroupedByShop(_selectedDate!);
                      });
                    }

                    // final DateTime? picked = await showDatePicker(
                    //   context: context,
                    //   initialDate: DateTime.now(),
                    //   firstDate: DateTime(2000),
                    //   lastDate: DateTime(2100),
                    //   builder: (BuildContext context, Widget? child) {
                    //     return Theme(
                    //       data: ThemeData.dark().copyWith(
                    //         colorScheme: const ColorScheme.light(
                    //           primary: Colors.white,
                    //           onPrimary: Color(0xFF4860b5),
                    //           onSurface: Color(0xFF4860b5),
                    //         ),
                    //         textButtonTheme: TextButtonThemeData(
                    //           style: TextButton.styleFrom(
                    //             backgroundColor: const Color(0xFF4860b5),
                    //           ),
                    //         ),
                    //         textTheme: TextTheme(
                    //           headlineLarge:
                    //               Theme.of(context).textTheme.headlineLarge,
                    //           titleLarge:
                    //               Theme.of(context).textTheme.headlineLarge,
                    //         ),
                    //       ),
                    //       child: child!,
                    //     );
                    //   },
                    // );
                    // if (picked != null) {
                    //   setState(() {
                    //     _selectedDate = picked;
                    //     _futureStockItems =
                    //         fetchStockItemsGroupedByShop(_selectedDate!);
                    //   });
                    // }
                  },
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            // if (_futureStockItems == null)
            if (_selectedDate != null && _futureStockItems != null)
              Expanded(
                child: FutureBuilder<Map<String, List<Map<String, dynamic>>>>(
                  future: _futureStockItems,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (_futureStockItems == null) {
                      return const Text("no data");
                    } else {
                      final Map<String, List<Map<String, dynamic>>>
                          groupedItems = snapshot.data!;
                      final tableHeaders = [
                        'User',
                        'ID',
                        'Shop',
                        'Date',
                        'Time',
                        'Name',
                        'Model Name',
                        'Color Name',
                        'Size Name',
                        'Quantity',
                        'Selling Price',
                        'MRP',
                        'Total Price',
                        'Edit',
                        'Delete',
                      ];
                      return ListView(
                        children: groupedItems.keys.map((shop) {
                          return Card(
                            color: Colors.white,
                            shadowColor: Colors.black,
                            elevation: 0,
                            surfaceTintColor: Colors.white,
                            child: ExpansionTile(
                              initiallyExpanded: true,
                              shape: const Border(),
                              title: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  shop,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: SingleChildScrollView(
                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          top: 1,
                                          left: 5,
                                          right: 5,
                                          bottom: 5,
                                        ),
                                        child: DataTable(
                                          columnSpacing: 30.0,
                                          horizontalMargin: 12.0,
                                          dataRowMaxHeight: 70,
                                          columns: tableHeaders
                                              .map(
                                                (header) => DataColumn(
                                                  label: Text(
                                                    header,
                                                    style: GoogleFonts.poppins(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: const Color(
                                                          0xFF4860b5),
                                                    ),
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          rows: groupedItems[shop]!.map((item) {
                                            return DataRow(
                                              cells: [
                                                DataCell(Text(
                                                    item['user']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['id']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['shop']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['date']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['time']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['name']?.toString() ??
                                                        '')),
                                                DataCell(Text(item['model_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['color_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['size_name']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(item['quantity']
                                                        ?.toString() ??
                                                    '')),
                                                DataCell(Text(
                                                    item['selling_price']
                                                            ?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['mrp']?.toString() ??
                                                        '')),
                                                DataCell(Text(
                                                    item['total_price']
                                                            ?.toString() ??
                                                        '')),
                                                DataCell(GestureDetector(
                                                  onTap: () {
                                                    idController =
                                                        TextEditingController(
                                                            text: item['id']
                                                                .toString());

                                                    quantityController =
                                                        TextEditingController(
                                                            text: item[
                                                                    'quantity']
                                                                .toString());

                                                    sellingPriceController =
                                                        TextEditingController(
                                                            text: item[
                                                                    'selling_price']
                                                                .toString());

                                                    mrpController =
                                                        TextEditingController(
                                                            text: item['mrp']
                                                                .toString());
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return Form(
                                                            key: editStockKey,
                                                            child: SimpleDialog(
                                                              backgroundColor:
                                                                  Colors.grey
                                                                      .shade100,
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15.0),
                                                              ),
                                                              title: const Text(
                                                                  "Edit Stocks:"),
                                                              titleTextStyle:
                                                                  const TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 23,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .symmetric(
                                                                    horizontal:
                                                                        10,
                                                                    vertical:
                                                                        10,
                                                                  ),
                                                                  child: Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .min,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Row(
                                                                          children: [
                                                                            Text(
                                                                              "Id",
                                                                              style: TextStyle(
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
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              idController,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return '';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            helperText:
                                                                                ' ',
                                                                            isDense:
                                                                                true,
                                                                            contentPadding:
                                                                                const EdgeInsets.only(
                                                                              left: 15,
                                                                              bottom: 39,
                                                                            ),
                                                                            alignLabelWithHint:
                                                                                true,
                                                                            border:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: HexColor("#8B5DFF"),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorStyle:
                                                                                const TextStyle(height: 0),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            hintStyle:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color.fromARGB(146, 87, 111, 168),
                                                                            ),
                                                                            hintText:
                                                                                'Id',
                                                                          ),
                                                                        ),
                                                                        const Row(
                                                                          children: [
                                                                            Text(
                                                                              "Quantity",
                                                                              style: TextStyle(
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
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              quantityController,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return '';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            helperText:
                                                                                ' ',
                                                                            isDense:
                                                                                true,
                                                                            contentPadding:
                                                                                const EdgeInsets.only(
                                                                              left: 15,
                                                                              bottom: 39,
                                                                            ),
                                                                            alignLabelWithHint:
                                                                                true,
                                                                            border:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: HexColor("#8B5DFF"),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorStyle:
                                                                                const TextStyle(height: 0),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            hintStyle:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color.fromARGB(146, 87, 111, 168),
                                                                            ),
                                                                            hintText:
                                                                                'quantity',
                                                                          ),
                                                                        ),
                                                                        const Row(
                                                                          children: [
                                                                            Text(
                                                                              "Selling Price",
                                                                              style: TextStyle(
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
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          textInputAction:
                                                                              TextInputAction.next,
                                                                          controller:
                                                                              sellingPriceController,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return '';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            helperText:
                                                                                ' ',
                                                                            isDense:
                                                                                true,
                                                                            contentPadding:
                                                                                const EdgeInsets.only(
                                                                              left: 15,
                                                                              bottom: 39,
                                                                            ),
                                                                            alignLabelWithHint:
                                                                                true,
                                                                            border:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: HexColor("#8B5DFF"),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorStyle:
                                                                                const TextStyle(height: 0),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            hintStyle:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color.fromARGB(146, 87, 111, 168),
                                                                            ),
                                                                            hintText:
                                                                                'sellingPrice',
                                                                          ),
                                                                        ),
                                                                        const Text(
                                                                          "Mrp",
                                                                          style:
                                                                              TextStyle(
                                                                            fontSize:
                                                                                19,
                                                                          ),
                                                                        ),
                                                                        const SizedBox(
                                                                          height:
                                                                              5,
                                                                        ),
                                                                        TextFormField(
                                                                          textAlignVertical:
                                                                              TextAlignVertical.center,
                                                                          textAlign:
                                                                              TextAlign.justify,
                                                                          textInputAction:
                                                                              TextInputAction.done,
                                                                          controller:
                                                                              mrpController,
                                                                          autovalidateMode:
                                                                              AutovalidateMode.onUserInteraction,
                                                                          validator:
                                                                              (value) {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return '';
                                                                            }
                                                                            return null;
                                                                          },
                                                                          decoration:
                                                                              InputDecoration(
                                                                            helperText:
                                                                                ' ',
                                                                            isDense:
                                                                                true,
                                                                            contentPadding:
                                                                                const EdgeInsets.only(
                                                                              left: 15,
                                                                              bottom: 39,
                                                                            ),
                                                                            alignLabelWithHint:
                                                                                true,
                                                                            border:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            focusedBorder:
                                                                                OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: HexColor("#8B5DFF"),
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: const BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            enabledBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.transparent,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorBorder:
                                                                                const OutlineInputBorder(
                                                                              borderSide: BorderSide(
                                                                                color: Colors.red,
                                                                                width: 2.0,
                                                                              ),
                                                                              borderRadius: BorderRadius.all(
                                                                                Radius.circular(10),
                                                                              ),
                                                                            ),
                                                                            errorStyle:
                                                                                const TextStyle(height: 0),
                                                                            filled:
                                                                                true,
                                                                            fillColor:
                                                                                Colors.white,
                                                                            hintStyle:
                                                                                GoogleFonts.poppins(
                                                                              fontSize: 16,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: const Color.fromARGB(146, 87, 111, 168),
                                                                            ),
                                                                            hintText:
                                                                                'mrp',
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(
                                                                            vertical:
                                                                                15,
                                                                          ),
                                                                          child:
                                                                              IntrinsicHeight(
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                              children: [
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.only(
                                                                                      left: 10,
                                                                                      right: 10,
                                                                                    ),
                                                                                    child: Text(
                                                                                      "No",
                                                                                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500, fontSize: 17),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                VerticalDivider(
                                                                                  color: Colors.grey.withOpacity(0.5),
                                                                                  thickness: 1,
                                                                                ),
                                                                                GestureDetector(
                                                                                  onTap: () {
                                                                                    if (editStockKey.currentState!.validate()) {
                                                                                      updateStock(quantityController.text, idController.text, sellingPriceController.text, mrpController.text);
                                                                                      setState(() {
                                                                                        _futureStockItems = fetchStockItemsGroupedByShop(_selectedDate!);
                                                                                      });
                                                                                    } else {
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        const SnackBar(
                                                                                          content: Text('Please fill in all fields.'),
                                                                                        ),
                                                                                      );
                                                                                    }
                                                                                  },
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.only(
                                                                                      left: 10,
                                                                                      right: 10,
                                                                                    ),
                                                                                    child: Text(
                                                                                      "yes",
                                                                                      style: TextStyle(color: Color.fromRGBO(72, 96, 181, 1), fontWeight: FontWeight.bold, fontSize: 17),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ]),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        });
                                                  },
                                                  child: const Icon(
                                                    Icons.edit,
                                                    size: 20,
                                                    color: Color(0xFF4860b5),
                                                  ),
                                                )),
                                                DataCell(GestureDetector(
                                                  onTap: () {
                                                    showDialog(
                                                        context: context,
                                                        builder: (context) {
                                                          return DeleteproductDialog(
                                                            id: item['id'],
                                                            function:
                                                                (stockId) {
                                                              print("its in");
                                                              deleteStock(
                                                                  stockId);
                                                            },
                                                          );
                                                        });
                                                  },
                                                  child: const Icon(
                                                    Icons.delete,
                                                    size: 20,
                                                    color: Colors.red,
                                                  ),
                                                )),
                                              ],
                                            );
                                          }).toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class StockItem {
  final String? user;
  final String? id;
  final String? shop;
  final String? date;
  final String? time;
  final String? name;
  final String? model_name;
  final String? color_name;
  final String? size_name;
  final String? quantity;
  final String? selling_price;
  final String? mrp;
  final String? total_price;
  StockItem({
    this.selling_price,
    this.user,
    this.id,
    this.shop,
    this.date,
    this.time,
    this.name,
    this.model_name,
    this.color_name,
    this.size_name,
    this.quantity,
    this.mrp,
    this.total_price,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      user: json['user'],
      id: json['id'],
      shop: json['shop'],
      date: json['date'],
      time: json['time'],
      name: json['name'],
      model_name: json['model_name'],
      color_name: json['color_name'],
      size_name: json['size_name'],
      quantity: json['quantity'],
      mrp: json['mrp'],
      total_price: json['total_price'],
      selling_price: json['selling_price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user,
      "id": id,
      "shop": shop,
      "date": date,
      "time": time,
      "name": name,
      "model_name": model_name,
      "color_name": color_name,
      "size_name": size_name,
      "quantity": quantity,
      "mrp": mrp,
      "total_price": total_price,
      "selling_price": selling_price,
    };
  }
}
