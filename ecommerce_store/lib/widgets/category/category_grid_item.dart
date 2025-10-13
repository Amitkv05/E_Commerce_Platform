// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive.dart';

class CategoryGridItem extends StatelessWidget {
  final String name;
  final IconData icon;
  final Color color;
  final int productsCount;
  final VoidCallback onTap;

  const CategoryGridItem({
    super.key,
    required this.name,
    required this.icon,
    required this.color,
    required this.productsCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: Responsive.iconSize(context),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.fontSize(context, mobile: 14, tablet: 16),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              '$productsCount products',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.grey,
                fontSize: Responsive.fontSize(context, mobile: 12, tablet: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
