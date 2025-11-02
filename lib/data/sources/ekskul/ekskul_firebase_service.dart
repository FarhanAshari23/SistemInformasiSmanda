import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/ekskul/ekskul.dart';
import '../../../domain/entities/ekskul/update_anggota_req.dart';
import '../../models/auth/user.dart';
import '../../models/ekskul/anggota.dart';
import '../../models/ekskul/ekskul.dart';
import '../../models/teacher/teacher.dart';

abstract class EkskulFirebaseService {
  Future<Either> createEkskul(EkskulEntity ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(EkskulEntity ekskul);
  Future<Either> updateAnggota(UpdateAnggotaReq anggotaReq);
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq);
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
            .map((a) => AnggotaModel.fromEntity(a))
            .toList(),
      );
      await firebaseFirestore.collection("Ekskuls").add(model.toMap());

      final namaPembina = ekskulCreationReq.pembina.nama.trim();
      final nipPembina = ekskulCreationReq.pembina.nip.trim();
      final namaEkskul = ekskulCreationReq.namaEkskul.trim();

      if (namaPembina.isNotEmpty) {
        final query = nipPembina != '-' && nipPembina.isNotEmpty
            ? await FirebaseFirestore.instance
                .collection("Teachers")
                .where("NIP", isEqualTo: nipPembina)
                .get()
            : await FirebaseFirestore.instance
                .collection("Teachers")
                .where("nama", isEqualTo: namaPembina)
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
      CollectionReference users =
          FirebaseFirestore.instance.collection('Ekskuls');
      QuerySnapshot querySnapshot = await users
          .where('nama_ekskul', isEqualTo: ekskulUpdateReq.oldNamaEkskul)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        final model = EkskulModel(
          namaEkskul: ekskulUpdateReq.namaEkskul,
          pembina: TeacherModelX.fromEntity(ekskulUpdateReq.pembina),
          ketua: UserModelX.fromEntity(ekskulUpdateReq.ketua),
          wakilKetua: UserModelX.fromEntity(ekskulUpdateReq.wakilKetua),
          sekretaris: UserModelX.fromEntity(ekskulUpdateReq.sekretaris),
          bendahara: UserModelX.fromEntity(ekskulUpdateReq.bendahara),
          deskripsi: ekskulUpdateReq.deskripsi,
          anggota: ekskulUpdateReq.anggota
              .map((a) => AnggotaModel.fromEntity(a))
              .toList(),
        );
        await users.doc(docId).update(model.toMap());
        return right('Update Data Ekskul Success');
      }
      return const Right('Update Data Ekskul Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> deleteEkskul(EkskulEntity ekskul) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Ekskuls');
      QuerySnapshot querySnapshot =
          await users.where('nama_ekskul', isEqualTo: ekskul.namaEkskul).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Ekskul Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> addAnggota(UpdateAnggotaReq anggotaReq) async {
    try {
      final anggotaModel = AnggotaModel(
        nama: anggotaReq.anggota.nama,
        nisn: anggotaReq.anggota.nisn,
      );

      final batch = FirebaseFirestore.instance.batch();

      for (final ekskulNama in anggotaReq.namaEkskul) {
        final query = await FirebaseFirestore.instance
            .collection("Ekskuls")
            .where("nama_ekskul", isEqualTo: ekskulNama)
            .get();

        for (var doc in query.docs) {
          batch.update(doc.reference, {
            'anggota': FieldValue.arrayUnion([anggotaModel.toMap()]),
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
      final anggotaModel = AnggotaModel(
        nama: anggotaReq.anggota.nama,
        nisn: anggotaReq.anggota.nisn,
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
}
