import '../../core/constants/app_url.dart';

class ExecuteCRUD {
  static String uploadImageStudent() {
    return '${AppUrl.mainRoute}/upload-image-students';
  }

  static String updateImageStudent() {
    return '${AppUrl.mainRoute}/update-image-students';
  }

  static String deleteImageStudent() {
    return '${AppUrl.mainRoute}/delete-image-student';
  }

  static String deleteMultipleImageStudent() {
    return '${AppUrl.mainRoute}/delete-multiple-students';
  }

  static String uploadImageTeacher() {
    return '${AppUrl.mainRoute}/upload-image-teachers';
  }

  static String deleteImageTeacher() {
    return '${AppUrl.mainRoute}/delete-image-teachers';
  }

  static String updateImageTeacher() {
    return '${AppUrl.mainRoute}/update-image-teachers';
  }
}
