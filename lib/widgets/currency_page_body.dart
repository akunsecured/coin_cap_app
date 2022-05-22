import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/utils/extensions.dart';
import 'package:coin_cap_app/widgets/currency_graph.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:coin_cap_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'title_text.dart';

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

    if (_provider.error != null) {
      return ErrorText(_provider.error);
    }

    if (_provider.isLoading) {
      return const LoadingWidget();
    }

    int rank = _provider.currency!.rank;
    double priceUsd = _provider.currency!.priceUsd;
    double changePercent24Hr = _provider.currency!.changePercent24Hr;
    bool changePercentPositive = changePercent24Hr > 0.0;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 64,
                    backgroundColor: Colors.teal,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$rank',
                            style: const TextStyle(
                                fontSize: 24, color: Colors.white)),
                        const Text('Rank',
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          '\$${priceUsd.roundToDigits(2)}',
                          style: const TextStyle(fontSize: 32),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('${changePercent24Hr.roundToDigits(2)}%',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: changePercentPositive
                                        ? Colors.green
                                        : Colors.red)),
                            Icon(
                              changePercentPositive
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: changePercentPositive
                                  ? Colors.green
                                  : Colors.red,
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
              buildGrid(),
              buildButton(),
              const CurrencyGraph()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildGridCell(String title, String data) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TitleText(title),
          Text(
            data,
            style: const TextStyle(fontSize: 24.0),
          )
        ],
      );

  Widget buildGrid() {
    var size = MediaQuery.of(context).size;

    double marketCap = _provider.currency!.marketCapUsd;
    double volume24Hr = _provider.currency!.volumeUsd24Hr;
    double supply = _provider.currency!.supply;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: (size.width / 2) / (size.width / 2 / 3),
        shrinkWrap: true,
        crossAxisCount: 2,
        children: [
          buildGridCell('Market Cap', '\$${marketCap.toFormatted()}'),
          buildGridCell('Volume (24Hr)', '\$${volume24Hr.toFormatted()}'),
          buildGridCell('Supply',
              '${supply.toFormatted()} ${_provider.currency?.symbol}'),
        ],
      ),
    );
  }

  void navigateToUrl(String url) => launchUrl(Uri.parse(url));

  Widget buildButton() => _provider.currency?.explorer != null
      ? RoundedButton(
          text: 'Open in explorer'.toUpperCase(),
          onTap: () => navigateToUrl(_provider.currency!.explorer!),
        )
      : const SizedBox();
}
