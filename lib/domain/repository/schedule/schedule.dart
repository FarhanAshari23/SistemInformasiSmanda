import 'package:dartz/dartz.dart';

abstract class ScheduleRepository {
  Future<Either> getJadwal();
  Future<Either> getAllJadwal();
}
