import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SrDivider extends StatelessWidget {
  const SrDivider({super.key, this.indent = 0});
  final double indent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: AppColors.outline,
      indent: indent,
      endIndent: indent,
    );
  }
}
