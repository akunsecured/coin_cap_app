import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:coin_cap_app/widgets/interval_toggle_buttons.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CurrencyGraph extends StatefulWidget {
  const CurrencyGraph({Key? key}) : super(key: key);

  @override
  State<CurrencyGraph> createState() => _CurrencyGraphState();
}

class _CurrencyGraphState extends State<CurrencyGraph> {
  late final List<_ChartData> _chartData;
  late CurrencyProvider _provider;

  @override
  void initState() {
    _chartData = [];
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

    _getChartData();
    return Column(
      children: [_buildAnimationAreaChart(), const IntervalToggleButtons()],
    );
  }

  SfCartesianChart _buildAnimationAreaChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis:
            NumericAxis(majorGridLines: const MajorGridLines(width: 0)),
        primaryYAxis: NumericAxis(
            majorTickLines: const MajorTickLines(color: Colors.transparent),
            axisLine: const AxisLine(width: 0)),
        series: _getDefaultAreaSeries());
  }

  /// Return the list of  area series which need to be animated.
  List<AreaSeries<_ChartData, num>> _getDefaultAreaSeries() {
    return <AreaSeries<_ChartData, num>>[
      AreaSeries<_ChartData, num>(
          dataSource: _chartData,
          color: Colors.teal,
          borderColor: Colors.tealAccent,
          borderWidth: 2,
          opacity: 0.5,
          xValueMapper: (_ChartData sales, _) => sales.x,
          yValueMapper: (_ChartData sales, _) => sales.y)
    ];
  }

  void _getChartData() {
    _chartData.clear();
    for (var element in _provider.currencyHistories) {
      _chartData.add(_ChartData(element.time, element.priceUsd));
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);

  final int x;
  final double y;
}
