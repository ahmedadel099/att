import 'package:flutter/material.dart';
import 'package:mashariq_app/utils/constants/text_string.dart';

import '../../../../utils/constants/sizes.dart';

class FaceRegistrationDialog extends StatelessWidget {
  final VoidCallback onRegister;

  const FaceRegistrationDialog({
    super.key,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.sizeMedium)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sizeExtraMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.face,
              size: 48,
              color: Colors.blue,
            ),
            const SizedBox(height: TSizes.sizeMedium),
            Text(MTexts.face_Registration,
                style: Theme.of(context).textTheme.titleLarge
                // style: TextStyle(
                //   fontSize: 18,
                //   fontWeight: FontWeight.bold,
                // ),
                ),
            const SizedBox(height: 12),
            Text(MTexts.use_face,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelLarge
                // style: TextStyle(fontSize: 14),
                ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                onRegister();
              },
              child: const Text(MTexts.register_now),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(MTexts.later),
            ),
          ],
        ),
      ),
    );
  }
}
