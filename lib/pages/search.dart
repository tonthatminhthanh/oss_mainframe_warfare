import 'package:flutter/material.dart';

import '../firebase/firebase_user_score.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController txtSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          children: [
            Icon(Icons.book, color: Colors.white,),
            Text("Leaderboard", style: TextStyle(fontSize: 16),)
          ],
        ),
      ),body: StreamBuilder(
      stream: UserScoreSnapshot.usersFromFirebase(),
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
          List<UserScoreSnapshot> list = snapshot.data! as List<UserScoreSnapshot>;
          list.removeWhere((element) => !element.getUserScore().name.toLowerCase().contains(txtSearch.text.toLowerCase()));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Focus(
                onFocusChange: (hasFocus) async {
                  if(!hasFocus)
                  {
                    setState(() {

                    });
                  }
                },
                child: TextFormField(controller: txtSearch,
                  decoration: InputDecoration(
                      labelText: "Search", prefixIcon: Icon(Icons.search),
                      hintText: "Find someone",
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(0),
                          borderSide: BorderSide(
                              color: Colors.lightBlue,
                              width: 2.0
                          )
                      )
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Expanded(
                  child: ListView.separated(
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(list[index].getUserScore().name),
                          subtitle: Text("Kills: ${list[index].getUserScore().kills} "
                              "- Waves: ${list[index].getUserScore().maxWave}"),
                        );
                      },
                      separatorBuilder: (context, index) => Divider(),
                      itemCount: list.length
                  )
              )
            ]
          );
        }
        },
      ),
    );
  }
}
