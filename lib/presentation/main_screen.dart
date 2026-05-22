import 'package:flutter/material.dart';
import 'dart:ui';
import '../features/cars/presentation/pages/home_page.dart';
import '../features/bookings/presentation/pages/bookings_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const BookingsPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      extendBody: true,
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: _pages,
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 24,
            child: _buildEliteNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildEliteNavBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: isDark ? Colors.black.withAlpha(180) : Colors.black.withAlpha(220),
            borderRadius: BorderRadius.circular(35),
            border: Border.all(color: Colors.white.withAlpha(25), width: 0.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(80),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _NavBarItem(
                icon: Icons.explore_rounded,
                label: 'DISCOVER',
                isSelected: _selectedIndex == 0,
                onTap: () => setState(() => _selectedIndex = 0),
              ),
              _NavBarItem(
                icon: Icons.calendar_month_rounded,
                label: 'JOURNEYS',
                isSelected: _selectedIndex == 1,
                onTap: () => setState(() => _selectedIndex = 1),
              ),
              _NavBarItem(
                icon: Icons.person_rounded,
                label: 'PROFILE',
                isSelected: _selectedIndex == 2,
                onTap: () => setState(() => _selectedIndex = 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutQuint,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD4AF37).withAlpha(30) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withAlpha(100),
              size: 26,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFFD4AF37) : Colors.white.withAlpha(100),
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 2,
              width: isSelected ? 12 : 0,
              decoration: BoxDecoration(
                color: const Color(0xFFD4AF37),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
