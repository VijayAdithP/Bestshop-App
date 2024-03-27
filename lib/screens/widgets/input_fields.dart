import 'package:flutter/material.dart';

class InputTextFieldWidget extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  const InputTextFieldWidget(this.textEditingController, this.hintText,{super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        height: 60,
        child: Material(
          borderRadius: BorderRadius.circular(10),
          elevation: 3,
          shadowColor: const Color.fromARGB(141, 33, 149, 243),
          child: TextFormField(
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.justify,
            controller: textEditingController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.only(
                left: 15,
                bottom: 39,
              ),
              alignLabelWithHint: true,
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(143, 0, 140, 255),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(143, 0, 140, 255),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              errorBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(143, 0, 140, 255),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              filled: true,
              fillColor: Colors.transparent,
              hintStyle: const TextStyle(
                color: Color.fromARGB(146, 87, 111, 168),
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              hintText: hintText,
            ),
          ),
        ),
      ),
    );
  }
}
