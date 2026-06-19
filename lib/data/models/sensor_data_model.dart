class SensorReading {
  final DateTime timestamp;
  final double temperature;
  final double humidity;
  final double ammonia;

  const SensorReading({
    required this.timestamp,
    required this.temperature,
    required this.humidity,
    this.ammonia = 0.0,
  });
}

class FanStatus {
  final int id;
  final String name;
  bool isActive;
  final int speedPercent;

  FanStatus({
    required this.id,
    required this.name,
    required this.isActive,
    required this.speedPercent,
  });
}
