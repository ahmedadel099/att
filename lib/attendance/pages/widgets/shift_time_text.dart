import 'package:flutter/material.dart';
import 'package:mashariq_app/utils/constants/text_string.dart';

// ignore: must_be_immutable
class ShiftTimeText extends StatelessWidget {
  ShiftTimeText({
    super.key,
    this.shiftStart,
    this.shiftEnd,
  });

  String? shiftStart = '00:00';
  String? shiftEnd = '00:00';

  @override
  Widget build(BuildContext context) {
    return Text(
      '${MTexts.work_time}$shiftStart${MTexts.fromTo} $shiftEnd',
      style: Theme.of(context)
          .textTheme
          .titleMedium!
          .apply(color: Color(0xff6E6565)),
      // style: const TextStyle(color: Color(0xff6E6565)),
    );
  }
}
