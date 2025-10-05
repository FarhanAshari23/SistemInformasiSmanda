import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../common/helper/generate_keyword.dart';
import '../../../domain/entities/auth/teacher.dart';
import '../../models/teacher/teacher.dart';

abstract class TeacherFirebaseService {
  Future<Either> createTeacher(TeacherModel teacherCreationReq);
  Future<Either> getKepalaSekolah();
  Future<Either> getWaka();
  Future<Either> getTeacher();
  Future<Either> getTeacherByName(String name);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(String nipTeacher);
  Future<Either> getHonor();
}

class TeacherFirebaseServiceImpl extends TeacherFirebaseService {
  @override
  Future<Either> getKepalaSekolah() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("jabatan_tambahan", isEqualTo: 'Kepala Sekolah')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getWaka() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("jabatan_tambahan",
              isGreaterThanOrEqualTo: 'Wakil Kepala Sekolah')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getTeacher() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where('mengajar', isNotEqualTo: 'Tenaga Kependidikan')
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> createTeacher(TeacherModel teacherCreationReq) async {
    try {
      final keywords = generateKeywords(teacherCreationReq.nama);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Teachers").add(
        {
          "nama": teacherCreationReq.nama,
          "NIP": teacherCreationReq.nip,
          "mengajar": teacherCreationReq.mengajar,
          "tanggal_lahir": teacherCreationReq.tanggalLahir,
          "wali_kelas": teacherCreationReq.waliKelas,
          "jabatan_tambahan": teacherCreationReq.jabatan,
          "gender": teacherCreationReq.gender,
          "keywords": keywords,
        },
      );
      return const Right("Upload Teacher was succesfull");
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> deleteTeacher(String nipTeacher) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Teachers');
      QuerySnapshot querySnapshot =
          await users.where('NIP', isEqualTo: nipTeacher).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Teacher Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> updateTeacher(TeacherEntity teacherReq) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Teachers');
      QuerySnapshot querySnapshot =
          await users.where('NIP', isEqualTo: teacherReq.nip).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "NIP": teacherReq.nip,
          "jabatan_tambahan": teacherReq.jabatan,
          "mengajar": teacherReq.mengajar,
          "tanggal_lahir": teacherReq.tanggalLahir,
          "nama": teacherReq.nama,
          "wali_kelas": teacherReq.waliKelas,
        });
        return right('Update Data Teacher Success');
      }
      return const Right('Update Data Teacher Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> getTeacherByName(String name) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("keywords", arrayContains: name)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getHonor() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Teachers")
          .where("mengajar", isEqualTo: 'Tenaga Kependidikan')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }
}
