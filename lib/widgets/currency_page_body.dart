import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyPageBody extends StatefulWidget {
  const CurrencyPageBody({Key? key}) : super(key: key);

  @override
  State<CurrencyPageBody> createState() => _CurrencyPageBodyState();
}

class _CurrencyPageBodyState extends State<CurrencyPageBody> {
  late CurrencyProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<CurrencyProvider>();
    return Container();
  }
}
