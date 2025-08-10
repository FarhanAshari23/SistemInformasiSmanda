import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

import '../../models/auth/update_user.dart';

abstract class StudentsFirebaseService {
  Future<Either> getStudent();
  Future<Either> getStudentsByClass(String kelas);
  Future<Either> getKelasSepuluh();
  Future<Either> getKelasSebelas();
  Future<Either> getKelasDuabelas();
  Future<Either> getClassSepuluhInit();
  Future<Either> getClassSebelasInit();
  Future<Either> getClassDuabelasInit();
  Future<Either> updateStudent(UpdateUserReq updateUserReq);
  Future<Either> deleteStudent(String nisnStudent);
  Future<Either> searchStudentByNISN(String nisnStudent);
  Future<Either> deleteStudentByClass(String kelas);
  Future<Either> getStudentsByname(String name);
}

class StudentsFirebaseServiceImpl extends StudentsFirebaseService {
  @override
  Future<Either> getStudentsByClass(String kelas) async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("kelas", isEqualTo: kelas)
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getStudent() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('Students')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please Try Again');
    }
  }

  @override
  Future<Either> updateStudent(updateUserReq) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('nisn', isEqualTo: updateUserReq.nisn).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "nama": updateUserReq.nama,
          "nisn": updateUserReq.nisn,
          "kelas": updateUserReq.kelas,
          "tanggal_lahir": updateUserReq.tanggalLahir,
          "No_HP": updateUserReq.noHp,
          "alamat": updateUserReq.alamat,
          "ekskul": updateUserReq.ekskul,
        });
        return right('Update Data Student Success');
      }
      return const Right('Update Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> deleteStudent(String nisnStudent) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('nisn', isEqualTo: nisnStudent).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> searchStudentByNISN(String nisnStudent) async {
    try {
      QuerySnapshot returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("nisn", isEqualTo: nisnStudent)
          .get();
      if (returnedData.docs.isNotEmpty) {
        return Right(returnedData.docs.first.data() as Map<String, dynamic>);
      }
      return const Left("Data cant be found");
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getStudentsByname(String name) async {
    try {
      String nameCapital = toBeginningOfSentenceCase(name);
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("nama", isGreaterThanOrEqualTo: nameCapital)
          .where('isAdmin', isEqualTo: false)
          .where('nama', isLessThan: '${nameCapital}z')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getKelasSepuluh() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Sepuluh').get();
      return Right(returnedData.docs);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getKelasDuabelas() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Duabelas').get();
      return Right(returnedData.docs);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getKelasSebelas() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Sebelas').get();
      return Right(returnedData.docs);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getClassDuabelasInit() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("kelas", isEqualTo: '12 1')
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getClassSebelasInit() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("kelas", isEqualTo: '11 1')
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> getClassSepuluhInit() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Students")
          .where("kelas", isEqualTo: '10 1')
          .orderBy('nama')
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error get data, please try again later");
    }
  }

  @override
  Future<Either> deleteStudentByClass(String kelas) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Students');
      QuerySnapshot querySnapshot =
          await users.where('kelas', isEqualTo: kelas).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Student Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }
}
