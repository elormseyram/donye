import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class SrScaffold extends StatelessWidget {
  const SrScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.backgroundColor = AppColors.background,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.resizeToAvoidBottomInset = true,
    this.padding,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Color backgroundColor;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool resizeToAvoidBottomInset;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: appBar,
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      body: padding != null ? Padding(padding: padding!, child: body) : body,
    );
  }
}
