import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Shop', style: AppTextStyles.headlineLarge).animate().fadeIn(),
                  Row(
                    children: [
                      _currencyChip(Icons.monetization_on, '12,540', AppColors.gold),
                      const SizedBox(width: 8),
                      _currencyChip(Icons.diamond, '350', AppColors.cyan),
                    ],
                  ).animate().fadeIn(delay: 100.ms),
                ],
              ),
              const SizedBox(height: 20),
              // Featured offer
              _buildFeaturedOffer().animate().fadeIn(delay: 200.ms),
              const SizedBox(height: 24),
              Text('COIN PACKS', style: AppTextStyles.labelLarge.copyWith(letterSpacing: 1)).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 12),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildCoinPack('Starter', 1000, 0.99, AppColors.gradientBattle, false),
                  _buildCoinPack('Popular', 5000, 3.99, AppColors.gradientPrimary, true),
                  _buildCoinPack('Pro', 12000, 7.99, AppColors.gradientTournament, false),
                  _buildCoinPack('Elite', 30000, 14.99, AppColors.gradientGold, false),
                ],
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 24),
              Text('POWER-UPS', style: AppTextStyles.labelLarge.copyWith(letterSpacing: 1)).animate().fadeIn(delay: 400.ms),
              const SizedBox(height: 12),
              ...['50/50 Lifeline', 'Extra Time +10s', 'Skip Question'].asMap().entries.map((e) {
                final icons = [Icons.filter_2, Icons.timer, Icons.skip_next];
                final prices = [200, 150, 100];
                final colors = [AppColors.pink, AppColors.cyan, AppColors.gold];
                return _buildPowerupRow(e.value, icons[e.key], prices[e.key], colors[e.key], e.key)
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: 450 + e.key * 80))
                    .slideX(begin: 0.1);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _currencyChip(IconData icon, String amount, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Text(amount, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildFeaturedOffer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.gradientGold,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Text('🎁', style: TextStyle(fontSize: 48)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SPECIAL OFFER', style: TextStyle(color: Colors.black54, fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 1)),
                const Text('Starter Bundle', style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w800)),
                const Text('5000 coins + 50 gems + 3 lifelines', style: TextStyle(color: Colors.black87, fontSize: 12)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(10)),
                  child: const Text('\$1.99', style: TextStyle(color: Color(0xFFFFD400), fontSize: 14, fontWeight: FontWeight.w800)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPack(String name, int coins, double price, LinearGradient gradient, bool popular) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: popular ? AppColors.primary : const Color(0xFF2A2A50)),
      ),
      child: Stack(
        children: [
          if (popular)
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16), bottomLeft: Radius.circular(10)),
                ),
                child: const Text('POPULAR', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ShaderMask(
                  shaderCallback: (b) => gradient.createShader(b),
                  child: const Icon(Icons.monetization_on, color: Colors.white, size: 36),
                ),
                const SizedBox(height: 8),
                Text(name, style: AppTextStyles.labelLarge),
                Text('${coins >= 1000 ? '${coins ~/ 1000}k' : '$coins'} coins', style: AppTextStyles.bodySmall.copyWith(color: AppColors.gold)),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(8)),
                  child: Text('\$$price', textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerupRow(String name, IconData icon, int price, Color color, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A50)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(name, style: AppTextStyles.titleMedium)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceLight,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on, color: AppColors.gold, size: 14),
                const SizedBox(width: 4),
                Text('$price', style: AppTextStyles.labelLarge.copyWith(color: AppColors.gold, fontSize: 13)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

