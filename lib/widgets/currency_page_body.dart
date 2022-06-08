import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/utils/extensions.dart';
import 'package:coin_cap_app/widgets/currency_chart.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:coin_cap_app/widgets/rank_widget.dart';
import 'package:coin_cap_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:responsive_grid/responsive_grid.dart';
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

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [buildGrid(), buildButton(), const CurrencyChart()],
          ),
        ),
      ),
    );
  }

  Widget buildPriceAndPercent() {
    double priceUsd = _provider.currency!.priceUsd;
    double changePercent24Hr = _provider.currency!.changePercent24Hr;
    bool changePercentPositive = changePercent24Hr > 0.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '\$${priceUsd.roundToDigits(2)}',
          style: const TextStyle(fontSize: 32),
        ),
        Row(
          children: [
            Text('${changePercent24Hr.roundToDigits(2)}%',
                style: TextStyle(
                    fontSize: 18,
                    color: changePercentPositive ? Colors.green : Colors.red)),
            Icon(
              changePercentPositive ? Icons.arrow_upward : Icons.arrow_downward,
              color: changePercentPositive ? Colors.green : Colors.red,
            )
          ],
        )
      ],
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
    double marketCap = _provider.currency!.marketCapUsd;
    double volume24Hr = _provider.currency!.volumeUsd24Hr;
    double supply = _provider.currency!.supply;
    int rank = _provider.currency!.rank;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
              xs: 12,
              sm: 6,
              md: 6,
              lg: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RankWidget(rank),
                  buildPriceAndPercent(),
                ],
              )),
          ResponsiveGridCol(
              xs: 6,
              sm: 6,
              md: 3,
              lg: 3,
              child:
                  buildGridCell('Market Cap', '\$${marketCap.toFormatted()}')),
          ResponsiveGridCol(
              xs: 6,
              sm: 6,
              md: 3,
              lg: 3,
              child: buildGridCell(
                  'Volume (24Hr)', '\$${volume24Hr.toFormatted()}')),
          ResponsiveGridCol(
              xs: 12,
              sm: 6,
              md: 12,
              lg: 3,
              child: buildGridCell('Supply',
                  '${supply.toFormatted()} ${_provider.currency?.symbol}'))
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
