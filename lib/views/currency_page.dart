import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/widgets/currency_page_body.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyPage extends StatelessWidget {
  final Currency currency;

  const CurrencyPage(this.currency, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_) => CurrencyProvider(currency.id),
        child: Consumer<CurrencyProvider>(
          builder: (BuildContext context, CurrencyProvider provider,
                  Widget? child) =>
              Scaffold(
            appBar: AppBar(
              title: Text('${currency.name} (${currency.symbol})'),
              centerTitle: true,
              actions: [
                IconButton(
                    tooltip: 'Refresh',
                    onPressed: () => provider.getCurrencyWithHistory(),
                    icon: const Icon(Icons.refresh))
              ],
            ),
            body: provider.error == null
                ? const CurrencyPageBody()
                : ErrorText(provider.error),
          ),
        ));
  }
}
