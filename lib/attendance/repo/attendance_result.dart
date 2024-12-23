import '../models/places_model.dart';

class AttendanceResult {
  final AttendanceModel? data;
  final String? message;
  final bool isNoAttendance;
  final bool isError;

  AttendanceResult.data(this.data)
      : message = null,
        isNoAttendance = false,
        isError = false;
  AttendanceResult.noAttendance(this.message)
      : data = null,
        isNoAttendance = true,
        isError = false;
  AttendanceResult.error(this.message)
      : data = null,
        isNoAttendance = false,
        isError = true;
}
