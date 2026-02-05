import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/attandance/param_attendance_teacher.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/auth/user.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../domain/entities/attandance/param_attendance.dart';
import '../../../domain/entities/attandance/param_delete_attendance.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../models/auth/user.dart';
import '../../models/teacher/teacher.dart';

abstract class AttandanceFirebaseService {
  Future<Either> getListStudentAttendancesDate();
  Future<Either> getListTeacherAttendancesDate();
  Future<Either> getListTeacherCompletionsDate();
  Future<Either> deleteAllAttendances();
  Future<Either> deleteMonthAttendances(ParamDeleteAttendance attendanceReq);
  Future<Either> getAttendanceStudents(ParamAttendanceEntity attendanceReq);
  Future<Either> getAttendanceStudent(UserEntity attendanceReq);
  Future<Either> addStudentAttendances(UserEntity userAddReq);
  Future<Either> getAttendanceTeacher(TeacherEntity attendanceReq);
  Future<Either> getAttendanceAllTeacher(ParamAttendanceTeacher req);
  Future<Either> addTeacherAttendances(TeacherEntity teacherAddReq);
  Future<Either> searchStudentAttendance(ParamAttendanceEntity attendanceReq);
  Future<Either> downloadAttendanceTeachers(ParamAttendanceTeacher req);
}

class AttandanceFirebaseServiceImpl extends AttandanceFirebaseService {
  @override
  Future<Either> getListStudentAttendancesDate() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Attendances")
          .where("is_student", isEqualTo: true)
          .orderBy('timestamp', descending: true)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getListTeacherAttendancesDate() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Attendances")
          .where("is_student", isEqualTo: false)
          .where('is_teacher_completions', isEqualTo: false)
          .orderBy('timestamp', descending: true)
          .get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getListTeacherCompletionsDate() async {
    try {
      var returnedData = await FirebaseFirestore.instance
          .collection("Attendances")
          .where("is_student", isEqualTo: false)
          .where('is_teacher_completions', isEqualTo: true)
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
      final studentQuery = await firebaseFirestore
          .collection('Students')
          .where(
            'nisn',
            isEqualTo: userAddReq.nisn,
          )
          .limit(1)
          .get();

      if (studentQuery.docs.isEmpty) {
        return const Left("Data siswa tidak ditemukan");
      }

      final studentDoc = studentQuery.docs.first.reference;

      final attendanceRef = studentDoc.collection('Attendances');
      final todayAttendance = await attendanceRef.doc(formattedDate).get();

      if (todayAttendance.exists) {
        return const Left(
          'Kehadiran anda sudah disimpan, silakan absen keesokan harinya',
        );
      }

      final attendanceData = {
        "createdAt": formattedDate,
        "timestamp": Timestamp.now(),
        'is_student': true,
        'is_teacher_completions': false
      };

      await attendanceRef.doc(formattedDate).set(attendanceData);
      QuerySnapshot snapshot =
          await kehadiran.where('createdAt', isEqualTo: formattedDate).get();
      DocumentReference kehadiranDoc;
      if (snapshot.docs.isEmpty) {
        kehadiranDoc = await kehadiran.add(
          {
            "createdAt": formattedDate,
            "timestamp": Timestamp.now(),
            'is_student': true,
            'is_teacher_completions': false
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
          .where('is_student', isEqualTo: true)
          .where('is_teacher_completions', isEqualTo: false)
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
          .where('is_student', isEqualTo: true)
          .where('is_teacher_completions', isEqualTo: false)
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
    final collection = firestore
        .collection('Attendances')
        .where('is_student', isEqualTo: true)
        .where('is_teacher_completions', isEqualTo: false);

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
    final collection = firestore
        .collection('Attendances')
        .where('is_student', isEqualTo: true)
        .where('is_teacher_completions', isEqualTo: false);

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
      final firestore = FirebaseFirestore.instance;
      final now = DateTime.now();
      final formattedDate = DateFormat('dd-MM-yyyy').format(now);

      final teacherQuery = await firestore
          .collection('Teachers')
          .where(
            teacherAddReq.nip != '-' ? 'NIP' : 'nama',
            isEqualTo: teacherAddReq.nip != '-'
                ? teacherAddReq.nip
                : teacherAddReq.nama,
          )
          .limit(1)
          .get();

      if (teacherQuery.docs.isEmpty) {
        return const Left("Data guru tidak ditemukan");
      }

      final teacherDoc = teacherQuery.docs.first.reference;

      final attendanceRef = teacherDoc.collection(
          teacherAddReq.isAttendance ?? false ? 'Attendances' : 'Completions');
      final todayAttendance = await attendanceRef.doc(formattedDate).get();

      if (todayAttendance.exists) {
        return const Left(
          'Kehadiran anda sudah disimpan, silakan absen keesokan harinya',
        );
      }

      final attendanceData = {
        "createdAt": formattedDate,
        "timestamp": Timestamp.now(),
      };

      await attendanceRef.doc(formattedDate).set(attendanceData);

      final teacherAttendances = firestore.collection("Attendances");

      final dateQuery = await teacherAttendances
          .where("createdAt", isEqualTo: formattedDate)
          .where('is_student', isEqualTo: false)
          .where('is_teacher_completions',
              isEqualTo: teacherAddReq.isAttendance ?? false ? false : true)
          .limit(1)
          .get();

      late final DocumentReference todayDoc;

      if (dateQuery.docs.isEmpty) {
        todayDoc = await teacherAttendances.add({
          "createdAt": formattedDate,
          "timestamp": Timestamp.now(),
          'is_student': false,
          'is_teacher_completions':
              teacherAddReq.isAttendance ?? false ? false : true
        });
      } else {
        todayDoc = dateQuery.docs.first.reference;
      }

      final teacherModel = TeacherModelX.fromEntity(teacherAddReq);
      final teacherData = teacherModel.toMap();
      teacherData[teacherAddReq.isAttendance ?? false
          ? 'jam_masuk'
          : 'jam_pulang'] = Timestamp.now();
      await todayDoc.collection("Teachers").add(teacherData);

      return right('Attendance record success!');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getAttendanceTeacher(TeacherEntity attendanceReq) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference kehadiran = firebaseFirestore.collection('Teachers');
    try {
      final attendanceQuery = await kehadiran
          .where(
            attendanceReq.nip != '-' ? 'NIP' : 'nama',
            isEqualTo: attendanceReq.nip != '-'
                ? attendanceReq.nip
                : attendanceReq.nama,
          )
          .limit(1)
          .get();
      if (attendanceQuery.docs.isEmpty) {
        return const Left("Data guru tidak ditemukan");
      }

      final attendanceDocId = attendanceQuery.docs.first.id;
      final teacherDoc = await kehadiran
          .doc(attendanceDocId)
          .collection(attendanceReq.isAttendance ?? false
              ? 'Attendances'
              : 'Completions')
          .orderBy("timestamp", descending: false)
          .get();
      if (teacherDoc.docs.isEmpty) {
        return const Left("Data kehadiran anda sudah dihapus");
      }
      return Right(teacherDoc.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAttendanceAllTeacher(ParamAttendanceTeacher req) async {
    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection("Attendances");
      QuerySnapshot snapshot = await kehadiran
          .where('createdAt', isEqualTo: req.date)
          .where('is_student', isEqualTo: false)
          .where('is_teacher_completions', isEqualTo: req.isAttendance)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String attendanceId = snapshot.docs.first.id;
        QuerySnapshot teachers =
            await kehadiran.doc(attendanceId).collection('Teachers').get();
        return Right(teachers.docs.map((e) => e.data()).toList());
      } else {
        return left('Date cant be found');
      }
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getAttendanceStudent(UserEntity attendanceReq) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    CollectionReference kehadiran = firebaseFirestore.collection('Students');
    try {
      final attendanceQuery = await kehadiran
          .where(
            'nisn',
            isEqualTo: attendanceReq.nisn,
          )
          .limit(1)
          .get();
      if (attendanceQuery.docs.isEmpty) {
        return const Left("Data murid tidak ditemukan");
      }

      final attendanceDocId = attendanceQuery.docs.first.id;
      final studentDoc = await kehadiran
          .doc(attendanceDocId)
          .collection('Attendances')
          .orderBy("timestamp", descending: false)
          .get();
      if (studentDoc.docs.isEmpty) {
        return const Left("Data kehadiran anda sudah dihapus");
      }
      return Right(studentDoc.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> downloadAttendanceTeachers(ParamAttendanceTeacher req) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    try {
      CollectionReference kehadiran =
          FirebaseFirestore.instance.collection("Attendances");
      QuerySnapshot snapshot = await kehadiran
          .where('createdAt', isEqualTo: req.date)
          .where('is_student', isEqualTo: false)
          .where('is_teacher_completions', isEqualTo: !req.isAttendance)
          .get();
      if (snapshot.docs.isNotEmpty) {
        String attendanceId = snapshot.docs.first.id;
        var teachers =
            await kehadiran.doc(attendanceId).collection('Teachers').get();
        List<Map<String, dynamic>> teacher =
            teachers.docs.map((e) => e.data()).toList();

        sheet.getRangeByName('A1').setText('No');
        sheet.getRangeByName('B1').setText('Nama');
        sheet
            .getRangeByName('C1')
            .setText('Jam ${req.isAttendance ? "Masuk" : "Pulang"}');

        final headerStyle = workbook.styles.add('HeaderStyle');
        headerStyle.bold = true;
        headerStyle.backColor = '#E0E0E0';
        sheet.getRangeByName('A1:C1').cellStyle = headerStyle;

        for (var i = 0; i < teacher.length; i++) {
          Timestamp? timestamp;

          if (req.isAttendance) {
            timestamp = teacher[i]['jam_masuk'];
          } else {
            timestamp = teacher[i]['jam_pulang'];
          }

          String formattedDate = '-';

          if (timestamp != null) {
            DateTime dateTime = timestamp.toDate();
            formattedDate = DateFormat(
              'd MMMM yyyy HH:mm',
              'id_ID',
            ).format(dateTime);
          }
          sheet.getRangeByName('A${i + 2}').setText("${i + 1}");
          sheet.getRangeByName('B${i + 2}').setText(teacher[i]['nama']);
          sheet.getRangeByName('C${i + 2}').setText(formattedDate);
        }

        sheet.autoFitColumn(1);
        sheet.autoFitColumn(2);
        sheet.autoFitColumn(3);

        final List<int> bytes = workbook.saveAsStream();
        workbook.dispose();

        final String? selectedDirectory =
            await FilePicker.platform.getDirectoryPath(
          dialogTitle: 'Pilih folder untuk menyimpan Excel',
        );

        if (selectedDirectory == null) {
          return const Left("Pilihi directory dulu");
        }

        final String filePath =
            '$selectedDirectory/data_${req.isAttendance ? "kehadiran" : "pulang"}_guru${req.date}.xlsx';

        final File file = File(filePath);
        await file.writeAsBytes(bytes, flush: true);
        return Right("Data excel berhasil di simpan di: $filePath");
      } else {
        return left('Date cant be found');
      }
    } catch (e) {
      print(e.toString());
      return left(e.toString());
    }
  }
}
