import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_paciente/connection/connection.dart';
import 'package:marcacao_consulta_paciente/models/Speciality.dart';
import 'package:marcacao_consulta_paciente/models/medic_profile.dart';
import 'package:marcacao_consulta_paciente/models/medic_work_scheduling.dart';
import 'package:marcacao_consulta_paciente/screens/scheduling_screen.dart';

class SearchScreen extends StatefulWidget {

  final int _speciality;

  SearchScreen(this._speciality);

  @override
  _SearchScreenState createState() => _SearchScreenState(this._speciality);
}

class _SearchScreenState extends State<SearchScreen> {

  final int _speciality;

  _SearchScreenState(this._speciality);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Procurar"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("patient/medic_profiles.json?speciality=${_speciality}", callback: null),
          builder: (context, snapshot) {

            List<dynamic> jsonDecoded;

            switch (snapshot.connectionState) {
              case ConnectionState.none:
                break;
              case ConnectionState.waiting:
                CircularProgressIndicator();
                break;
              case ConnectionState.active:
                break;
              case ConnectionState.done:
                if (!snapshot.hasError) {

                  Response response = snapshot.data;
                  dynamic body = json.decode(response.body);

                  if (body is List<dynamic>) {
                    jsonDecoded = json.decode(response.body);
                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  return ListView.builder(
                      itemCount: jsonDecoded.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: Image.asset("images/default_user.png"),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(jsonDecoded[index]["name"], style: TextStyle(fontWeight: FontWeight.bold),),
                                Padding(
                                  padding: EdgeInsets.only(right: 10),
                                  child: RaisedButton(
                                    child: Text("Agendar"),
                                    onPressed: () async {
                                      Response response = await Connection.get(
                                          "patient/medic_work_schedulings/check_scheduling_priv?id=${jsonDecoded[index]["medic_work_scheduling"]["id"]}"
                                      );
                                      Map<String, dynamic> jsonDecoded2 = json.decode(response.body);
                                      print (jsonDecoded2);
                                      if (jsonDecoded2["success"]) {
                                        Navigator.push(context,MaterialPageRoute(builder: (context) => SchedulingScreen(jsonDecoded2["id"])));
                                      } else {
                                        Scaffold.of(context)..removeCurrentSnackBar()..showSnackBar(SnackBar(
                                          content: Text(jsonDecoded2["message"]),
                                        ));
                                      }
                                    },
                                    color: Colors.redAccent,
                                    textColor: Colors.white,
                                  ),
                                )
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.all(1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Especialidade: ${jsonDecoded[index]["specialities"][0]["name"]}"),
                                  Text("Clínica: ${jsonDecoded[index]["clinic"]["name"]}")
                                ],
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                        );
                      }
                  );
                }
                break;
            }
            return Center(
              child: Text(""),
            );
          },
        )
      ),
    );
  }
}
