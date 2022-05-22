import 'package:coin_cap_app/providers/currency_list_provider.dart';
import 'package:coin_cap_app/widgets/currency_list_page_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyListPage extends StatelessWidget {
  const CurrencyListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CurrencyListProvider(),
        child: Consumer<CurrencyListProvider>(
          builder: (BuildContext context, CurrencyListProvider provider,
                  Widget? child) =>
              Scaffold(
                  appBar: AppBar(
                    title: const Text('Currency list'),
                    centerTitle: true,
                    actions: [
                      IconButton(
                          tooltip: 'Refresh',
                          onPressed: () {
                            provider.getCurrenciesList();
                          },
                          icon: const Icon(Icons.refresh))
                    ],
                  ),
                  body: const CurrencyListPageBody()),
        ));
  }
}
