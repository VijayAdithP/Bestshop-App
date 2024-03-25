import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';

class subcategoryPage extends StatefulWidget {
  final int itemnameId;
  final PageController controller;

  const subcategoryPage({required this.itemnameId, required this.controller});

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
          ? const Center(
              child: CircularProgressIndicator(),
            )
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
                    widget.controller.animateToPage(3,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeIn);
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('selectedbrandname');

                    prefs.setInt('selectedsubcategoryId', subcategory.id);
                    prefs.setString(
                        'selectedsubcategoryname', subcategory.name);
                    prefs.setString(
                        'selectedsubcategoryImg', subcategory.imagePath);

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => brandPage(
                    //       brandId: subcategory.id,
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
                                  '${ApiEndPoints.baseUrl}/${subcategory.imagePath}')),
                          Text(
                            subcategory.name,
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
