import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class SpecialtyChipList extends StatefulWidget {
  const SpecialtyChipList({super.key});

  @override
  State<SpecialtyChipList> createState() => _SpecialtyChipListState();
}

class _SpecialtyChipListState extends State<SpecialtyChipList> {
  final List<String> _specialties = [
    'All',
    'Cardiology',
    'Neurology',
    'Dermatology',
    'Pediatrics',
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _specialties.length,
        itemBuilder: (context, index) {
          final isSelected = _selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(_specialties[index]),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              backgroundColor: const Color(0xFFF1F5F9),
              selectedColor: AppColors.medConnectPrimary,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF64748B),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
                side: BorderSide.none,
              ),
              showCheckmark: false,
            ),
          );
        },
      ),
    );
  }
}
