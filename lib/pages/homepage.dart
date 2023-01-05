import 'package:flutter/material.dart';
import 'package:flutter_sqflite_project/model/notes_model.dart';
import 'package:flutter_sqflite_project/services/data_base_helpher.dart';
import 'package:flutter_sqflite_project/services/db_helpher.dart';

class Homepage extends StatefulWidget {
  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  DbHelpher? dbHelpher;
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelpher = DbHelpher();
    loadData();
  }

  loadData() {
    notesList = dbHelpher!.getNotesList();
    print(notesList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () {
              dbHelpher!
                  .insert(
                NotesModel(
                    age: 20,
                    description: "My third note",
                    email: "sadd@gmail.com",
                    title: "First "),
              )
                  .then((value) {
                setState(() {
                  notesList = dbHelpher!.getNotesList();
                });

                print("data added");
              }).onError((error, stackTrace) {
                print(error.toString());
              });
            }),
        body: Center(
          child: Column(
            children: [
              FutureBuilder(
                  future: notesList,
                  builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                    if (snapshot.hasData) {
                    } else {
                      return Container();
                    }
                    return snapshot.data == null
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.blue,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            reverse: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  dbHelpher!.update(NotesModel(
                                      id: snapshot.data![index].id,
                                      age: 21,
                                      description: "uodated",
                                      email: "sadd@gmail",
                                      title: "pdate"));
                                  setState(() {
                                    notesList = dbHelpher!.getNotesList();
                                  });
                                },
                                child: Dismissible(
                                  key: ValueKey<int>(snapshot.data![index].id!),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    color: Colors.red,
                                    child: const Icon(
                                      Icons.delete_forever,
                                    ),
                                  ),
                                  onDismissed: (DismissDirection direction) {
                                    setState(() {
                                      dbHelpher!
                                          .delete(snapshot.data![index].id!);
                                      notesList = dbHelpher!.getNotesList();
                                      snapshot.data!
                                          .remove(snapshot.data![index]);
                                    });
                                  },
                                  child: Card(
                                    child: ListTile(
                                      contentPadding: const EdgeInsets.all(0),
                                      title: Text(
                                        snapshot.data![index].title.toString(),
                                      ),
                                      subtitle: Text(
                                        snapshot.data![index].description
                                            .toString(),
                                      ),
                                      trailing: Text(
                                        snapshot.data![index].age.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }));
                  })
            ],
          ),
        ));
  }
}
