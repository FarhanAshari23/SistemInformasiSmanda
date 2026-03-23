import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/attandance/attendance_workbook.dart';
import '../../repository/attandance/attandance.dart';

class DownloadAttendanceTeachersUsecase
    implements Usecase<Either, AttendanceWorkBookEntity> {
  @override
  Future<Either> call({AttendanceWorkBookEntity? params}) async {
    return await sl<AttandanceRepository>().downloadAttendanceTeachers(params!);
  }
}
