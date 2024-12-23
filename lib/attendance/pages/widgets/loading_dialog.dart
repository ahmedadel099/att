import 'package:flutter/material.dart';

import '../../../../common/widgets/loding_indecator/main_indecator.dart';
import '../../../../utils/constants/sizes.dart';
class LoadingOverlay extends StatelessWidget {
  final String message;

  const LoadingOverlay({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SunDoubleBounceIndicator(),
                const SizedBox(height: TSizes.sizeMedium),
                Text(message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium
                    // style: const TextStyle(fontSize: TSizes.sizeMedium),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
