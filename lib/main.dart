import 'package:coin_cap_app/pages/coin_list_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCapeApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      home: const CoinListPage(),
    );
  }
}
