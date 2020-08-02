import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:marcacao_consulta_paciente/connection/connection.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../config.dart';

class SchedulingDetailsScreen extends StatefulWidget {

  final int _scheduling;

  SchedulingDetailsScreen(this._scheduling);

  @override
  _SchedulingDetailsScreenState createState() => _SchedulingDetailsScreenState(this._scheduling);
}

class _SchedulingDetailsScreenState extends State<SchedulingDetailsScreen> {

  final int _scheduling;

  Completer<GoogleMapController> _controller = Completer();
  BitmapDescriptor pinLocationIcon;
  Set<Marker> _markers = {};

  _SchedulingDetailsScreenState(this._scheduling);

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
  }

  void setCustomMapPin() async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'images/mark.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Consulta"),
          backgroundColor: Colors.black45
      ),
      body: Container(
        child: FutureBuilder<dynamic>(
          future: Connection.get("patient/schedulings/${this._scheduling}.json", callback: null),
          builder: (context, snapshot) {

            Map<String, dynamic> jsonDecoded;
            LatLng pinPosition;
            CameraPosition _kGooglePlex;

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

                    //pinPosition = LatLng(jsonDecoded["address"]["latitude"], jsonDecoded["address"]["longitude"]);
                    pinPosition = LatLng(0.034953, -51.064065);

                    _kGooglePlex = CameraPosition(
                        target: pinPosition,
                        zoom: 15,
                        bearing: 30
                    );
                  } else {
                    //Connection.checkResponse(response, reloadCallback);
                  }

                  return Stack(
                    children: [
                      GoogleMap(
                        mapType: MapType.normal,
                        myLocationButtonEnabled: true,
                        markers: _markers,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);

                          setState(() {
                            _markers.add(
                              Marker(
                                markerId: MarkerId('TESTE'),
                                position: pinPosition,
                                icon: pinLocationIcon
                              )
                            );
                          });
                        },
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        left: 0,
                        child: Card(
                          child: ListTile(
                            contentPadding: EdgeInsets.all(5),
                            leading: Image.asset("images/default_user.png"),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(jsonDecoded["medic_profile"]["name"], style: TextStyle(fontWeight: FontWeight.bold),)
                              ],
                            ),
                            subtitle: Padding(
                              padding: EdgeInsets.all(1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(jsonDecoded["speciality"]["name"]),
                                  Text(jsonDecoded["clinic"]["name"])
                                ],
                              ),
                            ),
                            onTap: (){

                            },
                          ),
                        ),
                      ),
                    ],
                  );
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
