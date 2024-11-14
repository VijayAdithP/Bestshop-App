import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class FloatingButton extends StatefulWidget {
  final TextEditingController controller;
  final Function(String?) function;
  final Function(File?) imageFunction;
  final String titleText;
  final String hintText;
  final bool addImage;

  const FloatingButton({
    super.key,
    required this.controller,
    required this.function,
    required this.titleText,
    required this.hintText,
    this.addImage = true,
    required this.imageFunction,
  });

  @override
  State<FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<FloatingButton> {
  File? _selectedImage;

  Future<void> pickCategoryImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
      widget.imageFunction(_selectedImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> _Key = GlobalKey<FormState>();
    return Form(
      key: _Key,
      child: SimpleDialog(
        backgroundColor: const Color.fromRGBO(250, 250, 250, 1),
        title: Text(widget.titleText),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.addImage)
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _selectedImage != null
                              ? ConstrainedBox(
                                  constraints:
                                      const BoxConstraints(maxHeight: 200),
                                  child: Image.file(_selectedImage!,
                                      fit: BoxFit.cover),
                                )
                              : GestureDetector(
                                  onTap: () {
                                    pickCategoryImage();
                                  },
                                  child: DottedBorder(
                                    dashPattern: const [10],
                                    radius: const Radius.circular(10),
                                    borderType: BorderType.RRect,
                                    color: Colors.grey,
                                    strokeWidth: 5,
                                    child: const SizedBox(
                                      height: 50,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20),
                                          child: Text(
                                            "Add Image",
                                            style:
                                                TextStyle(color: Colors.grey),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      if (_selectedImage != null)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            backgroundColor: Colors.redAccent,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedImage =
                                      null; // Remove the image locally
                                });
                                widget.imageFunction(
                                    null); // Update parent callback
                              },
                              child: const Icon(
                                Icons.remove,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: widget.controller,
                    textInputAction: TextInputAction.done,
                    decoration: InputDecoration(
                      filled: true,
                      isDense: true,
                      helperText: ' ',
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          color: Colors.grey[400]!,
                        ),
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      border: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                            widget.controller.clear();
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "No",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey.withOpacity(0.5),
                          thickness: 1,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_Key.currentState!.validate()) {
                              widget.function(widget.controller.text);
                              Navigator.of(context).pop();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  duration: Duration(milliseconds: 500),
                                  content: Text('Please fill in all fields.'),
                                ),
                              );
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              "Yes",
                              style: TextStyle(
                                color: Color.fromRGBO(72, 96, 181, 1),
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
