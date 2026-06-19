class BatchModel {
  final String id;
  final String name;
  final String breed;
  final int totalBirds;
  final int currentBirds;
  final int ageInDays;
  final double mortalityRate;
  final double avgWeightKg;
  final String status;
  final String farmName;
  final DateTime startDate;
  final List<double> weeklyWeights;
  final double feedConversionRatio;

  const BatchModel({
    required this.id,
    required this.name,
    required this.breed,
    required this.totalBirds,
    required this.currentBirds,
    required this.ageInDays,
    required this.mortalityRate,
    required this.avgWeightKg,
    required this.status,
    required this.farmName,
    required this.startDate,
    required this.weeklyWeights,
    required this.feedConversionRatio,
  });

  int get deadBirds => totalBirds - currentBirds;
  String get statusLabel {
    switch (status) {
      case 'active': return 'نشط';
      case 'completed': return 'منتهي';
      case 'new': return 'جديد';
      default: return status;
    }
  }
}
