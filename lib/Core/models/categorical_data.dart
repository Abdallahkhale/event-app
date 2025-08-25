import 'package:flutter/material.dart';

class CategoricalData {
  final String id;
  final String name;
  final IconData  icon;
  final String imagePath;

  CategoricalData({
    required this.id ,
    required this.name,
    required this.icon,
    this.imagePath = '',
  });

  
}