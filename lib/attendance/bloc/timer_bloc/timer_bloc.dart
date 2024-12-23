// import 'package:bloc/bloc.dart';
// import 'dart:async';
// import 'timer_event.dart';
// import 'timer_state.dart';

// class TimerBloc extends Bloc<TimerEvent, TimerState> {
//   TimerBloc() : super(TimerInitial()) {
//     on<StartTimer>(_onStartTimer);
//     on<Tick>(_onTick);
//   }

//   late Ticker _ticker;
//   late StreamSubscription<int> _tickerSubscription;
//   int _duration = 0;

//   void _onStartTimer(StartTimer event, Emitter<TimerState> emit) {
//     _duration = event.duration;
//     _tickerSubscription?.cancel();
//     _ticker = Ticker();
//     _tickerSubscription = _ticker.tick().listen((elapsed) {
//       add(Tick(elapsed));
//     });
//     emit(TimerRunInProgress(_duration));
//   }

//   void _onTick(Tick event, Emitter<TimerState> emit) {
//     final int remaining = _duration - event.elapsed;
//     if (remaining > 0) {
//       emit(TimerRunInProgress(remaining));
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
