import 'package:flutter/material.dart';
import 'package:genz_app/features/Tournament/screen/tournament_screen.dart';

import '../../profile/screen/profile_screen.dart';
import '../../shop/screen/shop_screen.dart';
import 'home_screen.dart';
import 'live_screen.dart';
import '../../../utiles/widgets/neumorphic/neumorphic_bottom_nav.dart';

class HomeShellScreen extends StatefulWidget {
  const HomeShellScreen({super.key});

  @override
  State<HomeShellScreen> createState() => _HomeShellScreenState();
}

class _HomeShellScreenState extends State<HomeShellScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    debugPrint('HomeShellScreen build currentIndex=$_currentIndex');
    return Scaffold(
      extendBody: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
     body: IndexedStack(
  index: _currentIndex,
  children: const [
    HomeScreen(),
    TournamentScreen(), // 👈 NEW
    LiveScreen(),
    ShopScreen(),
    ProfileScreen(),
  ],
),
      bottomNavigationBar: NeumorphicBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
