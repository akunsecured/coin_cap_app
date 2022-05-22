import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/providers/currency_list_provider.dart';
import 'package:coin_cap_app/utils/extensions.dart';
import 'package:coin_cap_app/views/currency_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyDataTable extends StatefulWidget {
  const CurrencyDataTable({Key? key}) : super(key: key);

  @override
  State<CurrencyDataTable> createState() => _CurrencyDataTableState();
}

class _CurrencyDataTableState extends State<CurrencyDataTable> {
  final columns = ['Rank', 'Name', 'Price'];
  late CurrencyListProvider _provider;

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<CurrencyListProvider>();
    return buildDataTable();
  }

  Widget buildDataTable() => DataTable(
        showCheckboxColumn: false,
        sortColumnIndex: _provider.sortColumnIndex,
        sortAscending: _provider.sortAscending,
        columns: getColumns(columns),
        rows: getRows(_provider.currenciesList),
        columnSpacing: 24,
      );

  void onSort(int columnIndex, bool ascending) {
    _provider.changeSort(columnIndex: columnIndex, ascending: ascending);
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
          label: Align(alignment: Alignment.centerLeft, child: Text(column)),
          onSort: onSort))
      .toList();

  List<DataRow> getRows(List<Currency> currencies) => currencies
      .map((currency) => DataRow(
              onSelectChanged: (bool? selected) {
                if (selected != null && selected) {
                  navigateToCoinPage(context, currency);
                }
              },
              cells: [
                DataCell(Text(currency.rank.toString())),
                getNameAndSymbol(currency),
                DataCell(Text(
                  '\$${currency.priceUsd.roundToDigits(2)}',
                ))
              ]))
      .toList();

  DataCell getNameAndSymbol(Currency currency) =>
      DataCell(Text('${currency.name} (${currency.symbol})'));

  void navigateToCoinPage(BuildContext context, Currency currency) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => CurrencyPage(currency)));
  }
}
