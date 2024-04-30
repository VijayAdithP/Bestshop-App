import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newbestshop/utils/api_endpoints.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:newbestshop/models/api_data.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryPage extends StatefulWidget {
  final PageController controller;
  const CategoryPage({super.key, required this.controller});
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
      backgroundColor: Colors.grey.shade300,

      // appBar: AppBar(
      //   title: const Text(''),
      //         actions: <Widget>[
      //   IconButton(
      //     icon: Icon(Icons.search),
      //     onPressed: () {
      //       // Implement search functionality here
      //     },
      //   ),
      // ],
      // ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 188,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                final category = _categories[index];
                return GestureDetector(
                  child: Card(
                    surfaceTintColor: Colors.white,
                    // child: ListTile(
                    //   title: Text(category.name),
                    //   leading: Image.network(
                    //       ApiEndPoints.baseUrl + '/' + category.imagePath),
                    // ),
                    elevation: 2,
                    shadowColor: Colors.black,
                    // color: Colors.white,
                    margin: const EdgeInsets.all(10),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              category.imagePath.isEmpty
                                  ? "https://media.istockphoto.com/id/1226328537/vector/image-place-holder-with-a-gray-camera-icon.jpg?s=612x612&w=0&k=20&c=qRydgCNlE44OUSSoz5XadsH7WCkU59-l-dwrvZzhXsI="
                                  : '${ApiEndPoints.baseUrl}/${category.imagePath}',
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            category.name,
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () async {
                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.remove('selecteditemname');
                    prefs.remove('selectedsubcategoryname');
                    prefs.remove('selectedbrandname');

                    prefs.setInt('selectedCategoryId', category.id);
                    prefs.setString('selectedCategoryname', category.name);
                    prefs.setString('selectedCategoryImg', category.imagePath);
                    widget.controller.animateToPage(1,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ItemNamePage(
                    //       category_Id: category.id,
                    //     ),
                    //   ),
                    // );
                  },
                );
              },
            ),
    );
  }
}
