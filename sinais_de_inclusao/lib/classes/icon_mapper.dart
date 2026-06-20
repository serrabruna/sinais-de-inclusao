import 'package:flutter/material.dart';

class IconMapper {
  static IconData getIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'animais': return Icons.pets;
      case 'objetos': return Icons.menu_book;
      case 'saudações': return Icons.chat;
      case 'alimentos': return Icons.fastfood;
      case 'cores': return Icons.palette;
      case 'verbos': return Icons.directions_run;
      default: return Icons.category;
    }
  }
}