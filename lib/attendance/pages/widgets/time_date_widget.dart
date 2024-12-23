import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/text_string.dart';

class TimeDateWidget extends StatelessWidget {
  const TimeDateWidget({
    super.key,
    required this.dateTime,
  });
  final DateTime dateTime;
  @override
  Widget build(BuildContext context) {
    // final now = DateTime.now();
    DateFormat('h:mm a').format(dateTime);
    final formattedDate = DateFormat('E, d MMM ,y').format(dateTime);
    return Padding(
      padding: const EdgeInsets.only(top: 18),
      child: Column(
        children: [
          // Text(
          //   '$formattedTime',
          //   style: TextStyle(fontSize: 34.sp, fontWeight: FontWeight.bold),
          // ),
          // SizedBox(
          //   height: 5.h,
          // ),
          Text(
            '${MTexts.work_day}$formattedDate',
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .apply(color: Color(0xff6E6565)),
            //   style: TextStyle(
            //       fontSize: TSizes.sizeMedium.sp,
            //       fontWeight: FontWeight.w100,
            //       color: const Color(0xff6E6565)),
          ),
        ],
      ),
    );
  }
}
// 1058101633
// A1234567
// فتره 2