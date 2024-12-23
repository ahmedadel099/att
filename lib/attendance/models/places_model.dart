
class AttendanceModel {
  AttendanceModel({
    required this.groupMemberData,
    required this.attendanceLocations,
  });

  final GroupMemberData? groupMemberData;
  final List<AttendanceLocation> attendanceLocations;

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      groupMemberData: json["groupMemberData"] == null
          ? null
          : GroupMemberData.fromJson(json["groupMemberData"]),
      attendanceLocations: json["attendanceLocations"] == null
          ? []
          : List<AttendanceLocation>.from(json["attendanceLocations"]!
              .map((x) => AttendanceLocation.fromJson(x))),
    );
  }
}

class AttendanceLocation {
  AttendanceLocation({
    required this.groupInstanceSid,
    required this.branchInstanceSid,
    required this.sectorSid,
    required this.locationName,
    required this.season,
    required this.status,
    required this.longitude,
    required this.latitude,
    this.id,
    required this.encId,
  });

  final int? groupInstanceSid;
  final int? branchInstanceSid;
  final int? sectorSid;
  final String? locationName;
  final int? season;
  final int? status;
  final double? longitude;
  final double? latitude;
  final int? id;
  final String? encId;

  factory AttendanceLocation.fromJson(Map<String, dynamic> json) {
    return AttendanceLocation(
      groupInstanceSid: json["groupInstance_SID"],
      branchInstanceSid: json["branchInstance_SID"],
      sectorSid: json["sector_SID"],
      locationName: json["locationName"],
      season: json["season"],
      status: json["status"],
      longitude: json["longitude"],
      latitude: json["latitude"],
      id: json["id"],
      encId: json["encId"],
    );
  }
}

class GroupMemberData {
  GroupMemberData({
    required this.memberId,
    required this.partyId,
    required this.cardNo,
    required this.name,
    required this.groupCode,
    required this.instanceId,
    required this.fingerPrintImage,
    required this.season,
    required this.missionName,
    required this.sectorName,
    required this.branchName,
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.startTimeFormate,
    required this.startTimeString,
    required this.endTime,
    required this.endTimeFormate,
    required this.endTimeString,
    required this.nextDay,
    required this.actualStartTime,
    required this.actualStartTimeFormate,
    required this.actualStartTimeString,
    required this.actualEndTime,
    required this.actualEndTimeFormate,
    required this.actualEndTimeString,
    required this.sectorId,
    required this.companyBranchInstanceId,
    required this.dayDate,
    required this.checkedIn,
    required this.shiftDuration,
    required this.shiftHours,
    required this.remainingShiftMinutes,
    required this.shiftTotalMinutes,
    required this.checkedOut,
    required this.imagePath,
    required this.faceRegisterd,
  });

  final bool checkedIn;
  final int? shiftTotalMinutes;
  final int? shiftDuration;
  final int? memberId;
  final int? partyId;
  final String? cardNo;
  final String? name;
  final String? groupCode;
  final int? instanceId;
  final List<String> fingerPrintImage;
  final int? season;
  final String? missionName;
  final String? sectorName;
  final String? branchName;
  final int? shiftId;
  final String? shiftName;
  final int? startTime;
  final String? startTimeFormate;
  final String? startTimeString;
  final int? endTime;
  final String? endTimeFormate;
  final String? endTimeString;
  final String? imagePath;
  final bool? nextDay;
  final bool checkedOut;
  final int? actualStartTime;
  final String? actualStartTimeFormate;
  final String? actualStartTimeString;
  final int? actualEndTime;
  final String? actualEndTimeFormate;
  final String? actualEndTimeString;
  final int? sectorId;
  final int? companyBranchInstanceId;
  final int? shiftHours;
  final int? remainingShiftMinutes;
  final DateTime? dayDate;
    final bool? faceRegisterd;


  factory GroupMemberData.fromJson(Map<String, dynamic> json) {
    return GroupMemberData(
      memberId: json["memberId"],
      imagePath: json["imagePath"],
      checkedOut: json["checkedOut"],
      shiftTotalMinutes: json["shiftTotalMinutes"],
      shiftHours: json["shiftHours"],
      remainingShiftMinutes: json["remainingShiftMinutes"],
      shiftDuration: json["shiftTotalMinutes"],
      checkedIn: json["checkedIn"],
      partyId: json["partyId"],
      cardNo: json["cardNo"],
      name: json["name"],
      groupCode: json["groupCode"],
      instanceId: json["instanceId"],
      fingerPrintImage: json["fingerPrintImage"] == null
          ? []
          : List<String>.from(json["fingerPrintImage"]!.map((x) => x)),
      season: json["season"],
      missionName: json["missionName"],
      sectorName: json["sectorName"],
      branchName: json["branchName"],
      shiftId: json["shiftId"],
      shiftName: json["shiftName"],
      startTime: json["startTime"],
      startTimeFormate: json["startTimeFormate"],
      startTimeString: json["startTimeString"],
      endTime: json["endTime"],
      endTimeFormate: json["endTimeFormate"],
      endTimeString: json["endTimeString"],
      nextDay: json["nextDay"],
      actualStartTime: json["actualStartTime"],
      actualStartTimeFormate: json["actualStartTimeFormate"],
      actualStartTimeString: json["actualStartTimeString"],
      actualEndTime: json["actualEndTime"],
      actualEndTimeFormate: json["actualEndTimeFormate"],
      actualEndTimeString: json["actualEndTimeString"],
      faceRegisterd: json["faceRegisterd"],
      sectorId: json["sectorId"],
      companyBranchInstanceId: json["companyBranchInstanceId"],
      dayDate: DateTime.tryParse(json["dayDate"] ?? ""),
    );
  }
}
