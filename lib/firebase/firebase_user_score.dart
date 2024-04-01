import 'package:firebase_auth/firebase_auth.dart';
import 'package:mw_project/objects/user_score.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserScoreSnapshot
{
  UserScore _userScore;
  DocumentReference _documentReference;

  UserScoreSnapshot({required UserScore userScore, required DocumentReference documentReference}) :
      _userScore = userScore, _documentReference = documentReference;

  factory UserScoreSnapshot.fromSnapshot(DocumentSnapshot documentSnapshot)
  {
    return UserScoreSnapshot(
        userScore: UserScore.fromJson(documentSnapshot.data() as Map<String, dynamic>),
        documentReference: documentSnapshot.reference
    );
  }

  static Future<void> addUserScores(UserScore userScore)
  async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    FirebaseFirestore.instance.collection("user_data").doc(uid).set(userScore.toJson());
  }

  static void addKill()
  {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("user_data").doc(uid).update(
      {
        "kills": FieldValue.increment(1)
      }
    );
  }

  static Future<void> updateWave(int currentMainWave)
  async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final futureDS = FirebaseFirestore.instance.collection("user_data").doc(uid).get();
    DocumentSnapshot ds = await futureDS;
    var maxWave = ds.get("maxWave");
    if(maxWave < currentMainWave)
      {
        FirebaseFirestore.instance.collection("user_data").doc(uid).update(
            {
              "maxWave": currentMainWave
            }
        );
      }
  }
}