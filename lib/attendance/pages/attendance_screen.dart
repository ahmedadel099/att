import 'dart:math';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../common/widgets/loding_indecator/main_indecator.dart';
import '../../../core/services/location_service.dart';
import '../../../service_locator.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/constants/text_string.dart';
import '../../notifications_reports/hajj_guidance/models/status_response_model.dart';
import '../../notifications_reports/hajj_guidance/widgets/ask_confirmation_dialog.dart';
import '../../notifications_reports/hajj_guidance/widgets/confirmation_dialog.dart';
import '../../notifications_reports/hajj_guidance/widgets/error_dialog.dart';
import '../bloc/attendance_bloc.dart';
import '../bloc/attendance_event.dart';
import '../bloc/attendance_state.dart';
import '../models/places_model.dart';
import 'widgets/attendance_map.dart';
import 'widgets/checkin_out_button.dart';

import 'widgets/shift_time_text.dart';
import 'widgets/time_date_widget.dart';
import 'widgets/times_boxes.dart';
import 'widgets/user_attendance_info_card_widget.dart';

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  final distanceLatitude = (lat2 - lat1) * (pi / 180) * 6371000; // Meters
  final distanceLongitude =
      (lon2 - lon1) * (pi / 180) * 6371000 * cos(lat1 * (pi / 180)); // Meters
  return sqrt(distanceLatitude * distanceLatitude +
      distanceLongitude * distanceLongitude);
}

class AttendanceScreen extends StatefulWidget {
  final String userToken;

  const AttendanceScreen({super.key, required this.userToken});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late CountDownController _countDownController;
  LatLng userLocation = LatLng(21.422922, 39.827812); // Initial marker position

  @override
  void initState() {
    super.initState();
    final attendanceBloc = locator<AttendanceBloc>();
    attendanceBloc.add(FetchLocation(userToken: widget.userToken));
    _countDownController = CountDownController();
  }

  @override
  Widget build(BuildContext context) {
    final attendanceBloc = locator<AttendanceBloc>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(MTexts.comeandgo,
            style: Theme.of(context).textTheme.titleMedium
            //TextStyle(color: Colors.black),
            ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(TSizes.sizeExtraMedium),
        child: BlocConsumer<AttendanceBloc, AttendanceState>(
          listener: (context, state) {
            // if (state is LocationLoaded) {
            //   final position = state.markerPosition;
            //   userLocation = LatLng(position.latitude, position.longitude);
            //   attendanceBloc
            //       .add(LoadAttendanceData(userToken: widget.userToken));
            // }
            if (state is LocationServiceState) {
              _showLocationServiceDialog(
                context: context,
                message: state.message,
                canOpenSettings: state.canOpenSettings,
                status: state.status,
              );
            } else if (state is AttendanceCheckedInOutSuccess) {
              _showSuccessDialog(state.statusResponseModel);
            } else if (state is FaceRegistrationSuccess) {
              _showFaceRegistrationDialog(state.message);
            } else if (state is FaceRegistrationFailure ||
                state is AttendanceCheckedInOutFailure) {
              _showErrorDialog(state is FaceRegistrationFailure
                  ? state.error
                  : MTexts.erroroccur);
            }
          },
          builder: (context, state) {
            if (state is LocationServiceState) {
              return _buildLocationErrorView(state);
            }

            if (state is AttendanceLoading ||
                state is LocationLoading ||
                state is FaceRegistrationLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SunDoubleBounceIndicator(),
                    SizedBox(height: TSizes.sizeMedium),
                    Text(MTexts.loadinginfo),
                  ],
                ),
              );
            }

            if (state is AttendanceLoaded) {
              return _buildAttendanceScreenContent(state, attendanceBloc);
            }

            return const Center(
              child: Text(MTexts.errorwhileloadinginfo),
            );
          },

          // builder: (context, state) {
          //   if (state is AttendanceLoading ||
          //       state is LocationLoading ||
          //       state is FaceRegistrationLoading) {
          //     return const Center(child: CircularProgressIndicator());
          //   } else if (state is NoAttendanceState) {
          //     return const Center(child: Text('لا يتوفر بصمه لك !'));
          //   } else if (state is AttendanceLoaded) {
          //     return _buildAttendanceScreenContent(state, attendanceBloc);
          //   } else {
          //     return Container();
          //   }
          // },
        ),
      ),
    );
  }

  ///
  Widget _buildLocationErrorView(LocationServiceState state) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sizeMedium),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_off,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: TSizes.sizeMedium),
            Text(state.message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium
                //const TextStyle(fontSize: TSizes.sizeMedium),
                ),
            if (state.canOpenSettings) ...[
              const SizedBox(height: TSizes.sizeMedium),
              ElevatedButton(
                onPressed: () {
                  context.read<AttendanceBloc>().add(OpenLocationSettings());
                },
                child: const Text(MTexts.opensetting),
              ),
            ],
            const SizedBox(height: TSizes.sizeMedium),
            TextButton(
              onPressed: () {
                context.read<AttendanceBloc>().add(RetryLocation());
              },
              child: const Text(MTexts.trynow),
            ),
          ],
        ),
      ),
    );
  }

  ///
  ///
  void _showLocationServiceDialog({
    required BuildContext context,
    required String message,
    required bool canOpenSettings,
    required LocationStatus status,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(MTexts.noti),
          content: Text(message),
          actions: [
            if (canOpenSettings)
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<AttendanceBloc>().add(OpenLocationSettings());
                },
                child: const Text(MTexts.opensetting),
              ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<AttendanceBloc>().add(RetryLocation());
              },
              child: const Text(MTexts.trynow),
            ),
          ],
        );
      },
    );
  }

  ///

  Widget _buildAttendanceScreenContent(
    AttendanceLoaded state,
    AttendanceBloc attendanceBloc,
  ) {
    final attendanceData = state.attendanceData.groupMemberData!;
    final attendanceLocations = state.attendanceData.attendanceLocations;
    bool isNearLocation = false;
    AttendanceLocation? nearestLocation;
    double? nearestDistance;

    // Determine proximity to attendance locations
    for (var place in attendanceLocations) {
      final distance = calculateDistance(
          userLocation.latitude,
          userLocation.longitude,
          place.latitude ?? 0.0,
          place.longitude ?? 0.0);
      if (distance <= 100) {
        isNearLocation = true;
        if (nearestLocation == null || distance < nearestDistance!) {
          nearestLocation = place;
          nearestDistance = distance;
        }
        break;
      }
    }

    return Column(
      children: [
        UserAttendanceInfoCard(
          userImage: attendanceData.imagePath ?? '',
          userName: attendanceData.name ?? '',
          groupCode: attendanceData.groupCode,
          instanceId: attendanceData.instanceId,
          branchId: attendanceData.companyBranchInstanceId,
          branchName: attendanceData.branchName,
          sectorId: attendanceData.sectorId,
          sectorName: attendanceData.sectorName,
          missionName: attendanceData.missionName,
        ),
        const SizedBox(height: TSizes.sizeSmall),
        TimeDateWidget(dateTime: attendanceData.dayDate ?? DateTime.now()),
        const SizedBox(height: TSizes.sizeboxHeight),
        CheckInOutButton(
          isCheckedIn: attendanceData.checkedIn,
          isCheckedOut: attendanceData.checkedOut,
          onPressed: () => _onCheckInOutPressed(
            attendanceData,
            isNearLocation,
            nearestLocation,
            attendanceBloc,
          ),
        ),
        const SizedBox(height: TSizes.sizeboxHeight),
        ShiftTimeText(
          shiftStart: attendanceData.startTimeString,
          shiftEnd: attendanceData.endTimeString,
        ),
        const SizedBox(height: TSizes.sizeboxHeight),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TimesBoxes(
                iconPath: 'assets/images/icons/total_time.png',
                labelText: MTexts.inhoure,
                time: attendanceData.actualStartTimeString),
            TimesBoxes(
                iconPath: 'assets/images/icons/out_time.png',
                labelText: MTexts.in_out,
                time: attendanceData.actualEndTimeString),
            TimesBoxes(
                iconPath: 'assets/images/icons/total_time.png',
                labelText: MTexts.hourswork,
                time: attendanceData.shiftHours.toString()),
          ],
        ),
        AttendanceMap(userLocation: userLocation, places: attendanceLocations),
      ],
    );
  }

  void _onCheckInOutPressed(GroupMemberData attendanceData, bool isNearLocation,
      AttendanceLocation? nearestLocation, AttendanceBloc bloc) async {
    final isFaceRegistered = attendanceData.faceRegisterd;
    final userToken = widget.userToken;

    if (isFaceRegistered!) {
      // Scenario 1: User's face is already registered
      final faceImage = await bloc.takePicture();
      if (faceImage != null) {
        bloc.add(TakeAttendanceWithFace(
          userToken: userToken,
          groupMemberSID: int.parse(attendanceData.groupCode!),
          attendanceLocationSID: nearestLocation?.id,
          longitude: userLocation.longitude,
          latitude: userLocation.latitude,
          attType: attendanceData.checkedIn ? 2 : 1,
          nextDay: attendanceData.nextDay!,
          dayDate: attendanceData.dayDate!,
          faceImage: faceImage,
        ));
      } else {
        _showErrorDialog('Failed to capture image. Please try again.');
      }
    } else {
      // Scenario 2: User's face is not registered
      final faceImage = await bloc.takePicture();
      if (faceImage != null) {
        bloc.add(RegisterFace(userToken: userToken, faceImage: faceImage));
        bloc.add(TakeAttendanceWithFace(
          userToken: userToken,
          groupMemberSID: int.parse(attendanceData.groupCode!),
          attendanceLocationSID: nearestLocation?.id,
          longitude: userLocation.longitude,
          latitude: userLocation.latitude,
          attType: attendanceData.checkedIn ? 2 : 1,
          nextDay: attendanceData.nextDay!,
          dayDate: attendanceData.dayDate!,
          faceImage: faceImage,
        ));
      } else {
        _showErrorDialog('Failed to capture image. Please try again.');
      }
    }
  }

  void _showAttendanceDialog(
      {required String title,
      required String content,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AskForConfirmationDialog(
          backgroundColor: Colors.red.shade50,
          title: title,
          content: content,
          onConfirm: onConfirm,
        );
      },
    );
  }

  void _showSuccessDialog(StatusResponseModel responseModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: responseModel.type,
          content: responseModel.message,
        );
      },
    );
  }

  void _showFaceRegistrationDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: MTexts.faceRegistration,
          content: message,
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ErrorDialog(content: message);
      },
    );
  }
}

void showLoadingDialog(BuildContext context,
    {String loadingText = MTexts.loading}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => _LoadingDialog(loadingText: loadingText),
  );
}

class _LoadingDialog extends StatelessWidget {
  final String loadingText;

  const _LoadingDialog({super.key, this.loadingText = MTexts.loading});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.black.withOpacity(0.6),
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(TSizes.sizeSmall)),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.sizeMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SunDoubleBounceIndicator(),
            // CircularProgressIndicator(color: Colors.white),
            const SizedBox(height: TSizes.sizeMedium),
            Text(
              loadingText,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .apply(color: Colors.white),
              //const TextStyle(color: Colors.white, fontSize: TSizes.sizeMedium),
            ),
          ],
        ),
      ),
    );
  }
}

// double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
//   final distanceLatitude = (lat2 - lat1) * (pi / 180) * 6371000; // Meters
//   final distanceLongitude =
//       (lon2 - lon1) * (pi / 180) * 6371000 * cos(lat1 * (pi / 180)); // Meters
//   final distance = sqrt(distanceLatitude * distanceLatitude +
//       distanceLongitude * distanceLongitude);
//   return distance;
// }
// // Add this extension to your AttendanceModel or GroupMemberData class

// class AttendanceScreen extends StatefulWidget {
//   final String userToken;

//   const AttendanceScreen({super.key, required this.userToken});
//   @override
//   State<AttendanceScreen> createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   late CountDownController _countDownController; // Define CountDownController

//   @override
//   void initState() {
//     super.initState();
//     final attendanceBloc = locator<AttendanceBloc>();
//     attendanceBloc.add(FetchLocation());
//     _countDownController =
//         CountDownController(); // Initialize CountDownController
//   }

//   LatLng userLocation = LatLng(21.422922, 39.827812); // Initial marker position

//   @override
//   Widget build(BuildContext context) {
//     final attendanceBloc = locator<AttendanceBloc>();

//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         backgroundColor: Colors.transparent,
//         title: const Text(
//           'الحضور والانصراف',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.sizeExtraMedium),
//           child: BlocConsumer<AttendanceBloc, AttendanceState>(
//             listener: (context, state) {
//               if (state is LocationLoaded) {
//                 final position = state.markerPosition;
//                 userLocation = LatLng(position.latitude, position.longitude);
//                 attendanceBloc
//                     .add(LoadAttendanceData(userToken: widget.userToken));
//               } else if (state is AttendanceCheckedInOutSuccess) {
//                 attendanceBloc
//                     .add(LoadAttendanceData(userToken: widget.userToken));
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return ConfirmationDialog(
//                       title: state.statusResponseModel.type,
//                       content: state.statusResponseModel.message,
//                     );
//                   },
//                 );
//               } else if (state is AttendanceCheckedInOutSuccessWarning) {
//                 attendanceBloc
//                     .add(LoadAttendanceData(userToken: widget.userToken));
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return ErrorDialog(
//                       iconPath: 'assets/images/icons/info_.png',
//                       title: state.statusResponseModel.type,
//                       content: state.statusResponseModel.message,
//                     );
//                   },
//                 );
//               } else if (state is AttendanceCheckedInOutSuccessError) {
//                 attendanceBloc
//                     .add(LoadAttendanceData(userToken: widget.userToken));
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return ErrorDialog(
//                       title: state.statusResponseModel.type,
//                       content: state.statusResponseModel.message,
//                     );
//                   },
//                 );
//               } else if (state is AttendanceCheckedInOutFailure) {
//                 attendanceBloc
//                     .add(LoadAttendanceData(userToken: widget.userToken));
//                 showDialog(
//                   context: context,
//                   builder: (BuildContext context) {
//                     return ErrorDialog(
//                       content: state.error,
//                     );
//                   },
//                 );
//               }
//             },
//             builder: (context, state) {
//               if (state is AttendanceLoading || state is LocationLoading) {
//                 return const Center(child: CircularProgressIndicator());
//               } else if (state is NoAttendanceState) {
//                 return const Center(
//                   child: Text('لا يتوفر بصمه لك !'),
//                 );
//               } else if (state is AttendanceLoaded) {
//                 final attendanceData = state.attendanceData.groupMemberData;
//                 final attendanceLocations =
//                     state.attendanceData.attendanceLocations;

//                 bool isNearLocation = false; // Flag for check-in button
//                 AttendanceLocation? nearestLocation;
//                 double? nearestDistance;

//                 // Calculate distance and determine proximity
//                 for (var place in attendanceLocations) {
//                   final distance = calculateDistance(
//                     userLocation.latitude,
//                     userLocation.longitude,
//                     place.latitude ?? 0.0,
//                     place.longitude ?? 0.0,
//                   );

//                   if (distance <= 100) {
//                     isNearLocation = true;
//                     if (nearestLocation == null ||
//                         distance < nearestDistance!) {
//                       nearestLocation = place;
//                       nearestDistance = distance;
//                     }
//                     break; // Exit the loop after finding an eligible location
//                   }
//                 }

//                 return Column(
//                   children: [
//                     //* User Info Card Widget
//                     UserAttendanceInfoCard(
//                       userImage: attendanceData?.imagePath ?? '',
//                       userName: attendanceData?.name ?? '',
//                       groupCode: attendanceData?.groupCode,
//                       instanceId: attendanceData?.instanceId,
//                       branchId: attendanceData?.companyBranchInstanceId,
//                       branchName: attendanceData?.branchName,
//                       sectorId: attendanceData?.sectorId,
//                       sectorName: attendanceData?.sectorName,
//                       missionName: attendanceData?.missionName,
//                     ),
//                     SizedBox(
//                       height: TSizes.sizeSmall.h,
//                     ),
//                     //* Time and Date Widget
//                     TimeDateWidget(
//                       dateTime: attendanceData?.dayDate ?? DateTime.now(),
//                     ),
//                     SizedBox(
//                       height: TSizes.sizeboxHeight.h,
//                     ),
//                     //* Attendance Button // Timer
//                     CheckInOutButton(
//                       isCheckedIn: attendanceData!.checkedIn,
//                       isCheckedOut: attendanceData.checkedOut,
//                       onPressed: () async {
//                         if (!isNearLocation && !attendanceData.checkedIn) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AskForConfirmationDialog(
//                                 backgroundColor: Colors.red.shade50,
//                                 title: 'أنت خارج نطاق موقع الحضور',
//                                 content: 'هل انت متاكد من تسجيل حضورك',
//                                 onConfirm: () {
//                                   attendanceBloc.add(CheckIn(
//                                     userToken: widget.userToken,
//                                     groupMemberSID:
//                                         int.parse(attendanceData.groupCode!),
//                                     attendanceLocationSID: nearestLocation?.id,
//                                     longitude: userLocation.longitude,
//                                     latitude: userLocation.latitude,
//                                     attType: 1,
//                                     nextDay: attendanceData.nextDay!,
//                                     dayDate: attendanceData.dayDate.toString(),
//                                   ));
//                                   _countDownController.start();
//                                 },
//                               );
//                             },
//                           );
//                         } else if (isNearLocation &&
//                             !attendanceData.checkedIn) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AskForConfirmationDialog(
//                                 content: 'هل انت متاكد من تسجيل حضورك',
//                                 onConfirm: () {
//                                   attendanceBloc.add(CheckIn(
//                                     userToken: widget.userToken,
//                                     groupMemberSID:
//                                         int.parse(attendanceData.groupCode!),
//                                     attendanceLocationSID: nearestLocation?.id,
//                                     longitude: userLocation.longitude,
//                                     latitude: userLocation.latitude,
//                                     attType: 1,
//                                     nextDay: attendanceData.nextDay!,
//                                     dayDate: attendanceData.dayDate.toString(),
//                                   ));
//                                   _countDownController.start();
//                                 },
//                               );
//                             },
//                           );
//                         } else if (!isNearLocation &&
//                             attendanceData.checkedIn &&
//                             !attendanceData.checkedOut) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AskForConfirmationDialog(
//                                 backgroundColor: Colors.red.shade50,
//                                 title: 'أنت خارج نطاق موقع انصرافك',
//                                 content: 'هل انت متاكد من تسجيل انصرافك',
//                                 onConfirm: () {
//                                   attendanceBloc.add(CheckIn(
//                                     userToken: widget.userToken,
//                                     groupMemberSID:
//                                         int.parse(attendanceData.groupCode!),
//                                     attendanceLocationSID: nearestLocation?.id,
//                                     longitude: userLocation.longitude,
//                                     latitude: userLocation.latitude,
//                                     attType: 2,
//                                     nextDay: attendanceData.nextDay!,
//                                     dayDate: attendanceData.dayDate.toString(),
//                                   ));
//                                 },
//                               );
//                             },
//                           );
//                         } else if (attendanceData.checkedIn &&
//                             !attendanceData.checkedOut) {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return AskForConfirmationDialog(
//                                 content: 'هل انت متاكد من تسجيل انصرافك',
//                                 onConfirm: () {
//                                   attendanceBloc.add(CheckIn(
//                                     userToken: widget.userToken,
//                                     groupMemberSID:
//                                         int.parse(attendanceData.groupCode!),
//                                     attendanceLocationSID: nearestLocation?.id,
//                                     longitude: userLocation.longitude,
//                                     latitude: userLocation.latitude,
//                                     attType: 2,
//                                     nextDay: attendanceData.nextDay!,
//                                     dayDate: attendanceData.dayDate.toString(),
//                                   ));
//                                 },
//                               );
//                             },
//                           );
//                         } else {
//                           showDialog(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return ErrorDialog(
//                                   content: 'لقد سجلت الحضور والانصراف');
//                             },
//                           );
//                         }
//                       },
//                     ),

//                     SizedBox(
//                       height: TSizes.sizeboxHeight.h,
//                     ),
//                     //* Shift time
//                     ShiftTimeText(
//                       shiftStart: attendanceData.startTimeString,
//                       shiftEnd: attendanceData.endTimeString,
//                     ),
//                     SizedBox(
//                       height: TSizes.sizeboxHeight.h,
//                     ),
//                     //* times Boxes
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         TimesBoxes(
//                           iconPath: 'assets/images/icons/in_time.png',
//                           labelText: 'ميعاد الحضور',
//                           time: attendanceData.actualStartTimeString,
//                         ),
//                         TimesBoxes(
//                           iconPath: 'assets/images/icons/out_time.png',
//                           labelText: 'ميعاد الانصراف',
//                           time: attendanceData.actualEndTimeString,
//                         ),
//                         TimesBoxes(
//                           iconPath: 'assets/images/icons/total_time.png',
//                           labelText: 'ساعات العمل',
//                           time: attendanceData.shiftHours.toString(),
//                         ),
//                       ],
//                     ),
//                     //* Map
//                     AttendanceMap(
//                       userLocation: userLocation,
//                       places: attendanceLocations,
//                     )
//                   ],
//                 );
//               } else {
//                 return Container();
//               }
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
