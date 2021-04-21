

import 'dart:async';
import 'package:rxdart/rxdart.dart';
import 'package:form_validation/bloc/validators.dart';

class LoginBloc with Validators {

  final _correoController     = BehaviorSubject<String>();
  final _contrasenaController = BehaviorSubject<String>();

  // insertar valores al stream
  Function(String) get changeCorreo     => _correoController.sink.add;
  Function(String) get changeContrasena => _contrasenaController.sink.add;

  // recuperar los datos del stream
  Stream<String> get correoStream => _correoController.stream.transform(validarCorreo);
  Stream<String> get contrasenaStream => _contrasenaController.stream.transform(validarContrasena);

  Stream<bool> get formValidStream =>
      Rx.combineLatest2(correoStream, contrasenaStream, (e, p) => true);

  // Obtener el ultimo valor ingresado en los streams
  String get correo => _correoController.value!;
  String get contrasena => _contrasenaController.value!;

  dispose(){
    _correoController.close();
    _contrasenaController.close();
  }
}