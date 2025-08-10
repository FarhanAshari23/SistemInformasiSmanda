import 'package:flutter_bloc/flutter_bloc.dart';

import 'barcode_state.dart';

abstract class BarcodeEvent {}

class BarcodeScanStarted extends BarcodeEvent {}

class BarcodeScanned extends BarcodeEvent {
  final String barcode;
  BarcodeScanned(this.barcode);
}

class BarcodeScanFailed extends BarcodeEvent {
  final String error;
  BarcodeScanFailed(this.error);
}

class BarcodeBloc extends Bloc<BarcodeEvent, BarcodeState> {
  BarcodeBloc() : super(BarcodeScanInitial()) {
    on<BarcodeScanStarted>((event, emit) {
      emit(BarcodeScanLoading());
    });

    on<BarcodeScanned>((event, emit) {
      emit(BarcodeScanSuccess(event.barcode));
    });

    on<BarcodeScanFailed>((event, emit) {
      emit(BarcodeScanError(event.error));
    });
  }
}
