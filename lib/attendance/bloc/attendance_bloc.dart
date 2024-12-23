import 'dart:async';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../../../core/services/location_service.dart';
import '../../notifications_reports/hajj_guidance/models/status_response_model.dart';
import '../repo/attendance_repo.dart';
import 'attendance_event.dart';
import 'attendance_state.dart';

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;
  final LocationService _locationService;
  StreamSubscription<int>? _timerSubscription;
  final ImagePicker _imagePicker = ImagePicker();

  AttendanceBloc(this._repository, this._locationService)
      : super(AttendanceInitial()) {
    on<LoadAttendanceData>(_onLoadAttendanceData);
    on<FetchLocation>(_onFetchLocation);
    on<OpenLocationSettings>(_onOpenLocationSettings);
    on<RetryLocation>(_onRetryLocation);

    on<CheckIn>(_onCheckIn);
    on<FetchCurrentTimeDate>(_onFetchCurrentTimeDate);
    on<StartTimer>(_onStartTimer);
    on<TimerTick>(_onTimerTick);

    on<RegisterFace>(_onRegisterFace);
    on<TakeAttendanceWithFace>(_onTakeAttendanceWithFace);
  }

  // void _onFetchLocation(
  //     FetchLocation event, Emitter<AttendanceState> emit) async {
  //   emit(LocationLoading());
  //   try {
  //     final position = await _locationService.getCurrentLocation();
  //     final latLngPosition = LatLng(position.latitude, position.longitude);
  //     emit(LocationLoaded(latLngPosition, markerPosition: latLngPosition));
  //   } catch (error) {
  //     emit(LocationError(error.toString()));
  //   }
  // }
    Future<void> _onFetchLocation(
      FetchLocation event, Emitter<AttendanceState> emit) async {
    emit(LocationLoading());
    final locationResult = await _locationService.getCurrentLocation();
    if (locationResult.isSuccess && locationResult.position != null) {
      final position = locationResult.position!;
      final latLng = LatLng(position.latitude, position.longitude);
      emit(LocationLoaded(latLng, markerPosition: latLng));
      add(LoadAttendanceData(userToken: event.userToken));
    } else {
      switch (locationResult.status) {
        case LocationStatus.serviceDisabled:
          emit(LocationServiceState(
            message: locationResult.message,
            canOpenSettings: true,
            status: locationResult.status,
          ));
          break;
        case LocationStatus.permissionDenied:
        case LocationStatus.permissionDeniedForever:
          emit(LocationServiceState(
            message: locationResult.message,
            canOpenSettings: true,
            status: locationResult.status,
          ));
          break;
        case LocationStatus.mockLocationDetected:
          emit(LocationServiceState(
            message: locationResult.message,
            canOpenSettings: false,
            status: locationResult.status,
          ));
          break;
        default:
          emit(LocationError(locationResult.message));
      }
    }
  }
  Future<void> _onOpenLocationSettings(
      OpenLocationSettings event, Emitter<AttendanceState> emit) async {
    if (state is LocationServiceState) {
      final currentState = state as LocationServiceState;
      if (currentState.status == LocationStatus.serviceDisabled) {
        await _locationService.openLocationSettings();
      } else if (currentState.status == LocationStatus.permissionDenied ||
          currentState.status == LocationStatus.permissionDeniedForever) {
        await _locationService.openAppSettings();
      }
    }
  }

  Future<void> _onRetryLocation(
      RetryLocation event, Emitter<AttendanceState> emit) async {
    add(FetchLocation());
  }





  void _onLoadAttendanceData(
      LoadAttendanceData event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    try {
      final result =
          await _repository.getMemberAttendanceData(userToken: event.userToken!);
      if (result.isNoAttendance) {
        emit(NoAttendanceState(result.message!));
      } else if (result.isError) {
        emit(AttendanceError(result.message!));
      } else {
        emit(AttendanceLoaded(result.data!));
      }
    } catch (error) {
      emit(AttendanceError(error.toString()));
    }
  }

  void _onCheckIn(CheckIn event, Emitter<AttendanceState> emit) async {
    try {
      final response = await _repository.checkIn(
        userToken: event.userToken,
        groupMemberSID: event.groupMemberSID,
        attendanceLocationSID: event.attendanceLocationSID,
        longitude: event.longitude,
        latitude: event.latitude,
        attType: event.attType,
        nextDay: event.nextDay,
        dayDate: event.dayDate,
      );

      if (response.statusCode == 200) {
        final statusResponse = StatusResponseModel.fromJson(response.data);
        emit(_mapStatusResponseToState(statusResponse));
      } else if (response.statusCode == 404) {
        emit(AttendanceCheckedInOutNotFound(error: 'No Attendance'));
      } else if (response.statusCode == 400) {
        emit(AttendanceCheckedInOutFailure(
            'Status code: ${response.statusCode}'));
      } else {
        emit(AttendanceCheckedInOutFailure(
            'Status code: ${response.statusCode}'));
      }
    } catch (error) {
      emit(AttendanceCheckedInOutFailure(error.toString()));
    }
  }

  void _onFetchCurrentTimeDate(
      FetchCurrentTimeDate event, Emitter<AttendanceState> emit) {
    final now = DateTime.now();
    final formattedTime = DateFormat('h:mm a').format(now);
    final formattedDate = DateFormat('MMMM d, y').format(now);
    emit(CurrentTimeFetched(formattedTime, formattedDate));
  }

  void _onStartTimer(StartTimer event, Emitter<AttendanceState> emit) {
    _timerSubscription?.cancel();
    _timerSubscription = Stream.periodic(
            const Duration(seconds: 1), (x) => event.duration - x - 1)
        .take(event.duration)
        .listen((remainingDuration) => add(TimerTick(remainingDuration)));
    emit(TimerRunInProgress(event.duration));
  }

  void _onTimerTick(TimerTick event, Emitter<AttendanceState> emit) {
    if (event.remainingDuration > 0) {
      emit(TimerRunInProgress(event.remainingDuration));
    } else {
      _timerSubscription?.cancel();
      emit(TimerRunComplete());
    }
  }

  AttendanceState _mapStatusResponseToState(
      StatusResponseModel statusResponse) {
    switch (statusResponse.type) {
      case 'success':
        return AttendanceCheckedInOutSuccess(
            statusResponseModel: statusResponse);
      case 'warning':
        return AttendanceCheckedInOutSuccessWarning(
            statusResponseModel: statusResponse);
      case 'error':
        return AttendanceCheckedInOutSuccessError(
            statusResponseModel: statusResponse);
      default:
        return AttendanceCheckedInOutFailure('Unknown status type');
    }
  }

  Future<void> _onRegisterFace(
      RegisterFace event, Emitter<AttendanceState> emit) async {
    emit(FaceRegistrationLoading()); // Emit loading state
    try {
      final response = await _repository.registerFace(
        userToken: event.userToken,
        faceImage: event.faceImage,
      );

      // Check response and emit corresponding state
      if (response.statusCode == 200 || response.statusCode == 201) {
        emit(FaceRegistrationSuccess('Face registered successfully'));
        add(LoadAttendanceData(userToken: event.userToken));
      } else {
        emit(FaceRegistrationFailure('Failed to register face'));
      }
    } catch (error) {
      emit(FaceRegistrationFailure(error.toString()));
    }
  }

  Future<void> _onTakeAttendanceWithFace(
      TakeAttendanceWithFace event, Emitter<AttendanceState> emit) async {
    emit(FaceRegistrationLoading());
    try {
      final response = await _repository.checkInWithFace(
        userToken: event.userToken,
        attType: event.attType,
        groupMemberSID: event.groupMemberSID,
        attendanceLocationSID: event.attendanceLocationSID,
        longitude: event.longitude,
        latitude: event.latitude,
        nextDay: event.nextDay,
        dayDate: event.dayDate,
        faceImage: event.faceImage,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final statusResponse = StatusResponseModel.fromJson(response.data);
        emit(_mapStatusResponseToState(statusResponse));
      } else {
        emit(AttendanceCheckedInOutFailure('Failed to process attendance'));
      }
    } catch (error) {
      emit(AttendanceCheckedInOutFailure(error.toString()));
    }
  }

  Future<File?> takePicture() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera, // Ensure capturing from the camera
        preferredCameraDevice: CameraDevice.front,
      );

      // Log the image path if the image is captured
      if (image != null) {
        print('Captured image path: ${image.path}');
        return File(image.path);
      } else {
        print('No image was captured.');
        return null;
      }
    } catch (e) {
      print('Error taking picture: $e');
      return null;
    }
  }

  @override
  Future<void> close() {
    _timerSubscription?.cancel();
    return super.close();
  }
}





// class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
//   final AttendanceRepository _repository;
//   final LocationService _locationService;

//   AttendanceBloc(this._repository, this._locationService)
//       : super(AttendanceLoading()) {
//     // Fetch Current Time and Date Event
//     on<FetchCurrentTimeDate>((event, emit) {
//       final now = DateTime.now();
//       final formattedTime = DateFormat('h:mm a').format(now);
//       final formattedDate = DateFormat('MMMM d, y').format(now);
//       emit(CurrentTimeFetched(formattedTime, formattedDate));
//     });

//     on<FetchLocation>((event, emit) async {
//       emit(LocationLoading());
//       try {
//         final position = await _locationService.getCurrentLocation();
//         final latLngPosition = LatLng(position.latitude, position.longitude);

//         print(position);
//         emit(LocationLoaded(latLngPosition, markerPosition: latLngPosition));
//       } catch (error) {
//         emit(LocationError(error.toString()));
//       }
//     });

//     //* Attendance Data
//     on<LoadAttendanceData>((event, emit) async {
//       emit(AttendanceLoading()); // Ensure loading state is emitted

//       try {
//         final attendanceData = await _repository.getMemberAttendanceData(
//             userToken: event.userToken);
//         emit(AttendanceLoaded(attendanceData));
//       } catch (error) {
//         emit(AttendanceError(error.toString()));
//       }
//     });

// //* Check In
//     on<CheckIn>((event, emit) async {
//       try {
//         final response = await _repository.checkIn(
//           userToken: event.userToken,
//           groupMemberSID: event.groupMemberSID,
//           attendanceLocationSID: event.attendanceLocationSID,
//           longitude: event.longitude,
//           latitude: event.latitude,
//           attType: event.attType,
//           nextDay: event.nextDay,
//           dayDate: event.dayDate,
//         );

//         print(
//             'Response status code: ${response.statusCode}'); // Added for debugging

//         if (response.statusCode == 200) {
//           final notificationStatusResponse =
//               StatusResponseModel.fromJson(response.data);

//           print(
//               'Notification status type: ${notificationStatusResponse.type}'); // Added for debugging

//           if (notificationStatusResponse.type == 'success') {
//             emit(AttendanceCheckedInOutSuccess(
//                 statusResponseModel: notificationStatusResponse));
//           } else if (notificationStatusResponse.type == 'warning') {
//             emit(AttendanceCheckedInOutSuccessWarning(
//                 statusResponseModel: notificationStatusResponse));
//           } else if (notificationStatusResponse.type == 'error') {
//             emit(AttendanceCheckedInOutSuccessError(
//                 statusResponseModel: notificationStatusResponse));
//           }
//         } else if (response.statusCode == 404) {
//           print('Status code is 404'); // Added for debugging
//           print('Current state: $state'); // Added for debugging
//           emit(AttendanceCheckedInOutNotFound(error: 'NO Attendance '));
//         } else {
//           print(
//               'Unhandled status code: ${response.statusCode}'); // Added for debugging
//           emit(AttendanceCheckedInOutFailure(
//               'Status code: ${response.statusCode}'));
//         }

//         print('Final state after processing: $state'); // Added for debugging
//       } catch (error) {
//         print('Caught error: $error'); // Added for debugging
//         emit(AttendanceCheckedInOutFailure(error.toString()));
//       }
//     });

// //* Timer
//     on<StartTimer>(_onStartTimer);
//     on<Tick>(_onTick);
//     // on<CheckOut>((event, emit) async {
//     //   try {
//     //     final response = await _repository.checkOut(event.placeId);
//     //     // Handle successful check-out (e.g., update state)
//     //     emit(AttendanceCheckedOut(event.placeId));
//     //   } catch (error) {
//     //     emit(AttendanceError(error.toString()));
//     //   }
//     // });
//   }

//   late Ticker _ticker;
//   late StreamSubscription<int> _tickerSubscription;
//   int _duration = 0;

//   void _onStartTimer(StartTimer event, Emitter<AttendanceState> emit) {
//     _duration = event.duration;
//     _tickerSubscription?.cancel();
//     _ticker = Ticker();
//     _tickerSubscription = _ticker.tick().listen((elapsed) {
//       add(Tick(_duration - elapsed));
//     });
//     emit(TimerRunInProgress(_duration));
//   }

//   void _onTick(Tick event, Emitter<AttendanceState> emit) {
//     if (event.remainingDuration > 0) {
//       emit(TimerRunInProgress(event.remainingDuration));
//     } else {
//       _tickerSubscription?.cancel();
//       emit(TimerRunComplete());
//     }
//   }

//   @override
//   Future<void> close() {
//     _tickerSubscription?.cancel();
//     return super.close();
//   }
// }

// class Ticker {
//   Stream<int> tick() {
//     return Stream.periodic(Duration(seconds: 1), (x) => x + 1);
//   }
// }
