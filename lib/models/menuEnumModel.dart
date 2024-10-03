import 'package:flutter/material.dart';

class MenuItems {
  static const String update = 'Update';
  static const String delete = 'Delete';

  static const List<String> choices = <String>[update, delete];

  // for icons
  static const Map<String, IconData> choiceIcons = <String, IconData>{
    update: Icons.update,
    delete: Icons.delete_forever_outlined,
  };
}
