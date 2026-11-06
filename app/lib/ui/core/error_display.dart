import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

// TODO test ErrorDisplay
class ErrorDisplay extends StatelessWidget {
  const ErrorDisplay({
    super.key,
    required this.title,
    required this.label,
    required this.onPressed,
  });

  final String title;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Icon(Icons.error, color: Colors.red),
              Gap(8),
              Text('Error!', style: Theme.of(context).textTheme.headlineMedium),
            ],
          ),
          const Gap(12),
          FilledButton(
            onPressed: onPressed,
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.red),
              foregroundColor: WidgetStatePropertyAll(Colors.white),
            ),
            child: Text(label),
          ),
        ],
      ),
    );
  }
}
