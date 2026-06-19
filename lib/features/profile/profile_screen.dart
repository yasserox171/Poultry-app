import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../data/mock/mock_data.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildHeader(),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                _buildFarmStats(),
                const SizedBox(height: 16),
                _buildBatchSummary(),
                const SizedBox(height: 16),
                _buildSettingsMenu(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return SliverToBoxAdapter(
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.headerGradient,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            child: Column(
              children: [
                // Avatar
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                      ),
                      child: const Center(
                        child: Text('أ', style: TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    Container(
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(Icons.edit_rounded, color: Colors.white, size: 14),
                    ),
                  ],
                ).animate().scale(curve: Curves.elasticOut),
                const SizedBox(height: 12),
                Text('أحمد حسن',
                    style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))
                    .animate().fadeIn(delay: 200.ms),
                Text('مزرعة الأمل • مربي دواجن محترف',
                    style: GoogleFonts.cairo(fontSize: 13, color: Colors.white70))
                    .animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Text('معرف المزرعة: F-2024-001',
                      style: GoogleFonts.cairo(fontSize: 12, color: Colors.white70)),
                ).animate().fadeIn(delay: 400.ms),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _HeaderStat('5', 'سنوات خبرة'),
                    _vDivider(),
                    _HeaderStat('47', 'دفعة منتهية'),
                    _vDivider(),
                    _HeaderStat('4.8', 'تقييم المجتمع'),
                  ],
                ).animate().fadeIn(delay: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _vDivider() => Container(height: 40, width: 1, color: Colors.white24);

  Widget _buildFarmStats() {
    final totalBirds = MockData.batches.fold<int>(0, (s, b) => s + b.currentBirds);
    final totalMortality = (MockData.batches.fold<int>(0, (s, b) => s + b.deadBirds));

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
          Text('إحصائيات المزرعة',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            shrinkWrap: true,
            childAspectRatio: 2.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatItem(Icons.egg_alt_rounded, 'إجمالي الطيور', _fmt(totalBirds), AppColors.primary),
              _StatItem(Icons.folder_rounded, 'الدفعات النشطة', '${MockData.batches.where((b) => b.status == 'active').length}', AppColors.info),
              _StatItem(Icons.trending_up_rounded, 'أفضل معدل تحويل', '1.58', AppColors.success),
              _StatItem(Icons.warning_rounded, 'إجمالي النفوق', '$totalMortality', AppColors.warning),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1);
  }

  Widget _buildBatchSummary() {
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
          Text('ملخص الدفعات',
              style: GoogleFonts.cairo(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 14),
          ...MockData.batches.map((b) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(child: Text('🐓', style: TextStyle(fontSize: 22))),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(b.name,
                          style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold)),
                      Text('${b.breed} • ${b.ageInDays} يوم',
                          style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
                Text(_fmt(b.currentBirds),
                    style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                Text(' طائر',
                    style: GoogleFonts.cairo(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          )),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1);
  }

  Widget _buildSettingsMenu(BuildContext context) {
    final items = [
      {'icon': Icons.notifications_rounded, 'label': 'إعدادات التنبيهات', 'color': AppColors.primary},
      {'icon': Icons.lock_rounded, 'label': 'الأمان وكلمة المرور', 'color': AppColors.info},
      {'icon': Icons.language_rounded, 'label': 'اللغة والمنطقة', 'color': AppColors.warning},
      {'icon': Icons.help_rounded, 'label': 'المساعدة والدعم', 'color': AppColors.success},
      {'icon': Icons.info_rounded, 'label': 'عن التطبيق', 'color': AppColors.textSecondary},
      {'icon': Icons.logout_rounded, 'label': 'تسجيل الخروج', 'color': AppColors.error},
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: items.asMap().entries.map((e) {
          final item = e.value;
          final isLast = e.key == items.length - 1;
          return Column(
            children: [
              ListTile(
                leading: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: (item['color'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(item['icon'] as IconData, color: item['color'] as Color, size: 20),
                ),
                title: Text(item['label'] as String,
                    style: GoogleFonts.cairo(
                        fontSize: 14,
                        color: item['color'] == AppColors.error ? AppColors.error : AppColors.textPrimary)),
                trailing: item['color'] != AppColors.error
                    ? const Icon(Icons.chevron_left_rounded, color: AppColors.textHint)
                    : null,
                onTap: () {},
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              if (!isLast) Divider(height: 1, indent: 66, color: AppColors.divider),
            ],
          );
        }).toList(),
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1);
  }

  String _fmt(int n) {
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}ك';
    return n.toString();
  }
}

class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: GoogleFonts.cairo(fontSize: 12, color: Colors.white70)),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.icon, this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: GoogleFonts.cairo(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
                Text(label, style: GoogleFonts.cairo(fontSize: 10, color: AppColors.textSecondary),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
