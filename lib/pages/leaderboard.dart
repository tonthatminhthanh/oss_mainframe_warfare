import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mw_project/firebase/firebase_user_score.dart';
import 'package:mw_project/pages/main_menu.dart';
import 'package:mw_project/pages/search.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  bool _isWaveStat = true;

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
        actions: [
          ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.zero
              ))
            ),
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => MainMenuPage(),)
                );
              },
              child: Icon(Icons.close, color: Colors.white,)
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: StreamBuilder(
        stream: _isWaveStat == true
            ? UserScoreSnapshot.userWavesFromFirebase()
            : UserScoreSnapshot.userKillsFromFirebase(),
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

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: _createColumns(),
                        rows: _createRows(list),
                      )
                    ),
                  ),
                  Row(
                    children: [
                      _isWaveStat == false ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero
                              ))
                          ),
                          onPressed: () {
                            setState(() {
                              _isWaveStat = true;
                            });
                          },
                          child: Text("Waves")
                      ) : Text("Waves"),
                      _isWaveStat ? ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.blue),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero
                              ))
                          ),
                          onPressed: () {
                            setState(() {
                              _isWaveStat = false;
                            });
                          },
                          child: Text("Kills")
                      ) : Text("Kills"),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(),));
                          },
                          child: Text("Search")
                      )
                    ],
                  )
                ],
              );
            }
        },
      )
    );
  }

  List<DataColumn> _createColumns()
  {
    return [
      DataColumn(label: Text("No.")),
      DataColumn(label: Text("Name")),
      _isWaveStat == true
          ? DataColumn(label: Text("Number of waves"))
          : DataColumn(label: Text("Number of kills")),
    ];
  }

  List<DataRow> _createRows(List<UserScoreSnapshot> list)
  {
    return List.generate(list.length, (index) {
      return DataRow(
          cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(list.elementAt(index).getUserScore().name)),
            DataCell(
              _isWaveStat
                  ? Text(list.elementAt(index).getUserScore().maxWave.toString())
                  : Text(list.elementAt(index).getUserScore().kills.toString())
            ),
          ]);
    });
  }
}
