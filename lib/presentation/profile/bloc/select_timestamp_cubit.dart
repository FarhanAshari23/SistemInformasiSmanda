import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SelectTimestampCubit extends Cubit<Timestamp?> {
  SelectTimestampCubit() : super(null);

  void select(Timestamp time) {
    emit(time);
  }

  void reset() {
    emit(null);
  }
}
