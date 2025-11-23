import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

import '../../../common/helper/generate_keyword.dart';
import '../../../domain/entities/auth/teacher.dart';

abstract class TeacherFirebaseService {
  Future<Either> createTeacher(TeacherEntity teacherCreationReq);
  Future<Either> updateTeacher(TeacherEntity teacherReq);
  Future<Either> deleteTeacher(TeacherEntity teacherReq);
  Future<Either> getTeacherByName(String name);
  Future<Either> createRoles(String role);
  Future<Either> deleteRole(String role);
  Future<Either> getRoles();
  Future<Either> getKepalaSekolah();
  Future<Either> getWaka();
  Future<Either> getTeacher();
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
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getWaka() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection("Teachers").get();

      final result = returnedData.docs
          .where((doc) {
            final jabatan = (doc.data()["jabatan_tambahan"] ?? "").toString();
            return jabatan.contains("Wakil Kepala Sekolah");
          })
          .map((doc) => doc.data())
          .toList();
      return Right(result);
    } catch (e) {
      return Left(e.toString());
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
      return Left(e.toString());
    }
  }

  @override
  Future<Either> createTeacher(TeacherEntity teacherCreationReq) async {
    const String endpoint =
        "http://192.168.18.2:8000/api/upload-image-teachers";
    DocumentReference? teacherRef;
    try {
      Uri? url;
      try {
        url = Uri.parse(endpoint);
      } catch (_) {
        throw Exception("URL tidak valid: $endpoint");
      }

      final request = http.MultipartRequest("POST", url);

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          teacherCreationReq.image?.path ?? '',
          filename: basename(teacherCreationReq.image?.path ?? ''),
        ),
      );

      request.headers.addAll({
        "Accept": "application/json",
        "Content-Type": "multipart/form-data",
      });

      final streamedResponse = await request.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          throw Exception("Timeout: Server tidak merespon.");
        },
      );

      final responseBody = await streamedResponse.stream.bytesToString();

      if (streamedResponse.statusCode != 200) {
        throw Exception(
          "Upload gagal (status: ${streamedResponse.statusCode}). "
          "Response: $responseBody",
        );
      }

      try {
        jsonDecode(responseBody);
      } catch (_) {
        throw Exception("Response server bukan JSON valid: $responseBody");
      }

      final keywords = generateKeywords(teacherCreationReq.nama);
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      teacherRef = await firebaseFirestore.collection("Teachers").add(
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
    } on SocketException {
      if (teacherRef != null) await teacherRef.delete();
      throw Exception("Tidak ada koneksi internet.");
    } on HttpException {
      if (teacherRef != null) await teacherRef.delete();
      throw Exception("Kesalahan HTTP terjadi.");
    } on FormatException {
      if (teacherRef != null) await teacherRef.delete();
      throw Exception("Format data tidak valid.");
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> deleteTeacher(TeacherEntity teacherReq) async {
    const String endpoint =
        "http://192.168.18.2:8000/api/delete-image-teachers";
    try {
      Uri? url;
      try {
        url = Uri.parse(endpoint);
      } catch (_) {
        throw Exception("URL tidak valid: $endpoint");
      }

      final response = await http.post(url, body: {
        "name": teacherReq.nama,
        "nip": teacherReq.nip != '-' ? teacherReq.nip : teacherReq.tanggalLahir,
      });

      if (response.statusCode != 200) {
        throw Exception("Upload gagal (status: ${response.statusCode})");
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('Teachers');
      QuerySnapshot querySnapshot = await users
          .where(
            teacherReq.nip == '-' ? "nama" : "NIP",
            isEqualTo: teacherReq.nip == '-' ? teacherReq.nama : teacherReq.nip,
          )
          .get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Teacher Success');
    } catch (e) {
      return Left('Something Wrong : $e');
    }
  }

  @override
  Future<Either> updateTeacher(TeacherEntity teacherReq) async {
    const String endpoint =
        "http://192.168.18.2:8000/api/update-image-teachers";
    try {
      if (teacherReq.image != null) {
        Uri? url;
        try {
          url = Uri.parse(endpoint);
        } catch (_) {
          throw Exception("URL tidak valid: $endpoint");
        }

        final request = http.MultipartRequest("POST", url);

        request.fields['name'] = teacherReq.nama;
        request.fields['nip'] = teacherReq.nip != '-'
            ? teacherReq.nip
            : teacherReq.tanggalLahir.toString();

        request.files.add(
          await http.MultipartFile.fromPath(
            "photo",
            teacherReq.image?.path ?? '',
            filename: basename(teacherReq.image?.path ?? ''),
            contentType: http.MediaType("image", "jpg"),
          ),
        );

        request.headers.addAll({
          "Accept": "application/json",
          "Content-Type": "multipart/form-data",
        });

        final streamedResponse = await request.send().timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            throw Exception("Timeout: Server tidak merespon.");
          },
        );

        final responseBody = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode != 200) {
          throw Exception(
            "Upload gagal (status: ${streamedResponse.statusCode}). "
            "Response: $responseBody",
          );
        }

        try {
          jsonDecode(responseBody);
        } catch (_) {
          throw Exception("Response server bukan JSON valid: $responseBody");
        }
      }

      CollectionReference users =
          FirebaseFirestore.instance.collection('Teachers');
      QuerySnapshot querySnapshot = await users
          .where(
            teacherReq.nip == '-' ? "nama" : "NIP",
            isEqualTo: teacherReq.nip == '-' ? teacherReq.nama : teacherReq.nip,
          )
          .get();
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
    } on SocketException {
      throw Exception("Tidak ada koneksi internet.");
    } on HttpException {
      throw Exception("Kesalahan HTTP terjadi.");
    } on FormatException {
      throw Exception("Format data tidak valid.");
    } catch (e) {
      return Left(e.toString());
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
      return Left(e.toString());
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
      return Left(e.toString());
    }
  }

  @override
  Future<Either> createRoles(String role) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Roles").add(
        {
          "role": role,
        },
      );
      return const Right("Upload role was succesfull");
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> deleteRole(String role) async {
    try {
      CollectionReference item = FirebaseFirestore.instance.collection('Roles');
      QuerySnapshot querySnapshot =
          await item.where('role', isEqualTo: role).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Role Success');
    } catch (e) {
      return Left('Something wrong: $e');
    }
  }

  @override
  Future<Either> getRoles() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection('Roles').get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }
}
