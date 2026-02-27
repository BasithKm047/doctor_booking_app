import 'package:flutter/material.dart';

class OnboardingItem {
  final String image;
  final String title;
  final String subtitle;
  final BoxFit imageFit;

  OnboardingItem({
    required this.image,
    required this.title,
    required this.subtitle,
    this.imageFit = BoxFit.cover,
  });
}
