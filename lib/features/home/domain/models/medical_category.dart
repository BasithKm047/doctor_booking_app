import 'package:flutter/material.dart';

class MedicalCategory {
  final String title;
  final String? description;
  final IconData icon;
  final Color color;

  MedicalCategory({
    required this.title,
    this.description,
    required this.icon,
    required this.color,
  });
}
