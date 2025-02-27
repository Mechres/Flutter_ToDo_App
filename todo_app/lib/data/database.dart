import 'package:hive/hive.dart';

class ToDoDataBase {

  List todoList = [

  ];

  // reference box
  final _myBox = Hive.box('mybox');

  // run this method if this is the first time ever opening the app
  void createInitialData(){
    todoList =  [
      ["Make an App", false],
      ["Learn Flutter", false]
    ];
  }


  // load the data from database
  void loadData(){
    todoList = _myBox.get("TODOLIST");
  }

  // update the database
  void updateDataBase(){
    _myBox.put("TODOLIST", todoList);
  }

}