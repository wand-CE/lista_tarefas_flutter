import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../AppRoutes.dart';

class OperationsSupaBaseDB {
  final supabase = Supabase.instance.client;

  Future<void> createNewUser(context, String email, String password) async {
    final AuthResponse res = await supabase.auth.signUp(
      email: '$email',
      password: '$password',
    );

    final Session? session = res.session;
    final User? user = res.user;
    try {
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homePage);
      }
    } catch (error) {
      print(error);
    }
    ;
  }

  Future<void> loginUser(context, String email, String password) async {
    final AuthResponse res = await supabase.auth.signInWithPassword(
      email: '$email',
      password: '$password',
    );
    final Session? session = res.session;
    final User? user = res.user;

    try {
      if (user != null) {
        Navigator.pushReplacementNamed(context, AppRoutes.homePage);
      }
    } catch (error) {
      print(error);
    }
    ;
  }

  Future<void> logOutUser() async {
    await supabase.auth.signOut();
  }

  Future<List<dynamic>> getTarefas() async {
    final data = await supabase
        .from('tarefa')
        .select()
        .order('finished', ascending: true);

    return data;
  }

  Future<void> addTarefa(context, message) async {
    final User? user = supabase.auth.currentUser;

    await supabase.from('tarefa').insert({
      'id_user': '${user?.id}',
      'message': '$message',
    });
    Navigator.pushReplacementNamed(context, AppRoutes.homePage);
  }

  Future<void> excludeTarefa(context, int id_tarefa) async {
    final User? user = supabase.auth.currentUser;

    await supabase
        .from('tarefa')
        .delete()
        .match({'id_tarefa': '$id_tarefa', 'id_user': '${user?.id}'});
    Navigator.pushReplacementNamed(context, AppRoutes.homePage);
  }

  Future<void> editTarefa(context, int id_tarefa, String novo_texto) async {
    final User? user = supabase.auth.currentUser;

    await supabase.from('tarefa').update({'message': '$novo_texto'}).match(
        {'id_tarefa': '$id_tarefa', 'id_user': '${user?.id}'});
    Navigator.pushReplacementNamed(context, AppRoutes.homePage);
  }

  Future<void> editTarefaStatus(context, int id_tarefa, bool status) async {
    final User? user = supabase.auth.currentUser;

    await supabase.from('tarefa').update({'finished': status}).match(
        {'id_tarefa': '$id_tarefa', 'id_user': '${user?.id}'});
  }
}
