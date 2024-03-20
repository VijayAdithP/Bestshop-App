import 'package:newbestshop/utils/color.dart';
import 'package:flutter/material.dart';

Widget customButton(label) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: primaryColor, borderRadius: BorderRadius.circular(8)),
    child: Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 17, color: Colors.white),
      ),
    ),
  );
}