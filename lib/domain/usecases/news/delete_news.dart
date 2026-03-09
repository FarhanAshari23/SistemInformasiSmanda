import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../repository/news/news.dart';

class DeleteNewsUsecase implements Usecase<Either, int> {
  @override
  Future<Either> call({int? params}) async {
    return await sl<NewsRepository>().deleteNews(params!);
  }
}
