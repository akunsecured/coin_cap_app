import 'package:coin_cap_app/models/coin_model.dart';
import 'package:coin_cap_app/pages/coin_page.dart';
import 'package:coin_cap_app/providers/coin_map_provider.dart';
import 'package:coin_cap_app/utils/constants.dart';
import 'package:coin_cap_app/utils/number_rounding.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:coin_cap_app/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CoinListPage extends StatefulWidget {
  const CoinListPage({Key? key}) : super(key: key);

  @override
  State<CoinListPage> createState() => _CoinListPageState();
}

class _CoinListPageState extends State<CoinListPage> {
  late CoinMapProvider _provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Coin list'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
          create: (context) {
            _provider = CoinMapProvider();
            return _provider;
          },
          child: Consumer<CoinMapProvider>(
            builder: (BuildContext context, CoinMapProvider provider,
                Widget? child) {
              if (provider.coinsList.isEmpty) {
                provider.getCoinList();
                return const LoadingWidget();
              }

              return LayoutBuilder(
                builder: (context, constraints) => SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                  minWidth: constraints.maxWidth),
                              child: buildDataTable(
                                  provider.coinsList,
                                  provider.sortColumnIndex,
                                  provider.sortAscending),
                            ),
                          ),
                        ),
                        !provider.isMaxLoaded()
                            ? Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: Constants.buttonVerticalMargin),
                                height: !provider.isLoading
                                    ? Constants.buttonHeight
                                    : null,
                                width: !provider.isLoading
                                    ? Constants.buttonWidth
                                    : null,
                                child: provider.isLoading
                                    ? const CircularProgressIndicator()
                                    : RoundedButton(
                                        text: 'Show more',
                                        onTap: () => provider.loadMore(),
                                      ))
                            : const SizedBox()
                      ],
                    )),
              );
            },
          ),
        ));
  }

  DataTable buildDataTable(
      List<CoinModel> coins, int? sortColumnIndex, bool sortAscending) {
    final columns = ['Rank', 'Name', 'Price', 'Change (24Hr)'];

    return DataTable(
        showCheckboxColumn: false,
        sortColumnIndex: sortColumnIndex,
        sortAscending: sortAscending,
        columns: getColumns(columns),
        rows: getRows(coins),
        columnSpacing: 24,
    );
  }

  void onSort(int columnIndex, bool ascending) {
    _provider.changeSort(columnIndex: columnIndex, ascending: ascending);
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Align(alignment: Alignment.centerLeft, child: Text(column)),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<CoinModel> coins) => coins
      .map((coin) => DataRow(
              onSelectChanged: (bool? selected) {
                if (selected != null && selected) {
                  navigateToCoinPage(CoinNameSymbol.fromCoinModel(coin));
                }
              },
              cells: [
                DataCell(Text(coin.rank.toString())),
                getNameAndSymbol(coin),
                DataCell(Text(
                  '\$${coin.priceUsd.roundToDigits(2)}',
                )),
                DataCell(Text(
                  '${coin.changePercent24Hr.roundToDigits(2)}%',
                  style: TextStyle(
                      color: coin.changePercent24Hr.isNegative
                          ? Colors.red
                          : Colors.green),
                ))
              ]))
      .toList();

  DataCell getNameAndSymbol(CoinModel coin) =>
      DataCell(Text('${coin.name} (${coin.symbol})'));

  void navigateToCoinPage(CoinNameSymbol coinNameSymbol) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => CoinPage(coinNameSymbol: coinNameSymbol)));
  }
}
