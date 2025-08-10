import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../domain/entities/attandance/param_attendance.dart';

abstract class AttandanceFirebaseService {
  Future<Either> createDate();
  Future<Either> getListAttendanceDate();
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
}

class AttandanceFirebaseServiceImpl extends AttandanceFirebaseService {
  @override
  Future<Either> createDate() async {
    try {
      DateTime sekarang = DateTime.now();
      int tanggal = sekarang.day;
      int bulan = sekarang.month;
      int tahun = sekarang.year;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Attendances").add(
        {
          "createdAt": '$tanggal-$bulan-$tahun',
          "timestamp": Timestamp.now(),
        },
      );
      return const Right("Upload Attendance was succesfull");
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> addStudentAttendances(userAddReq) async {
    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection('Attendances');
      DateTime sekarang = DateTime.now();
      int tanggal = sekarang.day;
      int bulan = sekarang.month;
      int tahun = sekarang.year;
      QuerySnapshot snapshot = await kehadiran
          .where('createdAt', isEqualTo: '$tanggal-$bulan-$tahun')
          .get();
      if (snapshot.docs.isNotEmpty) {
        DocumentReference kehadiranDoc = snapshot.docs[0].reference;
        CollectionReference murid = kehadiranDoc.collection('Students');

        await murid.add({
          'nama': userAddReq.nama,
          'kelas': userAddReq.kelas,
          'nisn': userAddReq.nisn,
          'tanggal_lahir': userAddReq.tanggalLahir,
          'No_HP': userAddReq.noHP,
          'alamat': userAddReq.alamat,
          'ekskul': userAddReq.ekskul,
          'jam_masuk': Timestamp.now(),
        });

        return right('Attendance record success!');
      } else {
        return left('Date cant be found');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getListAttendanceDate() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection('Attendances')
          .orderBy('timestamp', descending: true)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return const Left("Error, please try again");
    }
  }

  @override
  Future<Either> getAttendanceStudents(
      ParamAttendanceEntity attendanceReq) async {
    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection('Attendances');
      QuerySnapshot snapshot = await kehadiran
          .where('createdAt', isEqualTo: attendanceReq.date)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String attendanceId = snapshot.docs.first.id;
        CollectionReference studentsRef =
            kehadiran.doc(attendanceId).collection('Students');
        QuerySnapshot studentsQuery = await studentsRef
            .where('kelas', isEqualTo: attendanceReq.kelas)
            .get();
        return Right(studentsQuery.docs.map((e) => e.data()).toList());
      } else {
        return left('Date cant be found');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> searchStudentAttendance(
      ParamAttendanceEntity attendanceReq) async {
    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection('Attendances');
      QuerySnapshot snapshot = await kehadiran
          .where('createdAt', isEqualTo: attendanceReq.date)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String attendanceId = snapshot.docs.first.id;
        CollectionReference studentsRef =
            kehadiran.doc(attendanceId).collection('Students');
        String nameCapital = toBeginningOfSentenceCase(attendanceReq.name!);
        QuerySnapshot studentsQuery = await studentsRef
            .where('nama', isGreaterThanOrEqualTo: nameCapital)
            .where('nama', isLessThan: '${nameCapital}z')
            .get();
        return Right(studentsQuery.docs.map((e) => e.data()).toList());
      } else {
        return left('Date cant be found');
      }
    } catch (e) {
      return left(e.toString());
    }
  }
}
