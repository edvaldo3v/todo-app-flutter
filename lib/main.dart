import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Todo App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  var items = <Item>[];
  HomePage() {
    items = [];
    // items.add(Item(title: "title 1", done: true));
    // items.add(Item(title: "title 2", done: false));
    // items.add(Item(title: "title 3", done: true));
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  _HomePageState() {
    load();
  }
  var newTextCrtl = TextEditingController();

  void itemAdd() {
    if (newTextCrtl.text.isEmpty) return;
    setState(() {
      widget.items.add(Item(title: newTextCrtl.text, done: false));
      // newTextCrtl.text = "";
      newTextCrtl.clear();
      save();
    });
  }

  void itemRemove(int index) {
    setState(() {
      widget.items.removeAt(index);
      save();
    });
  }

  save() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  Future load() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    newTextCrtl.clear();
    return Scaffold(
      appBar: AppBar(
        // leading: Text('Oi!'),
        // title: Text('Todo App'),
        // actions: <Widget>[Icon(Icons.plus_one)],
        title: TextFormField(
          controller: newTextCrtl,
          keyboardType: TextInputType.text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
            labelText: "Tarefa",
            labelStyle: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = widget.items[index];
          return Dismissible(
              key: Key(item.title),
              background: Container(
                color: Colors.red,
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              onDismissed: (direction) {
                // if(direction == DismissDirection.startToEnd)
                // print(direction);
                itemRemove(index);
              },
              child: CheckboxListTile(
                title: Text(item.title),
                value: item.done,
                // key: Key(item.title),
                onChanged: (value) {
                  setState(() {
                    item.done = value!;
                    save();
                  });
                },
              ));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: itemAdd,
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
