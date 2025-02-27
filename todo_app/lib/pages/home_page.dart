import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:todo_app/util/dialog_box.dart';
import '../data/database.dart';
import '../util/todo_tile.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference hive
  final myBox = Hive.box('mybox');
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {

    // if this is the first time ever openin the app, then create default data
    if (myBox.get("TODOLIST") == null){
      db.createInitialData();
    } else {
      // there already exists data
      db.loadData();
    }


    super.initState();
  }


  // text controller
  final _controller = TextEditingController();


  // checkbox was tapped
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.todoList[index][1] = !db.todoList[index][1];

    });
    db.updateDataBase();
  }

  // save new task
  void saveNewTask() {
    setState(() {
      db.todoList.add([_controller.text, false]);
      _controller.clear(); // Clear text field after adding task
    });
    Navigator.of(context).pop(); // Close dialog after saving
    db.updateDataBase();
  }

// create a new task
  void createNewTask(){
    showDialog(
        context: context,
        builder: (context){
          return DialogBox(
            controller: _controller,
            onSave: saveNewTask,
            onCancel: () => Navigator.of(context).pop(),
          );
        }
    );
  }

  void deleteTask(int index){
    setState(() {
      db.todoList.removeAt(index);
    });
    db.updateDataBase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[700],
      appBar:
       AppBar(
        title: Center(
          child: Text("TODO"),
        ),
          leading: Padding(
            padding: const EdgeInsets.only(left: 150.0),
            child: const Icon(
              Icons.check
                    ),
          ),

      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewTask,
      child: Icon(Icons.add),
      ),
      
      body: ListView.builder(
        itemCount: db.todoList.length,
        itemBuilder: (context, index){
          return TodoTile(
              taskName: db.todoList[index][0],
              taskCompleted: db.todoList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
          );
        },

      ),
    );
  }
}
