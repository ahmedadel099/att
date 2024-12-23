import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mashariq_app/utils/constants/image_string.dart';
import 'package:mashariq_app/utils/constants/text_string.dart';

import '../../../../utils/constants/sizes.dart';

class CheckInOutButton extends StatelessWidget {
  const CheckInOutButton({
    super.key,
    required this.isCheckedIn,
    required this.onPressed,
    required this.isCheckedOut,
  });
  final bool isCheckedIn;
  final bool isCheckedOut;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CircularCountDownTimer(
          duration: 10,
          initialDuration: 0,
          // controller: CountDownController(),
          height: 192.h,
          width: 192.w,
          ringColor: Colors.grey[300]!,
          ringGradient: const LinearGradient(
            colors: [
              Color(0xffE4E4E4),
              Color(0xffD0D0D0)
            ], // Use the same color for both
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          fillColor: Colors.transparent,
          fillGradient: const LinearGradient(
            colors: [
              Color(0xff0BA571),
              Color(0xff1AAA13)
            ], // Use the same color for both
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          // backgroundColor: Colors.purple[500],
          backgroundGradient: isCheckedIn && isCheckedOut
              ? const LinearGradient(
                  colors: [
                    Color.fromARGB(255, 70, 64, 66),
                    Color.fromARGB(255, 255, 245, 247)
                  ], // Use the same color for both
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : isCheckedIn
                  ? const LinearGradient(
                      colors: [
                        Color(0xffE9144F),
                        Color(0xffB91230)
                      ], // Use the same color for both
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                  : const LinearGradient(
                      colors: [
                        Color(0xff0BA571),
                        Color(0xff1AAA13)
                      ], // Use the same color for both
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
          // isCheckedIn
          //     ? const LinearGradient(
          //         colors: [
          //           Color(0xffE9144F),
          //           Color(0xffB91230)
          //         ], // Use the same color for both
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //       )
          //     : const LinearGradient(
          //         colors: [
          //           Color(0xff0BA571),
          //           Color(0xff1AAA13)
          //         ], // Use the same color for both
          //         begin: Alignment.topLeft,
          //         end: Alignment.bottomRight,
          //       ),
          strokeWidth: TSizes.sizeExtraMedium,
          strokeCap: StrokeCap.round,
          textStyle: Theme.of(context).textTheme.headlineLarge!.apply(
                color: Colors.white,
              ),
          // const TextStyle(
          //     fontSize: 33.0, color: Colors.white, fontWeight: FontWeight.bold),
          textFormat: CountdownTextFormat.S,
          isReverse: false,
          isReverseAnimation: false,
          isTimerTextShown: false,
          autoStart: false,
          onStart: () {
            debugPrint('Countdown Started');
          },
          onComplete: () {
            debugPrint('Countdown Ended');
          },
          onChange: (String timeStamp) {
            debugPrint('Countdown Changed $timeStamp');
          },
          // timeFormatterFunction: (defaultFormatterFunction, duration) {
          //   if (duration.inSeconds == 0) {
          //     return "Start";
          //   } else {
          //     return Function.apply(defaultFormatterFunction, [duration]);
          //   }
          // },
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: SizedBox(
            height: 192.h,
            width: 192.w,
            child: GestureDetector(
              onTap: onPressed,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center content
                  children: [
                    Image(
                      height: 50.0,
                      width: 50.0,
                      color: Colors.white,
                      image: AssetImage(
                        isCheckedIn
                            ? MImages.icCheckOutIcons
                            : MImages.icCheckINIcons,
                      ),
                    ),
                    SizedBox(height: TSizes.sizeExtraSmall.h),
                    Text(
                      isCheckedIn ? MTexts.time_out : MTexts.time_in,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium!
                          .apply(color: Colors.white),
                      //const TextStyle(color: Colors.white, fontSize: TSizes.sizeMedium.0),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
