import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/news/get_news.dart';
import 'package:new_sistem_informasi_smanda/domain/usecases/news/get_news_by_class.dart';
import 'package:new_sistem_informasi_smanda/presentation/news/bloc/news_state.dart';

import '../../../domain/usecases/news/get_news_global_usecase.dart';
import '../../../service_locator.dart';

class NewsCubit extends Cubit<NewsState> {
  NewsCubit() : super(NewsLoading());

  void displayNews() async {
    emit(NewsLoading());
    var returnedData = await sl<GetNewsUseCase>().call();
    returnedData.fold(
      (error) {
        return emit(NewsFailure(errorMessage: error));
      },
      (data) {
        return emit(NewsLoaded(news: data));
      },
    );
  }

  void displayNewsGlobal() async {
    emit(NewsLoading());
    var returnedData = await sl<GetNewsGlobalUsecase>().call();
    returnedData.fold(
      (error) {
        return emit(NewsFailure(errorMessage: error));
      },
      (data) {
        return emit(NewsLoaded(news: data));
      },
    );
  }

  void displayNewsByClass(int classId) async {
    emit(NewsLoading());
    var returnedData = await sl<GetNewsByClassUsecase>().call(params: classId);
    returnedData.fold(
      (error) {
        return emit(NewsFailure(errorMessage: error));
      },
      (data) {
        return emit(NewsLoaded(news: data));
      },
    );
  }
}
