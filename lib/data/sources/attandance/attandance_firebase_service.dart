import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../models/auth/user.dart';

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
      String formattedDate = DateFormat('dd-MM-yyyy').format(sekarang);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Attendances").add(
        {
          "createdAt": formattedDate,
          "timestamp": Timestamp.now(),
        },
      );
      return const Right("Upload Attendance was succesfull");
    } catch (e) {
      return Left(e);
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
      return left(e.toString());
    }
  }

  @override
  Future<Either> addStudentAttendances(UserEntity userAddReq) async {
    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection('Attendances');
      DateTime sekarang = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(sekarang);
      QuerySnapshot snapshot =
          await kehadiran.where('createdAt', isEqualTo: formattedDate).get();
      if (snapshot.docs.isEmpty) {
        return const Left("Date cant be found");
      }
      DocumentReference kehadiranDoc = snapshot.docs.first.reference;
      CollectionReference murid = kehadiranDoc.collection('Students');
      QuerySnapshot existingStudent =
          await murid.where("nisn", isEqualTo: userAddReq.nisn).limit(1).get();
      if (existingStudent.docs.isNotEmpty) {
        final data = existingStudent.docs.first.data() as Map<String, dynamic>;
        final nama = data['nama'] ?? 'Unknown';
        return Left(
          'Kehadiran $nama sudahh disimpan, silakan scan NISN murid lain',
        );
      }
      final userModel = UserModelX.fromEntity(userAddReq);
      final userData = userModel.toMap();

      // Tambahkan jam masuk sekarang
      userData['jam_masuk'] = Timestamp.now();

      await murid.add(userData);

      return right('Attendance record success!');
    } catch (e) {
      return left(e.toString());
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
        QuerySnapshot studentsQuery = await studentsRef
            .where("isAdmin", isEqualTo: false)
            .where("keywords", arrayContains: attendanceReq.name)
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
