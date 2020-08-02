import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_paciente/connection/connection.dart';

class SpecialitiesScreen extends StatefulWidget {
  @override
  _SpecialitiesScreenState createState() => _SpecialitiesScreenState();
}

class _SpecialitiesScreenState extends State<SpecialitiesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus encaminhamentos"),
        backgroundColor: Colors.black45,
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("patient/account_specialities.json", callback: null),
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
                    print(jsonDecoded);
                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  if (jsonDecoded.length > 0) {
                    return ListView.builder(
                        itemCount: jsonDecoded.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: Text(jsonDecoded[index]["speciality"]["name"], style: TextStyle(fontWeight: FontWeight.bold),),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text("Encaminhado por ${jsonDecoded[index]["medic_profile"]["name"]}"),
                                  Text("Em ${jsonDecoded[index]["at"]}")
                                ],
                              ),
                              onTap: (){

                              },
                            ),
                          );
                        }
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Nenhum encaminhamento ainda", textAlign: TextAlign.center,)
                      ],
                    );
                  }
                }
                break;
            }
            return Center(
              child: Text(""),
            );
          },
        ),
      ),
    );
  }
}
