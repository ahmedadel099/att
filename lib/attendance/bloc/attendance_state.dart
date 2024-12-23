import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/services/location_service.dart';
import '../../notifications_reports/hajj_guidance/models/status_response_model.dart';
import '../models/places_model.dart';

abstract class AttendanceState extends Equatable {
  final LocationStatus? locationStatus;

  const AttendanceState({this.locationStatus});

  @override
  List<Object?> get props => [locationStatus];
}

class LocationServiceState extends AttendanceState {
  final String message;
  final bool canOpenSettings;
  final LocationStatus status;

  const LocationServiceState({
    required this.message,
    required this.canOpenSettings,
    required this.status,
  }) : super(locationStatus: status);

  @override
  List<Object?> get props => [message, canOpenSettings, status];
}

class AttendanceInitial extends AttendanceState {}

class AttendanceLoading extends AttendanceState {}

class AttendanceLoaded extends AttendanceState {
  final AttendanceModel attendanceData;
  const AttendanceLoaded(this.attendanceData);
}

class AttendanceError extends AttendanceState {
  final String error;
  const AttendanceError(this.error);
}

class LocationLoading extends AttendanceState {}

class LocationLoaded extends AttendanceState {
  final LatLng position;
  final LatLng markerPosition;

  const LocationLoaded(this.position, {required this.markerPosition});

  LocationLoaded copyWith({LatLng? newPosition, LatLng? newMarkerPosition}) {
    return LocationLoaded(
      newPosition ?? position,
      markerPosition: newMarkerPosition ?? markerPosition,
    );
  }
}

class LocationError extends AttendanceState {
  final String message;
  const LocationError(this.message);
}

class AttendanceCheckedInOutSuccess extends AttendanceState {
  final StatusResponseModel statusResponseModel;
  const AttendanceCheckedInOutSuccess({required this.statusResponseModel});
}

class AttendanceCheckedInOutSuccessWarning extends AttendanceState {
  final StatusResponseModel statusResponseModel;
  const AttendanceCheckedInOutSuccessWarning(
      {required this.statusResponseModel});
}

class AttendanceCheckedInOutSuccessError extends AttendanceState {
  final StatusResponseModel statusResponseModel;
  const AttendanceCheckedInOutSuccessError({required this.statusResponseModel});
}

class AttendanceCheckedInOutFailure extends AttendanceState {
  final String error;
  const AttendanceCheckedInOutFailure(this.error);
}

class AttendanceCheckedInOutNotFound extends AttendanceState {
  final String error;
  const AttendanceCheckedInOutNotFound({required this.error});
}

class NoAttendanceState extends AttendanceState {
  final String message;
  const NoAttendanceState(this.message);
}

class TimerRunInProgress extends AttendanceState {
  final int remainingDuration;
  const TimerRunInProgress(this.remainingDuration);
}

class TimerRunComplete extends AttendanceState {}

class CurrentTimeFetched extends AttendanceState {
  final String formattedTime;
  final String formattedDate;
  const CurrentTimeFetched(this.formattedTime, this.formattedDate);
}

// New states for face registration
class FaceRegistrationLoading extends AttendanceState {}

class FaceRegistrationSuccess extends AttendanceState {
  final String message;
  const FaceRegistrationSuccess(this.message);
}

class FaceRegistrationFailure extends AttendanceState {
  final String error;
  const FaceRegistrationFailure(this.error);
}






// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:mashariq_app/features/attendance/models/places_model.dart';
// import 'package:mashariq_app/features/notifications/hajj_guidance/models/status_response_model.dart';

// abstract class AttendanceState {}

// class AttendanceLoading extends AttendanceState {}

// class AttendanceLoaded extends AttendanceState {
//   final AttendanceModel attendanceData;

//   AttendanceLoaded(this.attendanceData);
// }

// class AttendanceError extends AttendanceState {
//   final String error;

//   AttendanceError(this.error);
// }

// class LocationLoading extends AttendanceState {}

// // location_state.dart
// class LocationLoaded extends AttendanceState {
//   final LatLng position;
//   final LatLng markerPosition;

//   LocationLoaded(this.position, {required this.markerPosition});

//   @override
//   List<Object> get props => [position, markerPosition];

//   LocationLoaded copyWith({LatLng? newPosition, LatLng? newMarkerPosition}) {
//     return LocationLoaded(
//       newPosition ?? this.position,
//       markerPosition: newMarkerPosition ?? this.markerPosition,
//     );
//   }
// }

// class LocationError extends AttendanceState {
//   final String message;

//   LocationError(this.message);

//   @override
//   List<Object> get props => [message];
// }

// // check in/out

// class AttendanceCheckedInOutSuccess extends AttendanceState {
//   StatusResponseModel statusResponseModel;

//   AttendanceCheckedInOutSuccess({required this.statusResponseModel});
// }

// class AttendanceCheckedInOutSuccessWarning extends AttendanceState {
//   StatusResponseModel statusResponseModel;

//   AttendanceCheckedInOutSuccessWarning({required this.statusResponseModel});
// }

// class AttendanceCheckedInOutSuccessError extends AttendanceState {
//   StatusResponseModel statusResponseModel;

//   AttendanceCheckedInOutSuccessError({required this.statusResponseModel});
// }

// class AttendanceCheckedInOutFailure extends AttendanceState {
//   final String error;

//   AttendanceCheckedInOutFailure(this.error);
// }

// class AttendanceCheckedInOutNotFound extends AttendanceState {
//   final String error;

//   AttendanceCheckedInOutNotFound({required this.error});
// }

// // timer
// class TimerRunInProgress extends AttendanceState {
//   final int remainingDuration;
//   TimerRunInProgress(this.remainingDuration);
// }

// class TimerRunComplete extends AttendanceState {}

// // date time
// class CurrentTimeFetched extends AttendanceState {
//   final String formattedTime;
//   final String formattedDate;

//   CurrentTimeFetched(this.formattedTime, this.formattedDate);
// }
