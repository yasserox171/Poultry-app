import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/mock/mock_data.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _touchedPieIndex = -1;
  String _range = '4 أسابيع';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildRangeSelector(),
                const SizedBox(height: 16),
                _buildSummaryCards(),
                const SizedBox(height: 16),
                _buildFeedChart(),
                const SizedBox(height: 16),
                _buildGrowthChart(),
                const SizedBox(height: 16),
                _buildBatchPieChart(),
                const SizedBox(height: 16),
                _buildMortalityChart(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 80,
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
        title: Text('التقارير والإحصائيات',
            style: GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.download_rounded, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildRangeSelector() {
    final options = ['أسبوع', '4 أسابيع', '3 أشهر', 'سنة'];
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: options.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final opt = options[i];
          final selected = _range == opt;
          return GestureDetector(
            onTap: () => setState(() => _range = opt),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
              ),
              child: Text(opt,
                  style: GoogleFonts.cairo(
                      color: selected ? Colors.white : AppColors.textSecondary,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                      fontSize: 13)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCards() {
    final cards = [
      {'label': 'إجمالي الأعلاف', 'value': '12.9 طن', 'icon': Icons.grass_rounded, 'color': AppColors.success, 'delta': '+3٪'},
      {'label': 'إجمالي الطيور', 'value': '23,546', 'icon': Icons.egg_alt_rounded, 'color': AppColors.info, 'delta': '+8٪'},
      {'label': 'معدل النفوق', 'value': '0.85٪', 'icon': Icons.trending_down_rounded, 'color': AppColors.error, 'delta': '-12٪'},
      {'label': 'معدل التحويل', 'value': '1.65', 'icon': Icons.swap_vert_rounded, 'color': AppColors.warning, 'delta': '-0.07'},
    ];

    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      childAspectRatio: 1.6,
      physics: const NeverScrollableScrollPhysics(),
      children: cards.asMap().entries.map((e) {
        final c = e.value;
        return Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.cardBg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(c['icon'] as IconData, color: c['color'] as Color, size: 22),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: (c['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(c['delta'] as String,
                        style: GoogleFonts.cairo(fontSize: 10, color: c['color'] as Color, fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(c['value'] as String,
                      style: GoogleFonts.cairo(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text(c['label'] as String,
                      style: GoogleFonts.cairo(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: 100 + e.key * 80)).scale(begin: const Offset(0.95, 0.95));
      }).toList(),
    );
  }

  Widget _buildFeedChart() {
    final weeks = ['أسبوع 1', 'أسبوع 2', 'أسبوع 3', 'أسبوع 4'];
    return _ChartCard(
      title: 'استهلاك الأعلاف (طن)',
      subtitle: 'آخر 4 أسابيع',
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: 5,
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
              getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                '${rod.toY.toStringAsFixed(1)} طن',
                GoogleFonts.cairo(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 32,
                interval: 1,
                getTitlesWidget: (v, _) => Text('${v.toInt()}',
                    style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) {
                  final idx = v.toInt();
                  if (idx < 0 || idx >= weeks.length) return const SizedBox();
                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(weeks[idx],
                        style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
                  );
                },
              ),
            ),
          ),
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
          barGroups: MockData.weeklyFeedTons.asMap().entries.map((e) {
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4CAF50), Color(0xFF1B5E20)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  width: 28,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                ),
              ],
            );
          }).toList(),
        ),
        duration: const Duration(milliseconds: 600),
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  Widget _buildGrowthChart() {
    final spots = MockData.weeklyAvgWeightKg.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return _ChartCard(
      title: 'منحنى النمو (كجم)',
      subtitle: 'متوسط وزن الطائر أسبوعياً',
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (v, _) => Text('${v.toStringAsFixed(1)}',
                    style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text('أسبوع ${v.toInt() + 1}',
                    style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 2.5,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.35,
              color: AppColors.info,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 5,
                  color: AppColors.info,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [AppColors.info.withOpacity(0.3), AppColors.info.withOpacity(0.0)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 600),
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildBatchPieChart() {
    final entries = MockData.batchDistribution.entries.toList();
    final colors = [
      AppColors.primary,
      AppColors.info,
      AppColors.warning,
      AppColors.error,
    ];

    return _ChartCard(
      title: 'توزيع الدفعات',
      subtitle: 'حسب السلالة',
      child: Row(
        children: [
          Expanded(
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (e, r) {
                    setState(() {
                      _touchedPieIndex = r?.touchedSection?.touchedSectionIndex ?? -1;
                    });
                  },
                ),
                sections: entries.asMap().entries.map((e) {
                  final isTouched = e.key == _touchedPieIndex;
                  return PieChartSectionData(
                    value: e.value.value,
                    color: colors[e.key % colors.length],
                    radius: isTouched ? 70 : 60,
                    title: '${e.value.value.toInt()}٪',
                    titleStyle: GoogleFonts.cairo(
                        fontSize: isTouched ? 14 : 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  );
                }).toList(),
                centerSpaceRadius: 36,
                sectionsSpace: 3,
              ),
              duration: const Duration(milliseconds: 600),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: entries.asMap().entries.map((e) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                          color: colors[e.key % colors.length],
                          borderRadius: BorderRadius.circular(4)),
                    ),
                    const SizedBox(width: 8),
                    Text('${e.value.key}\n${e.value.value.toStringAsFixed(1)}٪',
                        style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textPrimary)),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  Widget _buildMortalityChart() {
    final spots = MockData.weeklyMortalityPct.asMap().entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();

    return _ChartCard(
      title: 'معدل النفوق الأسبوعي (٪)',
      subtitle: 'الهدف: أقل من 0.5٪',
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            drawVerticalLine: false,
            getDrawingHorizontalLine: (_) => FlLine(color: AppColors.divider, strokeWidth: 1),
          ),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                interval: 0.2,
                getTitlesWidget: (v, _) => Text('${v.toStringAsFixed(1)}٪',
                    style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (v, _) => Text('أسبوع ${v.toInt() + 1}',
                    style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary)),
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minY: 0,
          maxY: 0.8,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.error,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(
                getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(
                  radius: 5,
                  color: AppColors.error,
                  strokeColor: Colors.white,
                  strokeWidth: 2,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [AppColors.error.withOpacity(0.2), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            LineChartBarData(
              spots: [FlSpot(0, 0.5), FlSpot(3, 0.5)],
              color: AppColors.warning.withOpacity(0.7),
              barWidth: 1.5,
              dashArray: [6, 4],
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
            ),
          ],
        ),
        duration: const Duration(milliseconds: 600),
      ),
    ).animate().fadeIn(delay: 700.ms);
  }
}

class _ChartCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget child;

  const _ChartCard({required this.title, required this.subtitle, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 12)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          Text(subtitle, style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(height: 180, child: child),
        ],
      ),
    );
  }
}
