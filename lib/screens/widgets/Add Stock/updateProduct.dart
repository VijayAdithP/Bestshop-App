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
    GlobalKey<FormState> _UpdateKey = GlobalKey<FormState>();
    return Form(
      key: _UpdateKey,
      child: SimpleDialog(
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
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '';
                }
                return null;
              },
              autovalidateMode: AutovalidateMode.onUnfocus,
              controller: widget.controller,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                isDense: true,
                helperText: ' ',
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
                hintText: "category name",
                hintStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 15,
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
                      if (_UpdateKey.currentState!.validate()) {
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
      ),
    );
  }
}
