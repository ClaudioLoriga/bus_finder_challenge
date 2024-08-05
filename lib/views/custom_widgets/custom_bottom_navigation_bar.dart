// custom_bottom_navigation_bar.dart
import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.directions),
          label: linesLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.directions_bus),
          label: mezziLabel,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pin_drop),
          label: vicinoATeLabel,
        ),
      ],
    );
  }
}