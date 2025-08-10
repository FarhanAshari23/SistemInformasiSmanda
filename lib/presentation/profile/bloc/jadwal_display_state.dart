import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';

abstract class JadwalDisplayState {}

class JadwalDisplayLoading extends JadwalDisplayState {}

class JadwalDisplayLoaded extends JadwalDisplayState {
  final List<ScheduleEntity> jadwals;

  JadwalDisplayLoaded({required this.jadwals});
}

class JadwalDisplayFailure extends JadwalDisplayState {}
