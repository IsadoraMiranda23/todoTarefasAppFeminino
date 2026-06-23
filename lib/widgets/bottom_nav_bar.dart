// widgets/bottom_nav_bar.dart
import 'package:flutter/material.dart';
import '../theme/app_icons.dart';
import '../theme/app_theme.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;      
  final Function(int) onTap;   

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,  
      onTap: onTap,               
      backgroundColor: Colors.white,
      selectedItemColor: AppTheme.lavandaMedio,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(AppIcon.home),
          label: 'Inicio',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcon.sparkles),
          label: 'Jornada',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcon.diary),
          label: 'Diario',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcon.user),
          label: 'Perfil',
        ),
      ],
    );
  }
}