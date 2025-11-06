import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/entities/ekskul/update_anggota_req.dart';
import '../../models/auth/user.dart';
import '../../models/ekskul/ekskul.dart';
import '../../models/teacher/teacher.dart';

abstract class EkskulFirebaseService {
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(EkskulEntity ekskul);
  Future<Either> updateAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> deleteAnggota(UpdateAnggotaReq anggotaReq);
}

class EkskulFirebaseServiceImpl extends EkskulFirebaseService {
  @override
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      final model = EkskulModel(
        namaEkskul: ekskulCreationReq.namaEkskul,
        pembina: TeacherModelX.fromEntity(ekskulCreationReq.pembina),
        ketua: UserModelX.fromEntity(ekskulCreationReq.ketua),
        wakilKetua: UserModelX.fromEntity(ekskulCreationReq.wakilKetua),
        sekretaris: UserModelX.fromEntity(ekskulCreationReq.sekretaris),
        bendahara: UserModelX.fromEntity(ekskulCreationReq.bendahara),
        deskripsi: ekskulCreationReq.deskripsi,
        anggota: ekskulCreationReq.anggota
            .map((a) => UserModelX.fromEntity(a))
            .toList(),
      );
      await firebaseFirestore.collection("Ekskuls").add(model.toMap());

      final namaPembina = ekskulCreationReq.pembina.nama.trim();
      final nipPembina = ekskulCreationReq.pembina.nip.trim();
      final namaEkskul = ekskulCreationReq.namaEkskul.trim();

      if (namaPembina.isNotEmpty) {
        final query = await FirebaseFirestore.instance
            .collection("Teachers")
            .where(
              nipPembina != '-' && nipPembina.isNotEmpty ? "NIP" : "nama",
              isEqualTo: nipPembina != '-' && nipPembina.isNotEmpty
                  ? nipPembina
                  : namaPembina,
            )
            .get();
        if (query.docs.isNotEmpty) {
          final teacherDoc = query.docs.first;
          final teacherRef = teacherDoc.reference;
          final data = teacherDoc.data();
          final existingJabatan = data['jabatan_tambahan'];

          final current = (existingJabatan == null ||
                  existingJabatan.toString().trim().isEmpty ||
                  existingJabatan == '-')
              ? ''
              : existingJabatan.toString();

          // Tambahkan jabatan baru tanpa duplikasi
          final jabatanBaru = "Pembina Ekskul $namaEkskul";
          final hasJabatan = current.contains(jabatanBaru);
          final updateJabatan = hasJabatan
              ? current
              : (current.isEmpty ? jabatanBaru : "$current, $jabatanBaru");

          await teacherRef.update({
            "jabatan_tambahan": updateJabatan,
          });
        }
      }
      await _updateStudentEkskul(
        ekskulCreationReq.ketua.nisn,
        "Ketua $namaEkskul",
      );
      await _updateStudentEkskul(
        ekskulCreationReq.wakilKetua.nisn,
        "Wakil Ketua $namaEkskul",
      );
      await _updateStudentEkskul(
        ekskulCreationReq.bendahara.nisn,
        "Bendahara $namaEkskul",
      );
      await _updateStudentEkskul(
        ekskulCreationReq.sekretaris.nisn,
        "Sekretaris $namaEkskul",
      );

      return const Right("Upload ekskul was succesfull");
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> getEkskul() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection("Ekskuls").get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    try {
      final firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('Ekskuls');
      QuerySnapshot querySnapshot = await users
          .where('nama_ekskul', isEqualTo: ekskulUpdateReq.oldNamaEkskul)
          .get();
      if (querySnapshot.docs.isEmpty) {
        return const Left('Ekskul tidak ditemukan');
      }
      final doc = querySnapshot.docs.first;
      final docRef = doc.reference;
      final oldData = EkskulModel.fromMap(doc.data() as Map<String, dynamic>);
      final modelBaru = EkskulModel(
        namaEkskul: ekskulUpdateReq.namaEkskul,
        pembina: TeacherModelX.fromEntity(ekskulUpdateReq.pembina),
        ketua: UserModelX.fromEntity(ekskulUpdateReq.ketua),
        wakilKetua: UserModelX.fromEntity(ekskulUpdateReq.wakilKetua),
        sekretaris: UserModelX.fromEntity(ekskulUpdateReq.sekretaris),
        bendahara: UserModelX.fromEntity(ekskulUpdateReq.bendahara),
        deskripsi: ekskulUpdateReq.deskripsi,
        anggota: ekskulUpdateReq.anggota
            .map((a) => UserModelX.fromEntity(a))
            .toList(),
      );
      await docRef.update(modelBaru.toMap());

      Future<void> updateTeacherPosition(
        TeacherModel? oldTeacher,
        TeacherModel? newTeacher,
      ) async {
        final oldJabatan = "Pembina Ekskul ${oldData.namaEkskul}";
        final newJabatan = "Pembina Ekskul ${modelBaru.namaEkskul}";

        // Hapus jabatan lama
        if (oldTeacher != null) {
          final query = await firestore
              .collection("Teachers")
              .where("NIP", isEqualTo: oldTeacher.nip)
              .get();
          if (query.docs.isNotEmpty) {
            final doc = query.docs.first;
            final data = doc.data();
            final jabatan = data["jabatan_tambahan"]?.toString() ?? '';
            final updated = jabatan
                .split(', ')
                .where((j) => j.trim() != oldJabatan)
                .join(', ');
            await doc.reference.update({"jabatan_tambahan": updated});
          }
        }

        // Tambahkan jabatan baru
        if (newTeacher != null) {
          final query = await firestore
              .collection("Teachers")
              .where("NIP", isEqualTo: newTeacher.nip)
              .get();
          if (query.docs.isNotEmpty) {
            final doc = query.docs.first;
            final data = doc.data();
            final jabatan = data["jabatan_tambahan"]?.toString() ?? '';
            final hasJabatan = jabatan.contains(newJabatan);
            final updated = hasJabatan || jabatan.isEmpty || jabatan == '-'
                ? newJabatan
                : "$jabatan, $newJabatan";
            await doc.reference.update({"jabatan_tambahan": updated});
          }
        }
      }

      Future<void> updateStudentEkskul(
        UserModel? oldStudent,
        UserModel? newStudent,
        String role,
      ) async {
        final oldText = "$role ${oldData.namaEkskul}";
        final newText = "$role ${modelBaru.namaEkskul}";

        // Hapus dari siswa lama
        if (oldStudent != null) {
          final query = await firestore
              .collection("Students")
              .where("nisn", isEqualTo: oldStudent.nisn)
              .get();
          if (query.docs.isNotEmpty) {
            final doc = query.docs.first;
            final data = doc.data();
            final ekskul = data["ekskul"]?.toString() ?? '';
            final updated =
                ekskul.split(', ').where((e) => e.trim() != oldText).join(', ');
            await doc.reference.update({"ekskul": updated});
          }
        }

        // Tambahkan ke siswa baru
        if (newStudent != null) {
          final query = await firestore
              .collection("Students")
              .where("nisn", isEqualTo: newStudent.nisn)
              .get();
          if (query.docs.isNotEmpty) {
            final doc = query.docs.first;
            final data = doc.data();
            final ekskul = data["ekskul"]?.toString() ?? '';
            final hasEkskul = ekskul.contains(newText);
            final updated = hasEkskul || ekskul.isEmpty || ekskul == '-'
                ? newText
                : "$ekskul, $newText";
            await doc.reference.update({"ekskul": updated});
          }
        }
      }

      await updateTeacherPosition(oldData.pembina, modelBaru.pembina);
      await updateStudentEkskul(oldData.ketua, modelBaru.ketua, "Ketua");
      await updateStudentEkskul(
        oldData.wakilKetua,
        modelBaru.wakilKetua,
        "Wakil Ketua",
      );
      await updateStudentEkskul(
        oldData.sekretaris,
        modelBaru.sekretaris,
        "Sekretaris",
      );
      await updateStudentEkskul(
        oldData.bendahara,
        modelBaru.bendahara,
        "Bendahara",
      );

      return const Right('Update Data Ekskul Success');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> deleteEkskul(EkskulEntity ekskul) async {
    try {
      final firestore = FirebaseFirestore.instance;
      CollectionReference users = firestore.collection('Ekskuls');
      QuerySnapshot querySnapshot =
          await users.where('nama_ekskul', isEqualTo: ekskul.namaEkskul).get();
      if (querySnapshot.docs.isEmpty) {
        return const Left("Ekskul tidak ditemukan");
      }
      final doc = querySnapshot.docs.first;
      final data = EkskulModel.fromMap(doc.data() as Map<String, dynamic>);
      final namaEkskul = data.namaEkskul;

      Future<void> removeTeacherPosition(TeacherModel? teacher) async {
        if (teacher == null) return;
        final query = await firestore
            .collection("Teachers")
            .where("NIP", isEqualTo: teacher.nip)
            .get();
        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final oldData = doc.data();
          final jabatan = oldData["jabatan_tambahan"]?.toString() ?? '';
          // Hapus teks pembina ekskul
          final updated = jabatan
              .split(', ')
              .where((j) => !j.trim().contains("Ekskul $namaEkskul"))
              .join(', ')
              .trim();
          await doc.reference.update({
            "jabatan_tambahan": updated.isEmpty ? '-' : updated,
          });
        }
      }

      Future<void> removeStudentEkskul(UserModel? student) async {
        if (student == null) return;
        final query = await firestore
            .collection("Students")
            .where("nisn", isEqualTo: student.nisn)
            .get();
        if (query.docs.isNotEmpty) {
          final doc = query.docs.first;
          final oldData = doc.data();
          final ekskulField = oldData["ekskul"]?.toString() ?? '';
          // Hapus teks yang berisi nama ekskul ini
          final updated = ekskulField
              .split(', ')
              .where((e) => !e.trim().contains(namaEkskul))
              .join(', ')
              .trim();
          await doc.reference.update({
            "ekskul": updated.isEmpty ? '-' : updated,
          });
        }
      }

      await removeTeacherPosition(data.pembina);
      await removeStudentEkskul(data.ketua);
      await removeStudentEkskul(data.wakilKetua);
      await removeStudentEkskul(data.sekretaris);
      await removeStudentEkskul(data.bendahara);
      await doc.reference.delete();

      return const Right('Delete Data Ekskul Success');
    } catch (e) {
      return left(e.toString());
    }
  }

  @override
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq) async {
    try {
      final anggotaModel = UserModel(
        email: anggotaReq.anggota.email ?? '',
        nama: anggotaReq.anggota.nama ?? '',
        kelas: anggotaReq.anggota.kelas ?? '',
        nisn: anggotaReq.anggota.nisn ?? '',
        tanggalLahir: anggotaReq.anggota.tanggalLahir ?? '',
        noHp: anggotaReq.anggota.noHP ?? '',
        alamat: anggotaReq.anggota.alamat ?? '',
        ekskul: anggotaReq.anggota.ekskul ?? '',
        gender: anggotaReq.anggota.gender ?? 0,
        isAdmin: anggotaReq.anggota.isAdmin ?? false,
        agama: anggotaReq.anggota.agama ?? '',
        isRegister: anggotaReq.anggota.isRegister ?? false,
      ).toMap();

      final batch = FirebaseFirestore.instance.batch();

      for (final ekskulNama in anggotaReq.namaEkskul) {
        final query = await FirebaseFirestore.instance
            .collection("Ekskuls")
            .where("nama_ekskul", isEqualTo: ekskulNama)
            .get();

        for (var doc in query.docs) {
          batch.update(doc.reference, {
            'anggota': FieldValue.arrayUnion([anggotaModel]),
          });
        }
      }
      await batch.commit();
      return const Right('Success Add Anggota');
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> updateAnggota(UpdateAnggotaReq anggotaReq) async {
    try {
      final anggotaModel = UserModel(
        email: anggotaReq.anggota.email ?? '',
        nama: anggotaReq.anggota.nama ?? '',
        kelas: anggotaReq.anggota.kelas ?? '',
        nisn: anggotaReq.anggota.nisn ?? '',
        tanggalLahir: anggotaReq.anggota.tanggalLahir ?? '',
        noHp: anggotaReq.anggota.noHP ?? '',
        alamat: anggotaReq.anggota.alamat ?? '',
        ekskul: anggotaReq.anggota.ekskul ?? '',
        gender: anggotaReq.anggota.gender ?? 0,
        isAdmin: anggotaReq.anggota.isAdmin ?? false,
        agama: anggotaReq.anggota.agama ?? '',
        isRegister: anggotaReq.anggota.isRegister ?? false,
      ).toMap();

      final batch = FirebaseFirestore.instance.batch();

      final query =
          await FirebaseFirestore.instance.collection("Ekskuls").get();

      for (var doc in query.docs) {
        final namaEkskul = doc['nama_ekskul'] as String;

        if (anggotaReq.namaEkskul.contains(namaEkskul)) {
          batch.update(doc.reference, {
            "anggota": FieldValue.arrayUnion([anggotaModel])
          });
        } else {
          batch.update(doc.reference, {
            "anggota": FieldValue.arrayRemove([anggotaModel])
          });
        }
      }
      await batch.commit();
      return const Right('Success Add Anggota');
    } catch (e) {
      return Left('Something Wrong: $e');
    }
  }

  @override
  Future<Either> deleteAnggota(UpdateAnggotaReq anggotaReq) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final query = await firestore
          .collection("Students")
          .where("nisn", isEqualTo: anggotaReq.anggota.nisn)
          .get();

      if (query.docs.isEmpty) {
        return const Left('Student not found');
      }

      final doc = query.docs.first;
      final data = doc.data();
      final current = data['ekskul']?.toString() ?? '';

      // Hapus ekskul yang mengandung namaEkskul
      final updated = current
          .split(', ')
          .where((e) => !e.contains(anggotaReq.namaEkskul.first))
          .join(', ')
          .trim();

      await doc.reference.update({
        "ekskul": updated.isEmpty ? '-' : updated,
      });
      return const Right("Delete anggota success");
    } catch (e) {
      return Left("Something error: $e");
    }
  }

  Future<void> _updateStudentEkskul(String? nisn, String ekskulBaru) async {
    if (nisn == null || nisn.trim().isEmpty) return;

    final query = await FirebaseFirestore.instance
        .collection("Students")
        .where("nisn", isEqualTo: nisn)
        .get();

    if (query.docs.isEmpty) return;

    final studentDoc = query.docs.first;
    final studentRef = studentDoc.reference;
    final data = studentDoc.data();

    final existingEkskul = data['ekskul']?.toString() ?? '';

    // Hindari duplikasi
    final hasEkskul = existingEkskul.contains(ekskulBaru);
    final updateEkskul = hasEkskul
        ? existingEkskul
        : (existingEkskul.isEmpty || existingEkskul == '-'
            ? ekskulBaru
            : "$existingEkskul, $ekskulBaru");

    await studentRef.update({"ekskul": updateEkskul});
  }
}
