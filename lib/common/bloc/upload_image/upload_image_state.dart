import 'dart:io';

abstract class UploadImageState {}

class UploadImageInitial extends UploadImageState {}

class UploadImageEmpty extends UploadImageState {}

class UploadImageLoading extends UploadImageState {}

class UploadImageNetwork extends UploadImageState {
  final String imageUrl;
  UploadImageNetwork(this.imageUrl);
}

class UploadImageSuccess extends UploadImageState {
  final File imageFile;
  UploadImageSuccess(this.imageFile);
}

class UploadImageFailure extends UploadImageState {
  final String message;
  UploadImageFailure(this.message);
}
