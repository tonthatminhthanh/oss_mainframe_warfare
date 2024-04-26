import 'package:flutter/material.dart';
import 'package:mw_project/constants/achievements_list.dart';
import 'package:mw_project/firebase/firebase_user_score.dart';
import 'package:mw_project/pages/windows_titlebar.dart';

import '../objects/user_score.dart';
import 'main_menu.dart';

class AchievementsPage extends StatefulWidget {
  const AchievementsPage({super.key});

  @override
  State<AchievementsPage> createState() => _AchievementsPageState();
}

class _AchievementsPageState extends State<AchievementsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: returnTitleBar(context: context, title: "Achievements"),
      body: StreamBuilder(
        stream: UserScoreSnapshot.datasFromFirebase(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
          {
            if(snapshot.hasError)
            {
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(":(", style: TextStyle(fontSize: 48, color: Colors.white),),
                    Text(snapshot.error.toString(), style: TextStyle(fontSize: 15, color: Colors.white),)
                  ],
                ),
              );
            }
            else
            {
              return Center(
                child: CircularProgressIndicator(color: Colors.white,),
              );
            }
          }
          else
            {
              UserScore userScore = snapshot.data!;
              final list = userScore.achievements;

              if(list.isEmpty)
                {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("You have no achievements yet!",
                          style: TextStyle(fontSize: 48, color: Colors.white),),
                      ],
                    ),
                  );
                }
              else
                {
                  return ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(achievements.where((element) => element.id == list[index]).first.name),
                          leading: Image.network(
                            achievements.where((element) => element.id == list[index]).first.imageUrl,
                            height: 128, width: 128,),
                          subtitle: Text(achievements.where((element) => element.id == list[index]).first.description),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: list.length
                  );
                }
            }
        },
      ),
    );
  }
}
