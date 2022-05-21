import 'package:coin_cap_app/models/currency.dart';
import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/widgets/currency_page_body.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencyPage extends StatefulWidget {
  final Currency currency;

  const CurrencyPage(this.currency, {Key? key}) : super(key: key);

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  /*late List<_ChartData> _chartData;

  @override
  void initState() {
    print(IntervalEnum.d1.getName());
    _getChartData();
    super.initState();
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.currency.name} (${widget.currency.symbol})'),
          centerTitle: true,
        ),
        body: ChangeNotifierProvider(
          create: (_) => CurrencyProvider(widget.currency.id!),
          child: Consumer<CurrencyProvider>(
            builder: (BuildContext context, CurrencyProvider provider,
                    Widget? child) =>
                const CurrencyPageBody(),
          ),
        )
        /*
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [_buildAnimationAreaChart()],
      ),
       */
        );
  }
}

/*
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
*/
