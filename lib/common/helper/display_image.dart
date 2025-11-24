import 'package:new_sistem_informasi_smanda/core/constants/app_url.dart';

class DisplayImage {
  static String displayImageStudent(String name, String nisn) {
    return '${AppUrl.storageStudent}/${name}_$nisn.jpg';
  }

  static String displayImageTeacher(String name, String nip) {
    return '${AppUrl.storageTeacher}/${name}_$nip.jpg';
  }

  static String displayImageStaff(String name) {
    return '${AppUrl.storageStudent}/$name.jpg';
  }

  // static String displayImageEkskul(String name) {
  //   return '${AppUrl.storageEkskul}/$name.jpg';
  // }

  // static String displayImageMemberEkskul(
  //     String name, String ekskul, String jabatan) {
  //   return '${AppUrl.storageEkskul}/$ekskul$name$jabatan.jpg';
  // }
}
