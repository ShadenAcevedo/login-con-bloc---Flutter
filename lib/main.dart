import 'package:flutter/material.dart';
import 'package:form_validation/bloc/provider.dart';
import 'package:form_validation/pages/home_page.dart';
import 'package:form_validation/pages/login_page.dart';
import 'package:form_validation/pages/product_page.dart';
import 'package:form_validation/pages/registro_page.dart';
import 'package:form_validation/user_preferences/user_preferences.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = UserPreferences();
  await prefs.initPref();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Form Validation',
          initialRoute: 'login',
          routes: {
            'login': (BuildContext context) => LoginPage(),
            'register': (BuildContext context) => RegisterPage(),
            'home': (BuildContext context) => HomePage(),
            'product': (BuildContext context) => ProductPage()
          },
          theme: ThemeData(
            primaryColor: Colors.deepPurple,
            inputDecorationTheme: InputDecorationTheme(
              labelStyle: TextStyle(color: Colors.deepPurple),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              border: OutlineInputBorder()
            )
          ),
        ),
    );
  }
}
