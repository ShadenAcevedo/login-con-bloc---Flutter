import 'package:flutter/material.dart';
import 'package:form_validation/bloc/login_bloc.dart';
export 'package:form_validation/bloc/login_bloc.dart';

import 'package:form_validation/bloc/products_bloc.dart';
export 'package:form_validation/bloc/products_bloc.dart';

class Provider extends InheritedWidget{

  final loginBloc = LoginBloc();
  final _productsBloc = ProductsBloc();

  static Provider ?_instancia;

  factory Provider({Key ?key, required Widget child }){
    if( _instancia == null ){
      _instancia = Provider._internal(key: key, child: child);
    }

    return _instancia!;
  }

  Provider._internal({Key ?key, required Widget child })
   : super(key: key, child: child);


  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => true;

  static LoginBloc of ( BuildContext context ){
     return context.dependOnInheritedWidgetOfExactType<Provider>()!.loginBloc;
  }

  static ProductsBloc productsBloc ( BuildContext context ){
     return context.dependOnInheritedWidgetOfExactType<Provider>()!._productsBloc;
  }
}