import 'package:flutter/material.dart';
import 'package:form_validation/bloc/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _crearFondo(context),
          _loginForm(context)
        ],
      )
    );
  }

  Widget _crearFondo(BuildContext context){
    
    final size = MediaQuery.of(context).size;

    final fondoMorado = Container(
      height: size.height * 0.45,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(63, 70, 130, 1),
            Color.fromRGBO(100, 70, 160, 1)
          ]
        )
      ),
    );

    final circulo = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: Color.fromRGBO(255, 255, 255, 0.1)
      ),
    );

    final info = Container(
      padding: EdgeInsets.only(top: 70),
      child: Column(
        children: [
          Icon(Icons.person_pin_circle_rounded, color: Colors.white, size: 100),
          SizedBox(height: 10, width: double.infinity),
          Text('Shaden Daniela', style: TextStyle(color: Colors.white, fontSize: 25))
        ],
      ),
    );

    return Stack(
      children: [
        fondoMorado,
        Positioned(child: circulo, top: 60, left: 30),
        Positioned(child: circulo, top: -40, right: -30),
        Positioned(child: circulo, bottom: -50, left: -10),
        Positioned(child: circulo, bottom: 50, right: 10),
        info
      ],
    );
  }

  Widget _loginForm(BuildContext context){

    final bloc = Provider.of(context);

    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(
        children: [

          SafeArea(
              child: Container(
                height: 200,
              )
          ),
          Container(
            width: size.width * 0.85,
            margin: EdgeInsets.symmetric(vertical: 20),
            padding: EdgeInsets.symmetric(vertical: 50),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 4.0,
                  offset: Offset(0.0,5.0),
                  spreadRadius: 5.0
                )
              ]
            ),
            child: Column(
              children: [
                Text('Ingrese', style: TextStyle(fontSize: 20)),
                SizedBox(height: 60),
                _crearCorreo(bloc),
                SizedBox(height: 20),
                _crearContrasena(bloc),
                SizedBox(height: 20),
                _crearBoton(bloc)
              ],
            ),
          ),
          Text('¿Olvidó la contraseña?'),
          SizedBox(height: 100)
        ],
      ),
    );
  }

  Widget _crearCorreo(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.correoStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: TextField(
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              icon: Icon(Icons.alternate_email, color: Colors.deepPurple),
              hintText: 'ejemplo@correo.com',
              labelText: 'Correo electrónico',
              counterText: snapshot.data,
              errorText: snapshot.hasError ? snapshot.error.toString() : null
            ),
            onChanged: bloc.changeCorreo,
          ),
        );
      }
    );
  }

  Widget _crearContrasena(LoginBloc bloc){

    return StreamBuilder(
      stream: bloc.contrasenaStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 35),
          child: TextField(
            obscureText: true,
            decoration: InputDecoration(
              icon: Icon(Icons.lock_outline, color: Colors.deepPurple),
              labelText: 'Contraseña',
              counterText: snapshot.data,
              errorText: snapshot.hasError ? snapshot.error.toString() : null
            ),
            onChanged: bloc.changeContrasena,
          ),
        );
      }
    );
  }

  Widget _crearBoton(LoginBloc bloc){
    /*
    return ElevatedButton(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
          child: Text('Ingresar'),
        ),
        style: ElevatedButton.styleFrom(primary: Colors.deepPurple,elevation: 0.0),
        onPressed: snapshot.hasData ? (){} : null
    );

    return TextButton(
          onPressed: snapshot.hasData ? (){} : null,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
            child: Text('Ingresar'),
          ),
          style: TextButton.styleFrom(primary: Colors.white, backgroundColor: Colors.deepPurple),
        );
    */

    return StreamBuilder(
      stream: bloc.formValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return ElevatedButton(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text('Ingresar'),
            ),
            style: ElevatedButton.styleFrom(primary: Colors.deepPurple,elevation: 0.0),
            onPressed: snapshot.hasData ? () => _login(context, bloc) : null
        );
      }
    );
  }

  _login(BuildContext context, LoginBloc bloc){

    print('==========');
    print('Correo: ${bloc.correo}');
    print('Contraseña: ${bloc.contrasena}');
    print('==========');

    Navigator.pushReplacementNamed(context, 'home');
  }

}
