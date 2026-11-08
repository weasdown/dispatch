import 'package:gap/gap.dart';
import 'package:material_ui/material_ui.dart';

// TODO test LoadingWidget
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Loading...', style: Theme.of(context).textTheme.headlineMedium),
          const Gap(20),
          SizedBox.square(
            dimension: 20,
            child: const CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}
