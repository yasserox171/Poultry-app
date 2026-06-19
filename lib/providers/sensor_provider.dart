import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../data/models/sensor_data_model.dart';
import '../data/mock/mock_data.dart';

class SensorProvider extends ChangeNotifier {
  double _temperature = 32.4;
  double _humidity = 65.0;
  double _ammonia = 2.3;
  List<SensorReading> _history = [];
  Timer? _timer;
  final _random = Random();

  final List<FanStatus> fans = [
    FanStatus(id: 1, name: 'مروحة 1', isActive: true, speedPercent: 80),
    FanStatus(id: 2, name: 'مروحة 2', isActive: false, speedPercent: 0),
    FanStatus(id: 3, name: 'مروحة 3', isActive: true, speedPercent: 60),
  ];

  double get temperature => _temperature;
  double get humidity => _humidity;
  double get ammonia => _ammonia;
  List<SensorReading> get history => _history;

  String get temperatureStatus {
    if (_temperature >= 38) return 'خطر';
    if (_temperature >= 35) return 'تحذير';
    return 'طبيعي';
  }

  Color get statusColor {
    if (_temperature >= 38) return const Color(0xFFE53935);
    if (_temperature >= 35) return const Color(0xFFFF9800);
    return const Color(0xFF43A047);
  }

  String get humidityStatus {
    if (_humidity > 75 || _humidity < 50) return 'خارج النطاق';
    return 'مثالية';
  }

  SensorProvider() {
    _history = MockData.generateSensorHistory();
    _startSimulation();
  }

  void _startSimulation() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _temperature = 31.0 + _random.nextDouble() * 4;
      _humidity = 60.0 + _random.nextDouble() * 15;
      _ammonia = _random.nextDouble() * 8;

      _temperature = double.parse(_temperature.toStringAsFixed(1));
      _humidity = double.parse(_humidity.toStringAsFixed(1));
      _ammonia = double.parse(_ammonia.toStringAsFixed(1));

      _history.add(SensorReading(
        timestamp: DateTime.now(),
        temperature: _temperature,
        humidity: _humidity,
        ammonia: _ammonia,
      ));
      if (_history.length > 48) _history.removeAt(0);
      notifyListeners();
    });
  }

  void toggleFan(int fanId) {
    final fan = fans.firstWhere((f) => f.id == fanId);
    fan.isActive = !fan.isActive;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
