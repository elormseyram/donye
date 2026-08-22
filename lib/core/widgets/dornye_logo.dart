import 'package:flutter/material.dart';

class DornyeLogo extends StatelessWidget {
  const DornyeLogo({
    super.key,
    this.size = 40,
    this.fit = BoxFit.contain,
  });

  static const assetPath = 'lib/assets/images/DornyeEmblemPrimary.png';

  final double size;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: fit,
      semanticLabel: 'Dornye logo',
      filterQuality: FilterQuality.high,
    );
  }
}
