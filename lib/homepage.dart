import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List items = <dynamic>[];

  Future <void> getTodos() async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(url);

    setState(() {
      items = convert.jsonDecode(response.body) as List;
    });
  }

  Future <void> deleteTodos(String id) async {
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts/$id');
    final response = await http.delete(url);

    if (response.statusCode == 200) {
      final filtered = items.where((e) => e['_id'] != id).toList();
      setState(() {
        items = filtered;
      });
    }
    getTodos();
  }

  @override
  void initState(){
    super.initState();
    getTodos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text ("Basic ToDo App"),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index){
          final item = items[index] as Map;
          return Dismissible(
              key: ValueKey(item[index]),
              background: slideLeftBackground(),
              confirmDismiss: (direction) async{
                if (direction == DismissDirection.endToStart) {
                  final bool res = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: Text(
                              "Are you sure you want to delete\n${items[index]['title']}?"),
                          actions: <Widget>[
                            FloatingActionButton(
                              child: const Text(
                                "Cancel",
                                style: TextStyle(color: Colors.black),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            FloatingActionButton(
                              child: const Text(
                                "Delete",
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                setState(() {
                                  // items.removeAt(index);
                                  deleteTodos('_id');
                                });
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      });
                  return res;
                } else {
                }
                return null;
              },
              child: ListTile(
                leading: Text('${index + 1}'),
                title: Text(items[index]['title']),
                subtitle: Text(items[index]['body']),
              ),
          );
        },
      ),
    );
  }
  Widget slideLeftBackground(){
    return Container(
      color: Colors.red,
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        )
      )
    );
  }
}
