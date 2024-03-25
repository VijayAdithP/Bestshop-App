import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';

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
                    widget.controller.animateToPage(2,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('selectedsubcategoryname');
                    prefs.remove('selectedbrandname');

                    prefs.setInt('selecteditemnameId', itemName.id);
                    prefs.setString('selecteditemname', itemName.name);
                    prefs.setString('selecteditemnameImg', itemName.imagePath);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => subcategoryPage(
                    //       itemnameId: itemName.id,
                    //     ),
                    //   ),
                    // );
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
                          Text(
                            itemName.name,
                            style: const TextStyle(fontSize: 13),
                          ),
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
