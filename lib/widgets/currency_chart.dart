import 'package:coin_cap_app/models/chart_data.dart';
import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:coin_cap_app/widgets/interval_toggle_buttons.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class CurrencyChart extends StatefulWidget {
  const CurrencyChart({Key? key}) : super(key: key);

  @override
  State<CurrencyChart> createState() => _CurrencyChartState();
}

class _CurrencyChartState extends State<CurrencyChart> {
  late final List<ChartData> chartData;
  late CurrencyProvider _provider;
  late TooltipBehavior _tooltipBehavior;

  @override
  void initState() {
    chartData = [];
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<CurrencyProvider>();

    if (_provider.error != null) {
      return ErrorText(_provider.error);
    }

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: buildGraph());
  }

  Widget buildGraph() {
    if (_provider.isLoadingHistory) {
      return Column(
        children: const [LoadingWidget(), IntervalToggleButtons()],
      );
    }

    DateFormat dateFormat = getDateFormat();
    getChartData();

    return Column(
      children: [
        buildAnimatedAreaChart(dateFormat),
        const IntervalToggleButtons()
      ],
    );
  }

  DateFormat getDateFormat() {
    switch (_provider.selectedInterval.interval) {
      case 'm5':
        return DateFormat("h a");
      case 'h12':
        return DateFormat("MMM d");
      default:
        return DateFormat("MMM yyy");
    }
  }

  void getChartData() {
    chartData.clear();
    for (var element in _provider.currencyHistories) {
      chartData.add(ChartData(element.date!, element.priceUsd));
    }
  }

  SfCartesianChart buildAnimatedAreaChart(DateFormat dateFormat) {
    return SfCartesianChart(
        tooltipBehavior: _tooltipBehavior,
        plotAreaBorderWidth: 0,
        primaryXAxis: DateTimeAxis(dateFormat: dateFormat),
        primaryYAxis: NumericAxis(
            numberFormat: NumberFormat.simpleCurrency(decimalDigits: 3),
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0),
            decimalPlaces: 3),
        series: getSeries());
  }

  List<AreaSeries<ChartData, DateTime>> getSeries() {
    return <AreaSeries<ChartData, DateTime>>[
      AreaSeries<ChartData, DateTime>(
          name: _provider.currency!.name,
          enableTooltip: true,
          dataSource: chartData,
          color: Colors.teal,
          borderColor: Colors.tealAccent,
          borderWidth: 2,
          opacity: 0.5,
          xValueMapper: (ChartData data, _) => data.x,
          yValueMapper: (ChartData data, _) => data.y)
    ];
  }
}
