import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/attandance/attandance.dart';

class AddTeacherCompletionUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<AttandanceRepository>().addTeacherCompletion(params!);
  }
}
