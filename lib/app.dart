import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'shared/widgets/main_scaffold.dart';

class PoultryApp extends StatelessWidget {
  const PoultryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'دواجني',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      locale: const Locale('ar', 'SA'),
      builder: (context, child) => Directionality(
        textDirection: TextDirection.rtl,
        child: child!,
      ),
      home: const MainScaffold(),
    );
  }
}
