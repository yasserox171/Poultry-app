import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TemperatureGauge extends StatefulWidget {
  final double temperature;
  final double minTemp;
  final double maxTemp;
  final Color statusColor;
  final String status;

  const TemperatureGauge({
    super.key,
    required this.temperature,
    this.minTemp = 25.0,
    this.maxTemp = 45.0,
    required this.statusColor,
    required this.status,
  });

  @override
  State<TemperatureGauge> createState() => _TemperatureGaugeState();
}

class _TemperatureGaugeState extends State<TemperatureGauge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _sweepAnimation;
  double _prevTemp = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _buildAnimation(widget.temperature);
    _controller.forward();
    _prevTemp = widget.temperature;
  }

  @override
  void didUpdateWidget(TemperatureGauge old) {
    super.didUpdateWidget(old);
    if (old.temperature != widget.temperature) {
      _buildAnimation(widget.temperature);
      _controller.forward(from: 0);
      _prevTemp = old.temperature;
    }
  }

  void _buildAnimation(double target) {
    final startFraction = (_prevTemp - widget.minTemp) / (widget.maxTemp - widget.minTemp);
    final endFraction = (target - widget.minTemp) / (widget.maxTemp - widget.minTemp);
    _sweepAnimation = Tween<double>(
      begin: startFraction.clamp(0.0, 1.0),
      end: endFraction.clamp(0.0, 1.0),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _sweepAnimation,
      builder: (_, __) => CustomPaint(
        size: const Size(220, 220),
        painter: _GaugePainter(
          fraction: _sweepAnimation.value,
          temperature: widget.temperature,
          statusColor: widget.statusColor,
          status: widget.status,
          minTemp: widget.minTemp,
          maxTemp: widget.maxTemp,
        ),
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  final double fraction;
  final double temperature;
  final Color statusColor;
  final String status;
  final double minTemp;
  final double maxTemp;

  _GaugePainter({
    required this.fraction,
    required this.temperature,
    required this.statusColor,
    required this.status,
    required this.minTemp,
    required this.maxTemp,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.42;
    const startAngle = pi * 0.75;
    const sweepTotal = pi * 1.5;

    // Background arc
    final bgPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepTotal, false, bgPaint,
    );

    // Color zones
    _drawZone(canvas, center, radius, startAngle, sweepTotal * 0.6, const Color(0xFF43A047));
    _drawZone(canvas, center, radius, startAngle + sweepTotal * 0.6, sweepTotal * 0.25, const Color(0xFFFF9800));
    _drawZone(canvas, center, radius, startAngle + sweepTotal * 0.85, sweepTotal * 0.15, const Color(0xFFE53935));

    // Active arc
    final activePaint = Paint()
      ..color = statusColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 18
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle, sweepTotal * fraction, false, activePaint,
    );

    // Needle
    final needleAngle = startAngle + sweepTotal * fraction;
    final needleTip = Offset(
      center.dx + (radius) * cos(needleAngle),
      center.dy + (radius) * sin(needleAngle),
    );
    final needleBase = Offset(
      center.dx + (radius - 30) * cos(needleAngle),
      center.dy + (radius - 30) * sin(needleAngle),
    );
    canvas.drawLine(
      needleBase, needleTip,
      Paint()..color = statusColor..strokeWidth = 4..strokeCap = StrokeCap.round,
    );

    // Center circle
    canvas.drawCircle(center, 12, Paint()..color = statusColor);
    canvas.drawCircle(center, 8, Paint()..color = Colors.white);

    // Temperature text
    final tempStyle = GoogleFonts.cairo(
      fontSize: 40,
      fontWeight: FontWeight.bold,
      color: statusColor,
    );
    final tempSpan = TextSpan(text: '${temperature.toStringAsFixed(1)}°', style: tempStyle);
    final tempPainter = TextPainter(text: tempSpan, textDirection: TextDirection.ltr);
    tempPainter.layout();
    tempPainter.paint(canvas, Offset(center.dx - tempPainter.width / 2, center.dy + 20));

    // Unit text
    final unitStyle = GoogleFonts.cairo(fontSize: 16, color: Colors.grey.shade600);
    final unitSpan = TextSpan(text: 'درجة مئوية', style: unitStyle);
    final unitPainter = TextPainter(text: unitSpan, textDirection: TextDirection.rtl);
    unitPainter.layout();
    unitPainter.paint(canvas, Offset(center.dx - unitPainter.width / 2, center.dy + 64));

    // Min/Max labels
    _drawLabel(canvas, '${minTemp.toInt()}°', Offset(center.dx - radius * 0.85, center.dy + radius * 0.55));
    _drawLabel(canvas, '${maxTemp.toInt()}°', Offset(center.dx + radius * 0.6, center.dy + radius * 0.55));
  }

  void _drawZone(Canvas canvas, Offset center, double radius, double start, double sweep, Color color) {
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      start, sweep, false,
      Paint()..color = color.withOpacity(0.3)..style = PaintingStyle.stroke..strokeWidth = 18,
    );
  }

  void _drawLabel(Canvas canvas, String text, Offset pos) {
    final span = TextSpan(
      text: text,
      style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.w600),
    );
    final painter = TextPainter(text: span, textDirection: TextDirection.ltr);
    painter.layout();
    painter.paint(canvas, pos);
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.fraction != fraction || old.statusColor != statusColor;
}
