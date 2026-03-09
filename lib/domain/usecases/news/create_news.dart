import 'package:dartz/dartz.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';
import '../../entities/news/news.dart';
import '../../repository/news/news.dart';

class CreateNewsUseCase implements Usecase<Either, NewsEntity> {
  @override
  Future<Either> call({NewsEntity? params}) async {
    return await sl<NewsRepository>().createNews(params!);
  }
}
