import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/todo.dart';
import 'package:todo_app/services/auth.dart';
import 'package:todo_app/services/database.dart';

class Home extends StatefulWidget {
  FirebaseAuth auth;
  FirebaseFirestore firestore;

  Home({Key? key, required this.auth, required this.firestore})
      : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _todoContentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              Auth(auth: widget.auth).signOut();
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(
            height: 20,
          ),
          const Text(
            "Add To do here:",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Card(
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _todoContentController,
                  )),
                  IconButton(
                      onPressed: () {
                        if (_todoContentController.text != "") {
                          setState(() {
                            Database(firestore: widget.firestore).addTodo(
                                uid: widget.auth.currentUser.uid,
                                content: _todoContentController.text);

                            _todoContentController.clear();
                          });
                        }
                      },
                      icon: const Icon(Icons.add))
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
              child: StreamBuilder(
                  stream: Database(firestore: widget.firestore)
                      .streamTodos(uid: widget.auth.currentUser.uid),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<TodoModel>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.active) {
                      if (snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text("You don't have any todo remaining"),
                        );
                      }

                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 5),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Expanded(
                                        child: Text(
                                      snapshot.data![index].content,
                                    )),

                                    Checkbox(value: snapshot.data![index].done, onChanged: (newValue){
                                      setState(() {
                                        Database(firestore: widget.firestore).updateTodo(uid: widget.auth.currentUser.uid, todoId: snapshot.data![index].todoId);
                                      });
                                    })
                                    // Checkbox(value: value, onChanged: onChanged)
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return const Center(
                        child: Text("Loading"),
                      );
                    }
                  }))
        ],
      ),
    );
  }
}
