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
          LayoutBuilder(
            builder: (context, constraints) {
              const minimumButtonWidth = 120.0;
              final possibleColumns =
                  ((constraints.maxWidth + AppSpacing.sm) /
                          (minimumButtonWidth + AppSpacing.sm))
                      .floor();
              final columns = possibleColumns.clamp(1, actions.length);
              final buttonWidth =
                  (constraints.maxWidth - AppSpacing.sm * (columns - 1)) /
                  columns;

              return Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.sm,
                children: actions
                    .map(
                      (action) => SizedBox(
                        width: buttonWidth,
                        child: CommandButton(
                          label: action.label,
                          icon: action.icon,
                          onPressed: action.onPressed,
                          isDestructive: action.isDestructive,
                          requireConfirm: action.requireConfirm,
                        ),
                      ),
                    )
                    .toList(),
              );
            },
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
