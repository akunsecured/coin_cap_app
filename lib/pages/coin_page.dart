import 'dart:math';

import 'package:coin_cap_app/models/coin_model.dart';
import 'package:coin_cap_app/models/interval_enum.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CoinPage extends StatefulWidget {
  final CoinNameSymbol coinNameSymbol;

  const CoinPage({Key? key, required this.coinNameSymbol}) : super(key: key);

  @override
  State<CoinPage> createState() => _CoinPageState();
}

class _CoinPageState extends State<CoinPage> {
  late List<_ChartData> _chartData;

  @override
  void initState() {
    print(IntervalEnum.d1.getName());
    _getChartData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.coinNameSymbol.name} (${widget.coinNameSymbol.symbol})'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildAnimationAreaChart()
        ],
      ),
    );
  }

  SfCartesianChart _buildAnimationAreaChart() {
    return SfCartesianChart(
        plotAreaBorderWidth: 0,
        primaryXAxis: NumericAxis(
            majorGridLines: const MajorGridLines(width: 0)),
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

  /// Return the random value in area series.
  int _getRandomInt(int min, int max) {
    final Random random = Random();
    return min + random.nextInt(max - min);
  }

  void _getChartData() {
    _chartData = <_ChartData>[];
    for (int i = 1; i <= 8; i++) {
      _chartData.add(_ChartData(i, _getRandomInt(10, 95)));
    }
  }
}

class _ChartData {
  _ChartData(this.x, this.y);
  final int x;
  final int y;
}
