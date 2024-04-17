import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:lista_tarefas_flutter/components/customTextFormField.dart';

import '../AppRoutes.dart';
import '../components/showAlertDialog.dart';
import '../database/operationsSupabase.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static OperationsSupaBaseDB supabaseInstanceUsers = OperationsSupaBaseDB();
  final Future<List<dynamic>> _listaTarefas =
  supabaseInstanceUsers.getTarefas();

  TextEditingController _createTarefaController = TextEditingController();

  List<dynamic> _idsTarefas = [];

  void changeMessage(indexMessage, newMessage) {
    setState(() {
      _idsTarefas[indexMessage] = newMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Lista de Tarefas'),
          centerTitle: true,
          backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
              onPressed: () {
                supabaseInstanceUsers.logOutUser();
                Navigator.pushReplacementNamed(context, AppRoutes.loginPage);
              },
              icon: Icon(Icons.logout))
        ],),

      body: Column(
        children: [
          FutureBuilder<List<dynamic>>(
            future: _listaTarefas,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.connectionState == ConnectionState.done) {
                return ListView.builder(
                  itemBuilder: (context, index) {
                    //changeMessage();
                    print(snapshot.data?[index]);
                    _idsTarefas.add(snapshot.data?[index]['id_tarefa']);

                    return Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey,
                      ),
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  TextEditingController _textEditingController =
                                  TextEditingController(
                                    text: '${snapshot.data?[index]['message']}',
                                  );

                                  return ShowAlertDialog(
                                    title: SizedBox.shrink(),
                                    content: TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Editar Tarefa',
                                        ),
                                        controller: _textEditingController),
                                    yesAnswer: 'Salvar',
                                    alertAction: () {
                                      String novo_texto =
                                          _textEditingController.text;
                                      Future<String> editar_tarefa =
                                      supabaseInstanceUsers.editTarefa(
                                          context,
                                          '${_idsTarefas[index]}',
                                          '$novo_texto'
                                      );

                                      editar_tarefa.then((value) {
                                        if (value == 'sucesso')
                                          changeMessage(index, '${novo_texto}');
                                      });
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            '${snapshot.data?[index]['message']}',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return ShowAlertDialog(
                                    title: Text('Excluir Pessoa'),
                                    content: Text(
                                      'Tem certeza que deseja excluir o usuário '
                                          '${_idsTarefas[index]}?',
                                    ),
                                    yesAnswer: 'Sim',
                                    alertAction: () {
                                      supabaseInstanceUsers
                                          .excludeTarefa(context, 'id_tarefa');
                                    },
                                  );
                                },
                              );
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                  itemCount: snapshot.data?.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                );
              } else {
                return Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 10,
                    ));
              }
            },
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: CustomTextFormField(
                  campo: 'Digite uma nova tarefa',
                  controlador: _createTarefaController,
                ),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  supabaseInstanceUsers.addTarefa(context, _createTarefaController.text);
                },
                child: Text('Adicionar'),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
