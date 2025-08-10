import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/repository/news/news.dart';

import '../../../core/usecase/usecase.dart';
import '../../../service_locator.dart';

class CreateNewsUseCase implements Usecase<Either, NewsModel> {
  @override
  Future<Either> call({NewsModel? params}) async {
    return await sl<NewsRepository>().createNews(params!);
  }
}
