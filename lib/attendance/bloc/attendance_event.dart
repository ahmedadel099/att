import 'dart:io';

abstract class AttendanceEvent {}

class LoadAttendanceData extends AttendanceEvent {
  final String? userToken;
  LoadAttendanceData({ this.userToken});
}

class FetchLocation extends AttendanceEvent {
  final String? userToken;

  FetchLocation({ this.userToken});
}

class OpenLocationSettings extends AttendanceEvent {}

class RetryLocation extends AttendanceEvent {
  @override
  List<Object?> get props => [];
}

// New events for face registration
class RegisterFace extends AttendanceEvent {
  final String userToken;
  final File faceImage;
  RegisterFace({required this.userToken, required this.faceImage});
}

class TakeAttendanceWithFace extends AttendanceEvent {
  final String userToken;
  final int attType;
  final int groupMemberSID;
  final int? attendanceLocationSID;
  final double longitude;
  final double latitude;
  final bool nextDay;
  final DateTime dayDate;
  final File faceImage;

  TakeAttendanceWithFace({
    required this.userToken,
    required this.attType,
    required this.groupMemberSID,
    this.attendanceLocationSID,
    required this.nextDay,
    required this.dayDate,
    required this.longitude,
    required this.latitude,
    required this.faceImage,
  });
}

class CheckIn extends AttendanceEvent {
  final String userToken;
  final int attType;
  final int groupMemberSID;
  final int? attendanceLocationSID;
  final double longitude;
  final double latitude;
  final bool nextDay;
  final String? dayDate;

  CheckIn({
    required this.userToken,
    required this.attType,
    required this.groupMemberSID,
    this.attendanceLocationSID,
    required this.nextDay,
    this.dayDate,
    required this.longitude,
    required this.latitude,
  });
}

class FetchCurrentTimeDate extends AttendanceEvent {}

class StartTimer extends AttendanceEvent {
  final int duration;
  StartTimer(this.duration);
}

class TimerTick extends AttendanceEvent {
  final int remainingDuration;
  TimerTick(this.remainingDuration);
}


// abstract class AttendanceEvent {}

// class LoadAttendanceData extends AttendanceEvent {
//   final String userToken;

//   LoadAttendanceData({required this.userToken});
// }

// class FetchLocation extends AttendanceEvent {}

// class CheckIn extends AttendanceEvent {
//   final String userToken;
//   final int attType;
//   final int groupMemberSID;
//   final int? attendanceLocationSID;
//   final double longitude;
//   final double latitude;
//   final bool nextDay;
//   final String? dayDate;

//   CheckIn(
//       {required this.userToken,
//       required this.attType,
//       required this.groupMemberSID,
//       this.attendanceLocationSID,
//       required this.nextDay,
//       this.dayDate,
//       required this.longitude,
//       required this.latitude});
// }

// class CheckOut extends AttendanceEvent {
//   final int placeId;

//   CheckOut(this.placeId);
// }

// class StartTimer extends AttendanceEvent {
//   final int duration;
//   StartTimer(this.duration);
// }

// class Tick extends AttendanceEvent {
//   final int remainingDuration;
//   Tick(this.remainingDuration);
// }

// // date time
// class FetchCurrentTimeDate extends AttendanceEvent {}

