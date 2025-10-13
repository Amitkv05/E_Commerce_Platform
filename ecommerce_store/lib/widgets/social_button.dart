import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/responsive.dart';

class SocialButton extends StatelessWidget {
  // final Widget icon;
  final String label;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    // required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        // icon: SizedBox(
        //   width: 20,
        //   height: 20,
        //   child: icon,
        // ),
        label: Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
        ),
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.greyLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: EdgeInsets.symmetric(
            vertical: 16,
            horizontal: Responsive.horizontalPadding(context),
          ),
        ),
      ),
    );
  }
}
