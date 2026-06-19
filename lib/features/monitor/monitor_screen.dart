import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/sensor_provider.dart';
import 'widgets/temperature_gauge.dart';

class MonitorScreen extends StatelessWidget {
  const MonitorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Consumer<SensorProvider>(
        builder: (context, sensor, _) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              _buildAppBar(sensor),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    const SizedBox(height: 20),
                    _buildGaugeCard(sensor),
                    const SizedBox(height: 16),
                    _buildSensorRow(sensor),
                    const SizedBox(height: 16),
                    _buildFanControls(context, sensor),
                    const SizedBox(height: 16),
                    _buildChartCard(sensor),
                    const SizedBox(height: 16),
                    _buildAlertThresholds(),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAppBar(SensorProvider sensor) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: AppColors.headerGradient,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
        ),
        title: Text('مراقبة الحظيرة',
            style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(left: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: sensor.statusColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: sensor.statusColor),
            ),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(color: sensor.statusColor, shape: BoxShape.circle),
                ),
                const SizedBox(width: 5),
                Text('مباشر', style: GoogleFonts.cairo(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGaugeCard(SensorProvider sensor) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.07), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        children: [
          Text('درجة الحرارة الحالية',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          Center(
            child: TemperatureGauge(
              temperature: sensor.temperature,
              statusColor: sensor.statusColor,
              status: sensor.temperatureStatus,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _GaugeLabel(color: const Color(0xFF43A047), label: 'مثالي (25-34°)'),
              const SizedBox(width: 16),
              _GaugeLabel(color: const Color(0xFFFF9800), label: 'تحذير (34-38°)'),
              const SizedBox(width: 16),
              _GaugeLabel(color: const Color(0xFFE53935), label: 'خطر (38+°)'),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.1);
  }

  Widget _buildSensorRow(SensorProvider sensor) {
    return Row(
      children: [
        Expanded(
          child: _SensorTile(
            icon: Icons.water_drop_rounded,
            label: 'الرطوبة',
            value: '${sensor.humidity}٪',
            unit: sensor.humidityStatus,
            color: AppColors.info,
            isGood: sensor.humidity >= 50 && sensor.humidity <= 75,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SensorTile(
            icon: Icons.air_rounded,
            label: 'الأمونيا',
            value: '${sensor.ammonia}',
            unit: 'ppm',
            color: sensor.ammonia > 5 ? AppColors.warning : AppColors.success,
            isGood: sensor.ammonia <= 5,
          ),
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildFanControls(BuildContext context, SensorProvider sensor) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('التحكم في المراوح',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: sensor.fans
                .map((fan) => _FanControl(
                      fan: fan,
                      onToggle: () => context.read<SensorProvider>().toggleFan(fan.id),
                    ))
                .toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildChartCard(SensorProvider sensor) {
    final spots = sensor.history.asMap().entries.map((e) {
      return FlSpot(e.key.toDouble(), e.value.temperature);
    }).toList();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('سجل الحرارة (24 ساعة)',
                  style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('آخر قراءة: ${sensor.temperature}°C',
                  style: GoogleFonts.cairo(fontSize: 12, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 2,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.divider,
                    strokeWidth: 1,
                  ),
                ),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 4,
                      reservedSize: 36,
                      getTitlesWidget: (v, _) => Text(
                        '${v.toInt()}°',
                        style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 8,
                      getTitlesWidget: (v, _) {
                        final idx = v.toInt();
                        if (idx >= 0 && idx < sensor.history.length) {
                          final h = sensor.history[idx].timestamp.hour;
                          return Text('${h}س',
                              style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary));
                        }
                        return const SizedBox();
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minY: 26,
                maxY: 40,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 2.5,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.3),
                          AppColors.primary.withOpacity(0.0),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Warning line at 35°
                  LineChartBarData(
                    spots: [FlSpot(0, 35), FlSpot(spots.length.toDouble() - 1, 35)],
                    color: AppColors.warning.withOpacity(0.6),
                    barWidth: 1.5,
                    dashArray: [6, 4],
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
              ),
              duration: const Duration(milliseconds: 400),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildAlertThresholds() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('حدود التنبيه', style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          _ThresholdRow(label: 'درجة الحرارة المثالية', range: '28 - 34°C', color: AppColors.success),
          _ThresholdRow(label: 'تحذير', range: '34 - 38°C', color: AppColors.warning),
          _ThresholdRow(label: 'خطر - تدخل فوري', range: 'أكثر من 38°C', color: AppColors.error),
          _ThresholdRow(label: 'الرطوبة المثالية', range: '50 - 75٪', color: AppColors.info),
          _ThresholdRow(label: 'حد الأمونيا', range: 'أقل من 10 ppm', color: AppColors.warning),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }
}

class _GaugeLabel extends StatelessWidget {
  final Color color;
  final String label;
  const _GaugeLabel({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _SensorTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool isGood;

  const _SensorTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.isGood,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 10),
          Text(value,
              style: GoogleFonts.cairo(fontSize: 28, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(isGood ? Icons.check_circle : Icons.warning_rounded,
                  size: 14, color: isGood ? AppColors.success : AppColors.warning),
              const SizedBox(width: 4),
              Text(unit, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FanControl extends StatelessWidget {
  final dynamic fan;
  final VoidCallback onToggle;
  const _FanControl({required this.fan, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 90,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: fan.isActive ? AppColors.primary : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(16),
          boxShadow: fan.isActive
              ? [BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4))]
              : [],
        ),
        child: Column(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fan.isActive ? 1 : 0),
              duration: const Duration(milliseconds: 600),
              builder: (_, v, child) => Transform.rotate(
                angle: v * 2 * 3.14159,
                child: child,
              ),
              child: Icon(Icons.mode_fan_off_rounded,
                  color: fan.isActive ? Colors.white : Colors.grey.shade400,
                  size: 30),
            ),
            const SizedBox(height: 8),
            Text(fan.name,
                style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: fan.isActive ? Colors.white : AppColors.textSecondary,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(fan.isActive ? 'تشغيل' : 'إيقاف',
                style: GoogleFonts.cairo(
                    fontSize: 11,
                    color: fan.isActive ? Colors.white70 : AppColors.textHint)),
          ],
        ),
      ),
    );
  }
}

class _ThresholdRow extends StatelessWidget {
  final String label;
  final String range;
  final Color color;
  const _ThresholdRow({required this.label, required this.range, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 10),
          Expanded(child: Text(label, style: GoogleFonts.cairo(fontSize: 13, color: AppColors.textPrimary))),
          Text(range, style: GoogleFonts.cairo(fontSize: 13, color: color, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
