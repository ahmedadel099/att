import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

import '../../../core/constants/api_endpoints.dart';
import '../../../core/resources/api_service.dart';
import '../models/places_model.dart';
import 'attendance_result.dart';

class AttendanceRepository {
  final ApiService _apiService;

  AttendanceRepository(this._apiService);

  Future<AttendanceResult> getMemberAttendanceData(
      {required String userToken}) async {
    try {
      final response = await _apiService.dio.get(
        ApiEndpoints.memberAttendanceData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200) {
        return AttendanceResult.data(AttendanceModel.fromJson(response.data));
      } else if (response.statusCode == 404) {
        return AttendanceResult.noAttendance(
            'No attendance data available for this user.');
      } else {
        return AttendanceResult.error(
            'Failed to get attendance data. Status code: ${response.statusCode}');
      }
    } catch (e) {
      return AttendanceResult.error(
          'An unexpected error occurred: ${e.toString()}');
    }
  }

  Future<Response> registerFace({
    required String userToken,
    required File faceImage,
  }) async {
    try {
      // Check the file extension
      String mimeType = '';
      final String extension = faceImage.path.split('.').last.toLowerCase();

      if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        throw Exception('Unsupported file type. Please use JPG or PNG.');
      }

      FormData formData = FormData.fromMap({
        'FaceImage': await MultipartFile.fromFile(
          faceImage.path,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _apiService.dio.post(
        ApiEndpoints.registerFace,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(
            'Failed to register face. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to register face: ${error.toString()}');
    }
  }

  Future<Response> checkInWithFace({
    required String userToken,
    required int attType,
    required int groupMemberSID,
    int? attendanceLocationSID,
    required double longitude,
    required double latitude,
    required bool nextDay,
   required DateTime dayDate,
    required File faceImage,
  }) async {
    try {
      // Check the file extension
      String mimeType = '';
      final String extension = faceImage.path.split('.').last.toLowerCase();

      if (extension == 'jpg' || extension == 'jpeg') {
        mimeType = 'image/jpeg';
      } else if (extension == 'png') {
        mimeType = 'image/png';
      } else {
        throw Exception('Unsupported file type. Please use JPG or PNG.');
      }

      FormData formData = FormData.fromMap({
        'attType': attType,
        'groupMember_SID': groupMemberSID,
        'attendnaceLocation_SID': attendanceLocationSID,
        'longitude': longitude,
        'latitude': latitude,
        'nextDay': nextDay,
        'dayDate': dayDate.toIso8601String(),
        'faceImage': await MultipartFile.fromFile(
          faceImage.path,
          contentType: MediaType.parse(mimeType),
        ),
      });

      final response = await _apiService.dio.post(
        ApiEndpoints.addAttendance,
        data: formData,
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception(
            'Failed to check in. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to check in: ${error.toString()}');
    }
  }

  Future<Response> checkIn({
    required String userToken,
    required int attType,
    required int groupMemberSID,
    int? attendanceLocationSID,
    required double longitude,
    required double latitude,
    required bool nextDay,
    String? dayDate,
  }) async {
    try {
      final response = await _apiService.dio.post(
        ApiEndpoints.addAttendance,
        data: {
          'attType': attType,
          'groupMember_SID': groupMemberSID,
          'attendnaceLocation_SID': attendanceLocationSID,
          'longitude': longitude,
          'latitude': latitude,
          'nextDay': nextDay,
          'dayDate': dayDate,
        },
        options: Options(headers: {'Authorization': 'Bearer $userToken'}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else if (response.statusCode == 404) {
        return throw Exception('No Attendance');
      } else if (response.statusCode == 400) {
        return throw Exception('No Face Registered');
      } else {
        throw Exception(
            'Failed to check in. Status code: ${response.statusCode}');
      }
    } on DioException catch (error) {
      throw Exception('Failed to check in: ${error.message}');
    }
  }
}



// import 'package:dio/dio.dart';
// import 'package:mashariq_app/core/constants/api_endpoints.dart';
// import 'package:mashariq_app/features/attendance/models/places_model.dart';

// import '../../../core/resources/api_service.dart';

// // Repository
// class AttendanceRepository {
//   final ApiService _apiService;

//   AttendanceRepository(this._apiService);

//   Future<AttendanceModel> getMemberAttendanceData({
//     required String userToken,
//   }) async {
//     final response = await _apiService.dio.get(
//       ApiEndpoints.memberAttendanceData,
//       options: Options(
//         headers: {'Authorization': 'Bearer $userToken'},
//       ),
//     );

//     if (response.statusCode == 200) {
//       return AttendanceModel.fromJson(response.data);
//     } else if (response.statusCode == 404) {
//       throw ('you do not have attendance');
//     } else {
//       throw Exception(
//           'Failed to get attendance data. Status code: ${response.statusCode}');
//     }
//   }

//   Future<Response> checkIn({
//     required String userToken,
//     required int attType,
//     required int groupMemberSID,
//     int? attendanceLocationSID,
//     required double longitude,
//     required double latitude,
//     required bool nextDay,
//     String? dayDate,
//   }) async {
//     try {
//       final response = await _apiService.dio.post(
//         ApiEndpoints.addAttendance,
//         data: {
//           'attType': attType,
//           'groupMember_SID': groupMemberSID,
//           'attendnaceLocation_SID': attendanceLocationSID,
//           'longitude': longitude,
//           'latitude': latitude,
//           'nextDay': nextDay,
//           'dayDate': dayDate,
//         },
//         options: Options(
//           headers: {'Authorization': 'Bearer $userToken'},
//         ),
//       ); // Replace with your endpoint
//       print(
//           'Response status code: ${response.statusCode}'); // Added for debugging
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         return response;
//       } else if (response.statusCode == 404) {
//         return response;
//       } else {
//         throw Exception(
//             'Failed to check in. Status code: ${response.statusCode}');
//       }
//     } on DioException catch (error) {
//       print('DioException: ${error.message}'); // Added for debugging
//       throw Exception('Failed to check in: ${error.message}');
//     }
//   }

//   Future<void> checkOut(int placeId) async {
//     try {
//       final response = await _apiService.dio
//           .post('/api/check-out/$placeId'); // Replace with your endpoint
//       if (response.statusCode == 200 || response.statusCode == 201) {
//         // Handle successful check-out (update state, etc.)
//       } else {
//         throw Exception(
//             'Failed to check out. Status code: ${response.statusCode}');
//       }
//     } on DioError catch (error) {
//       throw Exception('Failed to check out: ${error.message}');
//     }
//   }
// }
