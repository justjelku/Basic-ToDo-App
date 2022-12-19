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
          return ListTile(
            leading: Text('${index + 1}'),
            title: Text(items[index]['title']),
            subtitle: Text(items[index]['body']),
          );
        },
      ),
    );
  }
}
