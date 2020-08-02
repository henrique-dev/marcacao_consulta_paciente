import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_paciente/config/constants.dart';
import 'package:marcacao_consulta_paciente/connection/connection.dart';
import 'package:marcacao_consulta_paciente/models/clinic_profile.dart';
import 'package:marcacao_consulta_paciente/models/medic_profile.dart';
import 'package:marcacao_consulta_paciente/models/medic_work_scheduling.dart';
import 'package:marcacao_consulta_paciente/models/speciality.dart';
import 'package:marcacao_consulta_paciente/screens/main_screen.dart';

class SchedulingScreen extends StatefulWidget {

  final int _medicWorkScheduling;

  SchedulingScreen(this._medicWorkScheduling);

  @override
  _SchedulingScreenState createState() => _SchedulingScreenState(_medicWorkScheduling);
}

class _SchedulingScreenState extends State<SchedulingScreen> {

  int _medicWorkScheduling;

  _SchedulingScreenState(this._medicWorkScheduling);

  void makeSchedulingCallback(Response response) {
    Map<String, dynamic> jsonDecoded = json.decode(response.body);

    if (jsonDecoded["success"]) {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => MainScreen(currentBottomNavigationBarIndex: 1)
          ),
        ModalRoute.withName("/")
      );
    } else {

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Confirmar consulta"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        padding: EdgeInsets.all(15),
        child: FutureBuilder<dynamic> (
          future: Connection.get("patient/medic_work_schedulings/next_available_scheduling?id=${_medicWorkScheduling}", callback: null),
          builder: (context, snapshot) {

            Map<String, dynamic> jsonDecoded;

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

                  if (body is Map<String, dynamic>) {
                    jsonDecoded = json.decode(response.body);
                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  flex: 1,
                                  child: Image.asset("images/default_user.png")
                              ),
                              Expanded(
                                flex: 5,
                                child: Text(jsonDecoded["medic_profile"]["name"], style: TextStyle(fontSize: 25), textAlign: TextAlign.center,),
                              )
                            ],
                          ),
                          Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.only(top: 20, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text("Especialidade:"),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(jsonDecoded["speciality"]["name"], textAlign: TextAlign.right,),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top:10, left: 10, right: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: Text("Unidade médica:"),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Text(jsonDecoded["clinic"]["name"], textAlign: TextAlign.right,),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(20),
                                child: Text("Próximo dia disponível:"),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(Constants.WEEK_DAYS[jsonDecoded["current_date"]["day_of_week"]], style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(0),
                                  child: Text(jsonDecoded["current_date"]["day_of_month"].toString(), style: TextStyle(
                                      fontSize: 50,
                                      color: Colors.redAccent
                                  ),),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Text(Constants.MONTHS[jsonDecoded["current_date"]["month"]-1], style: TextStyle(
                                      fontSize: 20
                                  ),),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text("Atenção: Agendamentos com especialista requer encaminhamento", textAlign: TextAlign.center,),
                          RaisedButton(
                            color: Colors.redAccent,
                            textColor: Colors.white,
                            onPressed: (){
                              var hashBody = {};
                              hashBody["day"] = jsonDecoded["current_date"]["day_of_month"];
                              hashBody["month"] = jsonDecoded["current_date"]["month"];
                              hashBody["year"] = jsonDecoded["current_date"]["year"];
                              hashBody["medic_work_scheduling_id"] = jsonDecoded["medic_work_scheduling"]["id"];
                              var headers = {
                                "Content-Type" : "application/json; charset=UTF-8"
                              };
                              Connection.post("patient/schedulings.json",
                                  callback: makeSchedulingCallback,
                              body: json.encode(hashBody));
                            },
                            child: Text("Confirmar agendamento"),
                          )
                        ],
                      )
                    ],
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
