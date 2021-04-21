

import 'dart:async';

class Validators {

  final validarCorreo = StreamTransformer<String, String>.fromHandlers(
    handleData: (correo, sink) {

      Pattern pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regExp = RegExp(pattern.toString());

      if(regExp.hasMatch(correo)){
        sink.add(correo);
      } else {
        sink.addError('Correo no es correcto');
      }
    }
  );

  final validarContrasena = StreamTransformer<String, String>.fromHandlers(
    handleData: (contrasena, sink) {

      if(contrasena.length >= 6){
        sink.add( contrasena );
      } else {
        sink.addError('Mínimo 6 caracteres');
      }
    }
  );
}