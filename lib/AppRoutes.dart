import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/pages/forgotPassPage.dart';
import 'package:lista_tarefas_flutter/pages/homePage.dart';
import 'package:lista_tarefas_flutter/pages/loginPage.dart';
import 'package:lista_tarefas_flutter/pages/signUpPage.dart';

class AppRoutes {
  static const homePage = '/homePage';
  static const signUpPage = '/signUpPage';
  static const loginPage = '/loginPage';
  static const forgotPassPage = '/forgotPassPage';

  static Map<String, WidgetBuilder> define() {
    return {
      homePage: (BuildContext context) => HomePage(),
      signUpPage: (BuildContext context) => SignUpPage(),
      loginPage: (BuildContext context) => LoginPage(),
      forgotPassPage: (BuildContext context) => ForgotPassPage(),
    };
  }
}
