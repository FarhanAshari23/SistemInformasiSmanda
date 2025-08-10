import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/news/news.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class UpdateNewsUsecase implements Usecase<Either, NewsEntity> {
  @override
  Future<Either> call({NewsEntity? params}) async {
    return await sl<NewsRepository>().updateNews(params!);
  }
}
