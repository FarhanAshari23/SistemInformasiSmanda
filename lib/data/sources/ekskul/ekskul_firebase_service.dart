import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';

import '../../../domain/entities/ekskul/ekskul.dart';
import '../../models/ekskul/ekskul.dart';

abstract class EkskulFirebaseService {
  Future<Either> createEkskul(EkskulModel ekskulCreationReq);
  Future<Either> getEkskul();
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq);
  Future<Either> deleteEkskul(String nameEkskul);
}

class EkskulFirebaseServiceImpl extends EkskulFirebaseService {
  @override
  Future<Either> createEkskul(EkskulModel ekskulCreationReq) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      await firebaseFirestore.collection("Ekskuls").add(
        {
          "nama_ekskul": ekskulCreationReq.namaEkskul,
          "nama_pembina": ekskulCreationReq.namaPembina,
          "nama_ketua": ekskulCreationReq.namaKetua,
          "nama_wakil": ekskulCreationReq.namaWakilKetua,
          "nama_sekretaris": ekskulCreationReq.namaSekretaris,
          "nama_bendahara": ekskulCreationReq.namaBendahara,
          "deskripsi": ekskulCreationReq.deskripsi,
        },
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
  Future<Either> deleteEkskul(String nameEkskul) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Ekskuls');
      QuerySnapshot querySnapshot =
          await users.where('nama_ekskul', isEqualTo: nameEkskul).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data Ekskul Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }

  @override
  Future<Either> updateEkskul(EkskulEntity ekskulUpdateReq) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('Ekskuls');
      QuerySnapshot querySnapshot = await users
          .where('nama_ekskul', isEqualTo: ekskulUpdateReq.namaEkskul)
          .get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "nama_pembina": ekskulUpdateReq.namaPembina,
          "nama_ketua": ekskulUpdateReq.namaKetua,
          "nama_wakil": ekskulUpdateReq.namaWakilKetua,
          "nama_sekretaris": ekskulUpdateReq.namaSekretaris,
          "nama_bendahara": ekskulUpdateReq.namaBendahara,
          "deskripsi": ekskulUpdateReq.deskripsi,
        });
        return right('Update Data Ekskul Success');
      }
      return const Right('Update Data Ekskul Success');
    } catch (e) {
      return const Left('Something Wrong');
    }
  }
}
