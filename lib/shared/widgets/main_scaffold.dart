import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../features/home/home_screen.dart';
import '../../features/monitor/monitor_screen.dart';
import '../../features/community/community_screen.dart';
import '../../features/reports/reports_screen.dart';
import '../../features/market/market_screen.dart';
import '../../features/profile/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  void _navigateTo(int index) {
    setState(() => _currentIndex = index);
  }

  List<Widget> get _screens => [
    HomeScreen(onNavigateToMonitor: () => _navigateTo(1)),
    const MonitorScreen(),
    const CommunityScreen(),
    const ReportsScreen(),
    const MarketScreen(),
  ];

  static const List<_NavItem> _navItems = [
    _NavItem(icon: Icons.home_rounded, label: 'الرئيسية'),
    _NavItem(icon: Icons.monitor_heart_rounded, label: 'المراقبة'),
    _NavItem(icon: Icons.people_rounded, label: 'المجتمع'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'التقارير'),
    _NavItem(icon: Icons.storefront_rounded, label: 'السوق'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      extendBody: true,
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: CurvedNavigationBar(
        index: _currentIndex,
        height: 65,
        color: AppColors.primary,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: AppColors.primaryMid,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 350),
        onTap: (index) => setState(() => _currentIndex = index),
        items: _navItems
            .asMap()
            .entries
            .map((e) => _NavWidget(
                  item: e.value,
                  isSelected: e.key == _currentIndex,
                ))
            .toList(),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  const _NavItem({required this.icon, required this.label});
}

class _NavWidget extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  const _NavWidget({required this.item, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(item.icon, color: Colors.white, size: isSelected ? 28 : 24),
        if (!isSelected)
          Text(item.label,
              style: GoogleFonts.cairo(fontSize: 9, color: Colors.white70),
              overflow: TextOverflow.ellipsis),
      ],
    );
  }
}
