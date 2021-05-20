import 'package:flutter/material.dart';
import 'package:projekt3/puzzle_home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Puzzle',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue,
          primaryColorDark: Colors.blue.shade700,
          backgroundColor: Colors.blue.shade100,
          accentColor: Colors.red,
          cardColor: Colors.yellow,
          errorColor: Colors.orange,
          brightness: Brightness.light,
        ),
        textTheme: Typography.englishLike2018,
      ).copyWith(
        splashFactory: InkRipple.splashFactory,
      ),
      home: PuzzleHomePage(),
    );
  }
}
