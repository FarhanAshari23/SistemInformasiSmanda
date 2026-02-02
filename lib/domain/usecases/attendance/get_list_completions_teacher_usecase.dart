import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/attandance/attandance.dart';

class GetListTeacherCompletionsUseCase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<AttandanceRepository>().getListTeacherCompletionsDate();
  }
}
