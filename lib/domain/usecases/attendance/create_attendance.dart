import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/attandance/attandance.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CreateAttendanceUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AttandanceRepository>().createDate();
  }
}
