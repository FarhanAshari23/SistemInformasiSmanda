import 'package:new_sistem_informasi_smanda/domain/entities/schedule/schedule.dart';

abstract class GetAllJadwalState {}

class GetAllJadwalLoading extends GetAllJadwalState {}

class GetAllJadwalLoaded extends GetAllJadwalState {
  final List<ScheduleEntity> jadwals;

  GetAllJadwalLoaded({required this.jadwals});
}

class GetAllJadwalFailure extends GetAllJadwalState {}
