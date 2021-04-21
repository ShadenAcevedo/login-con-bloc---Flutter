import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_validation/bloc/provider.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final bloc = Provider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home')
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Correo: ${bloc.correo}'),
          Divider(),
          Text('Contraseña: ${bloc.contrasena}')
        ],
      ),
    );
  }
}
