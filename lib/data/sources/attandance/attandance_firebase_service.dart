import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../domain/entities/attandance/param_delete_attendance.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../models/auth/user.dart';
import '../../models/teacher/teacher.dart';

abstract class AttandanceFirebaseService {
  Future<Either> getListAttendanceDate();
  Future<Either> deleteAllAttendances();
  Future<Either> deleteMonthAttendances(ParamDeleteAttendance attendanceReq);
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
  Future<Either> addTeacherAttendances(TeacherEntity teacherAddReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
  Future<Either> addTeacherCompletion(TeacherEntity teacherAddReq);
}

class AttandanceFirebaseServiceImpl extends AttandanceFirebaseService {
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
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference kehadiran =
          firebaseFirestore.collection('Attendances');
      DateTime sekarang = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(sekarang);
      QuerySnapshot snapshot =
          await kehadiran.where('createdAt', isEqualTo: formattedDate).get();
      DocumentReference kehadiranDoc;
      if (snapshot.docs.isEmpty) {
        kehadiranDoc = await kehadiran.add(
          {
            "createdAt": formattedDate,
            "timestamp": Timestamp.now(),
          },
        );
      } else {
        kehadiranDoc = snapshot.docs.first.reference;
      }
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

  @override
  Future<Either> deleteAllAttendances() async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Attendances');

    try {
      QuerySnapshot snapshot = await collection.get();
      if (snapshot.docs.isEmpty) {
        return const Left(
          "Maaf, anda belum merekam absen sama sekali",
        );
      }
      for (var doc in snapshot.docs) {
        final studentsRef = doc.reference.collection('Students');
        final studentsSnapshot = await studentsRef.get();

        int counter = 0;
        WriteBatch batch = firestore.batch();
        for (var studentDoc in studentsSnapshot.docs) {
          batch.delete(studentDoc.reference);
          counter++;

          if (counter == 500) {
            await batch.commit();
            batch = firestore.batch();
            counter = 0;
          }
        }
        if (counter > 0) {
          await batch.commit();
        }
        await doc.reference.delete();
        snapshot = await collection.get();
      }
      return const Right('Semua data kehadiran telah dihapus');
    } catch (e) {
      return Left('Something wrong: $e');
    }
  }

  @override
  Future<Either> deleteMonthAttendances(
      ParamDeleteAttendance attendanceReq) async {
    final firestore = FirebaseFirestore.instance;
    final collection = firestore.collection('Attendances');

    final firstDay = DateTime(attendanceReq.year, attendanceReq.month, 1);
    final lastDay =
        DateTime(attendanceReq.year, attendanceReq.month + 1, 0, 23, 59, 59);
    try {
      final snapshot = await collection
          .where('timestamp',
              isGreaterThanOrEqualTo: Timestamp.fromDate(firstDay))
          .where('timestamp', isLessThanOrEqualTo: Timestamp.fromDate(lastDay))
          .get();
      if (snapshot.docs.isEmpty) {
        return Left(
          "Maaf, anda belum merekam absen di bulan ${attendanceReq.month}",
        );
      }

      for (var doc in snapshot.docs) {
        final studentsRef = doc.reference.collection('Students');
        final studentsSnapshot = await studentsRef.get();

        int counter = 0;
        WriteBatch batch = firestore.batch();
        for (var studentDoc in studentsSnapshot.docs) {
          batch.delete(studentDoc.reference);
          counter++;

          if (counter == 500) {
            await batch.commit();
            batch = firestore.batch();
            counter = 0;
          }
        }
        if (counter > 0) {
          await batch.commit();
        }
        await doc.reference.delete();
      }

      return Right(
          'Berhasil menghapus data sebanyak ${snapshot.docs.length} untuk bulan ${attendanceReq.month}');
    } catch (e) {
      return Left("Something error: $e");
    }
  }

  @override
  Future<Either> addTeacherAttendances(teacherAddReq) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference kehadiran =
          firebaseFirestore.collection('TeachersAttendances');
      DateTime sekarang = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(sekarang);
      QuerySnapshot snapshot =
          await kehadiran.where('createdAt', isEqualTo: formattedDate).get();
      DocumentReference kehadiranDoc;
      if (snapshot.docs.isEmpty) {
        kehadiranDoc = await kehadiran.add(
          {
            "createdAt": formattedDate,
            "timestamp": Timestamp.now(),
          },
        );
      } else {
        kehadiranDoc = snapshot.docs.first.reference;
      }
      CollectionReference teacher = kehadiranDoc.collection('Teachers');
      QuerySnapshot existingTeacher = await teacher
          .where(teacherAddReq.nip != '-' ? "NIP" : "nama",
              isEqualTo: teacherAddReq.nip != '-'
                  ? teacherAddReq.nip
                  : teacherAddReq.nama)
          .limit(1)
          .get();
      if (existingTeacher.docs.isNotEmpty) {
        return const Left(
          'Kehadiran anda sudah disimpan, silakan absen keesokan harinya',
        );
      }
      final teacherModel = TeacherModelX.fromEntity(teacherAddReq);
      final teacherData = teacherModel.toMap();

      // Tambahkan jam masuk sekarang
      teacherData['jam_masuk'] = Timestamp.now();

      await teacher.add(teacherData);

      return right('Attendance record success!');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> addTeacherCompletion(TeacherEntity teacherAddReq) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      CollectionReference kehadiran =
          firebaseFirestore.collection('TeachersCompletions');
      DateTime sekarang = DateTime.now();
      String formattedDate = DateFormat('dd-MM-yyyy').format(sekarang);
      QuerySnapshot snapshot =
          await kehadiran.where('createdAt', isEqualTo: formattedDate).get();
      DocumentReference kehadiranDoc;
      if (snapshot.docs.isEmpty) {
        kehadiranDoc = await kehadiran.add(
          {
            "createdAt": formattedDate,
            "timestamp": Timestamp.now(),
          },
        );
      } else {
        kehadiranDoc = snapshot.docs.first.reference;
      }
      CollectionReference teacher = kehadiranDoc.collection('Teachers');
      QuerySnapshot existingTeacher = await teacher
          .where(teacherAddReq.nip != '-' ? "NIP" : "nama",
              isEqualTo: teacherAddReq.nip != '-'
                  ? teacherAddReq.nip
                  : teacherAddReq.nama)
          .limit(1)
          .get();
      if (existingTeacher.docs.isNotEmpty) {
        return const Left(
          'Kehadiran anda sudah disimpan, silakan absen keesokan harinya',
        );
      }
      final teacherModel = TeacherModelX.fromEntity(teacherAddReq);
      final teacherData = teacherModel.toMap();

      // Tambahkan jam masuk sekarang
      teacherData['jam_pulang'] = Timestamp.now();

      await teacher.add(teacherData);

      return right('Attendance record success!');
    } catch (e) {
      return left(e.toString());
    }
  }
}
