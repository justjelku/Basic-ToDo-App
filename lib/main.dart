import 'package:flutter/material.dart';
import 'package:todo_handsonsemifinal/homepage.dart';

void main(){
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Basic ToDo App',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage()
  ));
}

