import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'upload_image_state.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitial());

  void loadNetworkImage(String url) {
    emit(UploadImageNetwork(url));
  }

  void loadInitialImage(String? url) async {
    if (url == null || url.isEmpty) {
      emit(UploadImageFailure("Tidak berhasil mendapatkan gambar"));
    }
    bool checkImage = await isUrlReachable(url!);
    if (checkImage) {
      emit(UploadImageNetwork(url));
    } else {
      emit(UploadImageEmpty());
    }
  }

  Future<void> pickImage(String filename) async {
    try {
      emit(UploadImageLoading());
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg'],
        allowMultiple: false,
      );

      if (result == null || result.files.single.path == null) {
        emit(UploadImageInitial());
        return;
      }

      final file = File(result.files.single.path!);
      final ext = p.extension(file.path).toLowerCase();

      if (ext != '.jpg' && ext != '.jpeg') {
        emit(UploadImageFailure("Hanya file JPG yang diperbolehkan"));
        return;
      }

      final File compressedFile = await compressImage(file);
      final customName = "$filename$ext";
      final appDir = await getApplicationDocumentsDirectory();
      final savePath = p.join(appDir.path, customName);
      final savedFile = await compressedFile.copy(savePath);
      emit(UploadImageSuccess(savedFile));
    } catch (e) {
      emit(UploadImageFailure("Gagal memproses gambar: $e"));
    }
  }

  Future<bool> isUrlReachable(String url) async {
    try {
      final uri = Uri.parse(url);

      final request = await HttpClient().headUrl(uri);
      final response = await request.close();

      return response.statusCode >= 200 && response.statusCode < 400;
    } catch (e) {
      return false;
    }
  }

  Future<File> compressImage(File file) async {
    final dir = await getTemporaryDirectory();

    final targetPath = p.join(
      dir.path,
      '${DateTime.now().millisecondsSinceEpoch}.jpg',
    );

    final compressed = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 75,
      minWidth: 1024,
      minHeight: 1024,
      format: CompressFormat.jpeg,
    );

    if (compressed == null) {
      throw Exception('Gagal kompres gambar');
    }

    return File(compressed.path);
  }
}
