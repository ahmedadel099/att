import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../utils/constants/sizes.dart';

// ignore: must_be_immutable
class TimesBoxes extends StatelessWidget {
  TimesBoxes({
    super.key,
    this.time,
    required this.iconPath,
    required this.labelText,
  });

  final String iconPath;
  String? time;
  final String labelText;
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    DateFormat('h:mm a').format(now);

    return Container(
      width: 111.w,
      height: 97.3.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(TSizes.sizeMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: TSizes.sizeSmall,
            spreadRadius: 4.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: 33.56.w,
            height: 33.56.h,
            color: const Color(0xffEC733A),
            image: AssetImage(iconPath),
          ),
          Text(
            time ?? ':',
            style: Theme.of(context).textTheme.titleLarge,
            // style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
          Text(
            labelText,
            style: Theme.of(context).textTheme.labelLarge!.apply(color: Color(0xffACA3A3)),
            // style: TextStyle(fontSize: 12.sp, color: Color(0xffACA3A3)),
          ),
        ],
      ),
    );
  }
}
