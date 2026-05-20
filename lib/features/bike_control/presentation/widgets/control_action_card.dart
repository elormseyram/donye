import 'package:flutter/material.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/widgets/sr_card.dart';
import '../../../../../shared/components/command_button.dart';

class ControlActionCard extends StatelessWidget {
  const ControlActionCard({
    super.key,
    required this.title,
    required this.actions,
  });

  final String title;
  final List<CommandAction> actions;

  @override
  Widget build(BuildContext context) {
    return SrCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
          GridView.count(
            crossAxisCount: actions.length > 3 ? 4 : actions.length,
            crossAxisSpacing: AppSpacing.sm,
            mainAxisSpacing: AppSpacing.sm,
            childAspectRatio: 0.85,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: actions
                .map(
                  (a) => CommandButton(
                    label: a.label,
                    icon: a.icon,
                    onPressed: a.onPressed,
                    isDestructive: a.isDestructive,
                    requireConfirm: a.requireConfirm,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class CommandAction {
  const CommandAction({
    required this.label,
    required this.icon,
    required this.onPressed,
    this.isDestructive = false,
    this.requireConfirm = true,
  });

  final String label;
  final IconData icon;
  final Future<void> Function() onPressed;
  final bool isDestructive;
  final bool requireConfirm;
}
