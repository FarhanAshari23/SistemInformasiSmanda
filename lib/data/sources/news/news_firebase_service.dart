import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:new_sistem_informasi_smanda/data/models/news/news.dart';
import 'package:new_sistem_informasi_smanda/domain/entities/news/news.dart';

abstract class NewsFirebaseService {
  Future<Either> createNews(NewsModel createNewsReq);
  Future<Either> updateNews(NewsEntity updateNewsReq);
  Future<Either> deleteNews(String uidNews);
  Future<Either> getNews();
}

class NewsFirebaseServiceImpl extends NewsFirebaseService {
  @override
  Future<Either> createNews(NewsModel createNewsReq) async {
    try {
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      DocumentReference documentReference =
          await firebaseFirestore.collection("News").add(
        {
          "createdAt": createNewsReq.createdAt,
          "title": createNewsReq.title,
          "content": createNewsReq.content,
          "from": createNewsReq.from,
          "to": createNewsReq.to
        },
      );
      await documentReference.update({'uIdNews': documentReference.id});
      return const Right("Upload news was succesfull");
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getNews() async {
    try {
      var returnedData =
          await FirebaseFirestore.instance.collection("News").get();
      return Right(returnedData.docs.map((e) => e.data()).toList());
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> deleteNews(String uidNews) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('News');
      QuerySnapshot querySnapshot =
          await users.where('uIdNews', isEqualTo: uidNews).get();
      for (var doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return const Right('Delete Data News Success');
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> updateNews(NewsEntity updateNewsReq) async {
    try {
      CollectionReference users = FirebaseFirestore.instance.collection('News');
      QuerySnapshot querySnapshot =
          await users.where('uIdNews', isEqualTo: updateNewsReq.uIdNews).get();
      if (querySnapshot.docs.isNotEmpty) {
        String docId = querySnapshot.docs[0].id;
        await users.doc(docId).update({
          "content": updateNewsReq.content,
          "from": updateNewsReq.from,
          "title": updateNewsReq.title,
          "to": updateNewsReq.to,
        });
        return right('Update Data News Success');
      }
      return const Right('Update Data News Success');
    } catch (e) {
      return Left(e.toString());
    }
  }
}
