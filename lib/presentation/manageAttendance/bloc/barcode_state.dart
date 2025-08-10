abstract class BarcodeState {}

class BarcodeScanInitial extends BarcodeState {}

class BarcodeScanLoading extends BarcodeState {}

class BarcodeScanSuccess extends BarcodeState {
  final String barcode;
  BarcodeScanSuccess(this.barcode);
}

class BarcodeScanError extends BarcodeState {
  final String error;
  BarcodeScanError(this.error);
}
