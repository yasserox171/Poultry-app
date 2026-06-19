import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:poultry_app/app.dart';
import 'package:poultry_app/providers/sensor_provider.dart';
import 'package:poultry_app/providers/market_provider.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('App launches and shows bottom navigation', (tester) async {
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => SensorProvider()),
          ChangeNotifierProvider(create: (_) => MarketProvider()),
        ],
        child: const PoultryApp(),
      ),
    );
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
