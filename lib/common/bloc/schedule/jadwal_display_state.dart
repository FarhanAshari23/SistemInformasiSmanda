import '../../../domain/entities/schedule/day.dart';

abstract class JadwalDisplayState {}

class JadwalDisplayLoading extends JadwalDisplayState {}

class JadwalDisplayLoaded extends JadwalDisplayState {
  final List<DayEntity> jadwals;

  JadwalDisplayLoaded({required this.jadwals});
}

class JadwalDisplayFailure extends JadwalDisplayState {}
