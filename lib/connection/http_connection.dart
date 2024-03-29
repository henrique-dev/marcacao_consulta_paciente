import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:marcacao_consulta_paciente/config/constants.dart';

class HttpConnection {

  static final String host = "http://192.168.1.128:3000/";
  //static final String host = "http://headred.com.br/";

  static Future<dynamic> get(String path, {Function callBack, Function posCallBack,
    Map<String, String> headers}) async {
    String url = host + path;

    dynamic response = await http.get(url, headers: headers);

    if (callBack != null) {
      callBack(response, posCallBack);
    }

    return response;
  }

  static Future<dynamic> post(String path, {Function callBack, Function posCallBack,
    Map<String, String> headers, dynamic body}) async {
    String url = host + path;

    dynamic response = await http.post(
      url,
      headers: headers,
      body: body
    );

    if (callBack != null) {
      callBack(response, posCallBack);
    }
    return response;
  }

  static Future<dynamic> delete(String path, {Function callBack, Function posCallBack,
    Map<String, String> headers}) async {
    String url = host + path;

    dynamic response = await http.delete(
        url,
        headers: headers
    );

    if (callBack != null) {
      callBack(response, posCallBack);
    }
    return response;
  }



}