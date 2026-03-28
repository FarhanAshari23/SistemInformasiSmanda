import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import '../../../core/networks/network.dart';
import '../../../domain/entities/attandance/attandance_teacher.dart';
import '../../../domain/entities/attandance/attendance_student.dart';
import '../../../domain/entities/attandance/attendance_workbook.dart';
import '../../models/attendance/attendance_student.dart';
import '../../models/attendance/attendance_teacher.dart';

abstract class AttandanceFirebaseService {
  Future<Either> addStudentAttendances(AttendanceStudentEntity student);
  Future<Either> getListStudentAttendancesDate();
  Future<Either> getListTeacherAttendancesDate();
  Future<Either> getListTeacherCompletionsDate();
  Future<Either> getAttendanceStudents(AttendanceStudentEntity req);
  Future<Either> getAttendanceStudent(int studentId);
  Future<Either> getAttendanceTeacher(int teacherId);
  Future<Either> getAttendanceTeacherCurrent(int teacherId);
  Future<Either> getAttendanceAllTeacher(AttandanceTeacherEntity req);
  Future<Either> addTeacherAttendances(AttandanceTeacherEntity teacher);
  Future<Either> addTeacherCompletion(int teacherId);
  Future<Either> searchStudentAttendance(AttendanceStudentEntity req);
  Future<Either> downloadAttendanceTeachers(AttendanceWorkBookEntity req);
}

class AttandanceFirebaseServiceImpl extends AttandanceFirebaseService {
  @override
  Future<Either> addTeacherAttendances(AttandanceTeacherEntity teacher) async {
    try {
      final model = AttendanceTeacherModelX.fromEntity(teacher);
      final response = await Network.apiClient.post(
        "/attendanceteacher",
        body: model.createReq(),
      );

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      return const Right("Rekam Kehadiran Berhasil");
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> addStudentAttendances(AttendanceStudentEntity student) async {
    try {
      final model = AttendanceStudentModelX.fromEntity(student);
      final response = await Network.apiClient.post(
        "/attendancestudent",
        body: model.createReq(),
      );

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      return const Right("Rekam Kehadiran Berhasil");
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getListTeacherAttendancesDate() async {
    try {
      final response = await Network.apiClient.get("/attendanceteachers");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getListTeacherCompletionsDate() async {
    try {
      final response = await Network.apiClient.get("/completionteachers");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getListStudentAttendancesDate() async {
    try {
      final response = await Network.apiClient.get("/attendancestudents");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAttendanceStudents(AttendanceStudentEntity req) async {
    try {
      final response = await Network.apiClient.get(
          "/attendancestudent/date/${req.date}/className/${req.className}");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAttendanceAllTeacher(AttandanceTeacherEntity req) async {
    try {
      final response =
          await Network.apiClient.get("/attendanceteacher/date/${req.date}");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAttendanceTeacher(int teacherId) async {
    try {
      final response = await Network.apiClient
          .get("/attendanceteacher/teacherid/$teacherId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getAttendanceStudent(int studentId) async {
    try {
      final response = await Network.apiClient
          .get("/attendancestudent/studentId/$studentId");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as Map<String, dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> searchStudentAttendance(AttendanceStudentEntity req) async {
    try {
      final response = await Network.apiClient.get(
          "/attendancestudent/${req.date}/:studentAttendanceDate/name/${req.name}");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final dataList = response.data['data'] as List<dynamic>;
      return Right(dataList);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> downloadAttendanceTeachers(
      AttendanceWorkBookEntity req) async {
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    try {
      final response =
          await Network.apiClient.get("/attendanceteacher/date/${req.date}");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      List<AttandanceTeacherEntity> teachers = List.from(response.data['data'])
          .map((e) => AttendanceTeacherModel.fromMap(e).toEntity())
          .toList();
      sheet.getRangeByName('A1').setText('No');
      sheet.getRangeByName('B1').setText('Nama');
      sheet.getRangeByName('C1').setText('Jam Masuk');

      final headerStyle = workbook.styles.add('HeaderStyle');
      headerStyle.bold = true;
      headerStyle.backColor = '#E0E0E0';
      sheet.getRangeByName('A1:C1').cellStyle = headerStyle;

      for (var i = 0; i < teachers.length; i++) {
        DateTime? timestamp;

        timestamp = teachers[i].checkIn ?? DateTime.now();

        String formattedDate = '-';

        formattedDate = DateFormat(
          'd MMMM yyyy HH:mm',
          'id_ID',
        ).format(timestamp);

        sheet.getRangeByName('A${i + 2}').setText("${i + 1}");
        sheet.getRangeByName('B${i + 2}').setText(teachers[i].name);
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
          '$selectedDirectory/data_kehadiran_guru${req.date}.xlsx';

      final File file = File(filePath);
      await file.writeAsBytes(bytes, flush: true);
      return Right("Data excel berhasil di simpan di: $filePath");
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> addTeacherCompletion(int teacherId) async {
    try {
      final response =
          await Network.apiClient.put("/attendanceteacher/$teacherId");

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      return const Right("Rekam Pulang Berhasil");
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> getAttendanceTeacherCurrent(int teacherId) async {
    try {
      final response = await Network.apiClient
          .get("/attendanceteacher/teacherid/$teacherId/current");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      final data = response.data['data'] as Map<String, dynamic>;
      return Right(data);
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }
}
