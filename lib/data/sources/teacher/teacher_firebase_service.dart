import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../../core/networks/network.dart';
import '../../../domain/entities/teacher/role.dart';
import '../../../domain/entities/teacher/schedule_teacher.dart';
import '../../../domain/entities/teacher/teacher.dart';
import '../../models/teacher/schedule_teacher.dart';
import '../../models/teacher/teacher.dart';

abstract class TeacherFirebaseService {
  Future<Either> createTeacher(TeacherEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(int teacherId);
  Future<Either> getTeacher();
  Future<Either> getTeacherByName(String name);
  Future<Either> getTeacherById(int teacherId);
  Future<Either> getScheduleTeacher(String name);
  Future<Either> createRoles(String role);
  Future<Either> deleteRole(int idRole);
  Future<Either> updateRoles(RoleEntity role);
  Future<Either> getRoles();
}

class TeacherFirebaseServiceImpl extends TeacherFirebaseService {
  @override
  Future<Either> getTeacher() async {
    try {
      final response = await Network.apiClient.get("/teachers");
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
  Future<Either> createTeacher(TeacherEntity teacherCreationReq) async {
    try {
      final secondaryApp = await Firebase.initializeApp(
        name: 'SecondaryApp',
        options: Firebase.app().options,
      );

      final secondaryAuth = FirebaseAuth.instanceFor(app: secondaryApp);

      await secondaryAuth.createUserWithEmailAndPassword(
        email: teacherCreationReq.email!,
        password: teacherCreationReq.password!,
      );

      final model = TeacherModelX.fromEntity(teacherCreationReq);
      final response =
          await Network.apiClient.post("/teacher", body: model.toMap());

      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }

      final data = TeacherModel.fromMap(response.data['data']);

      if (teacherCreationReq.imageFile != null) {
        Network.apiClient.postMultipart(
          "/teacher/${data.id}/photo",
          file: teacherCreationReq.imageFile!,
        );
      }

      return const Right("Buat akun guru sukses");
    } catch (e) {
      return Left("Something Error: $e");
    }
  }

  @override
  Future<Either> deleteTeacher(int teacherId) async {
    try {
      final responseGet = await Network.apiClient.delete("/teacher/$teacherId");
      if (responseGet.statusCode == 500) {
        return left("Connection error: ${responseGet.data}");
      }
      return const Right('Delete Data Teacher Success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> updateTeacher(TeacherEntity teacherReq) async {
    try {
      final model = TeacherModelX.fromEntity(teacherReq);
      if (teacherReq.imageFile != null) {
        Network.apiClient.postMultipart(
          "/teacher/${teacherReq.id}/photo",
          file: teacherReq.imageFile!,
        );
      }
      final response = await Network.apiClient
          .put("/teacher/${teacherReq.id}", body: model.toMap());
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Data guru berhasil diubah");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getTeacherByName(String name) async {
    try {
      final response = await Network.apiClient.get("/teachersName/$name");
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
  Future<Either> createRoles(String role) async {
    try {
      final response =
          await Network.apiClient.post("/task", body: {"name": role});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil dibuat");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> deleteRole(int idRole) async {
    try {
      final response = await Network.apiClient.delete("/task/$idRole");
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil dihapus");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getRoles() async {
    try {
      final response = await Network.apiClient.get("/tasks");
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
  Future<Either> getScheduleTeacher(String name) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final schedules = await firestore.collection("Jadwals").get();
      List<ScheduleTeacherEntity> result = [];
      for (var doc in schedules.docs) {
        final data = doc.data();
        List<String> days = ["Senin", "Selasa", "Rabu", "Kamis", "Jumat"];
        for (var day in days) {
          if (data[day] != null && data[day] is List) {
            for (var item in data[day]) {
              if (item['pelaksana'] == name) {
                final mapped = {
                  "hari": day,
                  "jam": item['jam'],
                  "kegiatan": item['kegiatan'],
                  "kelas": data['kelas']
                };
                final model = ScheduleTeacherModel.fromMap(mapped);
                result.add(model.toEntity());
              }
            }
          }
        }
      }
      return Right(result);
    } catch (e) {
      return Left("Something wrong: $e");
    }
  }

  @override
  Future<Either> updateRoles(RoleEntity role) async {
    try {
      final response = await Network.apiClient
          .put("/task/${role.id}", body: {"name": role.name});
      if (response.statusCode == 500) {
        return left("Connection error: ${response.message}");
      }
      return const Right("Tugas tambahan berhasil diubah");
    } catch (e) {
      return Left("Something error: ${e.toString()}");
    }
  }

  @override
  Future<Either> getTeacherById(int teacherId) async {
    try {
      final response = await Network.apiClient.get("/teacher/$teacherId");
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
