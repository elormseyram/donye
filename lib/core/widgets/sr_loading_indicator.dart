import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SrLoadingIndicator extends StatelessWidget {
  const SrLoadingIndicator({super.key, this.size = 24, this.color});

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? AppColors.primary,
      ),
    );
  }
}

class SrLoadingOverlay extends StatelessWidget {
  const SrLoadingOverlay({super.key, required this.child, this.isLoading = false});

  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        if (isLoading)
          const ColoredBox(
            color: Color(0x80FFFFFF),
            child: Center(child: SrLoadingIndicator(size: 36)),
          ),
      ],
    );
  }
}
