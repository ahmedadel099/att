import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_string.dart';
import '../../../systems/widgets/user_avatar_widget.dart';

class UserAttendanceInfoCard extends StatelessWidget {
  const UserAttendanceInfoCard({
    super.key,
    required this.userImage,
    required this.userName,
    this.groupCode,
    this.missionName,
    this.missionId,
    this.sectorName,
    this.sectorId,
    this.branchName,
    this.branchId,
    this.instanceId,
  });

  final String userImage;
  final String userName;
  final String? groupCode;
  final int? instanceId;
  final String? missionName;
  final int? missionId;
  final String? sectorName;
  final int? sectorId;
  final String? branchName;
  final int? branchId;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 126.58.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xffE4E4E4),
            Color(0xffD0D0D0)
          ], // Use the same color for both
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(TSizes.sizeMedium),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: TSizes.sizeSmall, // Adjust blur radius
            spreadRadius: 4.0, // Adjust spread radius
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            UserAvatarWidget(userImage: userImage),
            SizedBox(width: TSizes.sizeMedium.w),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  MTexts.welcome,
                  style: Theme.of(context).textTheme.bodyMedium!.apply(color: Color(0xff0BA361)),
                  // style: TextStyle(color: Color(0xff0BA361)),
                ),
                Text(
                  userName, // Display user name
                  style: Theme.of(context).textTheme.headlineSmall,
                  // style: TextStyle(
                  //   fontSize: 18,
                  //   fontWeight: FontWeight.bold,
                  // ),
                ),

                //*  Mission Name

                Row(
                  children: [
                    Text(
                      MTexts.job,
                      style: Theme.of(context).textTheme.labelMedium,
                      // style: TextStyle(fontSize: 12.sp),
                    ),
                    SizedBox(
                      width: TSizes.sizeSmall.w,
                    ),
                    Text(
                      missionName ?? '',
                      style: Theme.of(context).textTheme.labelSmall!.apply(color: Color(0xffEC733A)),
                      // style: TextStyle(
                      //     overflow: TextOverflow.fade,
                      //     fontSize: TSizes.sizeSmall.sp,
                      //     fontWeight: FontWeight.bold,
                      //     color: const Color(0xffEC733A)),
                    ),
                  ],
                ),

                //* Group Code
                if (instanceId != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        MTexts.centerumb,
                        style: Theme.of(context).textTheme.labelSmall,
                        // style: TextStyle(fontSize: 12.sp),
                      ),
                      SizedBox(
                        width: TSizes.sizeSmall.w,
                      ),
                      Text(
                        groupCode ?? '',
                        style: Theme.of(context).textTheme.labelSmall!.apply(color: Color(0xffEC733A)),
                        // style: TextStyle(
                        //     fontSize: 12.sp,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xffEC733A)),
                      ),
                    ],
                  ),

                //* Sector Name
                if (sectorId != null)
                  Row(
                    children: [
                       Text(
                        MTexts.sectorA,
                        style: Theme.of(context).textTheme.labelMedium,
                        // style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        width: TSizes.sizeSmall.w,
                      ),
                      Text(
                        sectorName ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(color: Color(0xffEC733A)),
                        // style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xffEC733A)),
                      ),
                    ],
                  ),

                //* Branch Name
                if (branchId != null)
                  Row(
                    children: [
                       Text(
                        MTexts.company1,
                        style: Theme.of(context).textTheme.labelSmall,
                        // style: TextStyle(fontSize: 12),
                      ),
                      SizedBox(
                        width: TSizes.sizeSmall.w,
                      ),
                      Text(
                        branchName ?? '',
                        style: Theme.of(context).textTheme.bodyLarge!.apply(color: Color(0xffEC733A)),
                        // style: TextStyle(
                        //     fontSize: 14,
                        //     fontWeight: FontWeight.bold,
                        //     color: Color(0xffEC733A)),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
