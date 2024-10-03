import 'package:flutter/material.dart';

class UpdateproductDialog extends StatefulWidget {
  final TextEditingController controller;
  final Function(String?) function;
  const UpdateproductDialog({
    super.key,
    required this.controller,
    required this.function,
  });

  @override
  State<UpdateproductDialog> createState() => _UpdateproductDialogState();
}

class _UpdateproductDialogState extends State<UpdateproductDialog> {
  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: const Text("Category Name:"),
      titleTextStyle: const TextStyle(fontSize: 17, color: Colors.black),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: TextField(
            controller: widget.controller,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey[400]!,
                ),
              ),
              border: InputBorder.none,
              hintText: "category name",
              hintStyle: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 15,
          ),
          child: IntrinsicHeight(
            child: Row(
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
                      style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                          fontSize: 17),
                    ),
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.withOpacity(0.5),
                  thickness: 1,
                ),
                GestureDetector(
                  onTap: () {
                     widget.function(widget.controller.text);
                  },
                  child: const Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Text(
                      "yes",
                      style: TextStyle(
                          color: Color.fromRGBO(72, 96, 181, 1),
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
