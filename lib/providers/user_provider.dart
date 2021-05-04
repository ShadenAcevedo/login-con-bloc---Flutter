import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:form_validation/user_preferences/user_preferences.dart';


class UserProvider {

  final String _firebaseToken = 'AIzaSyDAHzCt_7PHQKfhvw4ko3LSLWqs2XoMtIg';
  final prefs = UserPreferences();

  Future<Map<String,dynamic>> login( String correo, String contrasena ) async {
    final authData = {
      'email' : correo,
      'password' : contrasena,
      'returnSecureToken' : true
    };

    final resp = await http.post(
        Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=$_firebaseToken'),
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);

    if(decodedResp.containsKey('idToken')){
      //Guardar el token en el storage
      prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token': decodedResp['idToken']};
    } else {
      return {'ok' : false, 'mensaje': decodedResp['error']['message']};
    }
  }

  Future<Map<String,dynamic>> nuevoUsuario( String correo, String contrasena ) async {

    final authData = {
      'email' : correo,
      'password' : contrasena,
      'returnSecureToken' : true
    };

    final resp = await http.post(
        Uri.parse('https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=$_firebaseToken'),
        body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
    
    if(decodedResp.containsKey('idToken')){
      //Guardar el token en el storage
      prefs.token = decodedResp['idToken'];
      return {'ok' : true, 'token': decodedResp['idToken']};
    } else {
      return {'ok' : false, 'mensaje': decodedResp['error']['message']};
    }

  }
}