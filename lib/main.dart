import 'package:coin_cap_app/views/currency_list_page.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';

void main() {
  ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
    xs: 800,
    sm: 1000,
    md: 1320,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CoinCap App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal, brightness: Brightness.dark),
      home: const CurrencyListPage(),
    );
  }
}
