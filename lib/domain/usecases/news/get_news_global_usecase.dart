import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/news/news.dart';

class GetNewsGlobalUsecase implements Usecase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return await sl<NewsRepository>().getNewsGlobal();
  }
}
