import 'package:coin_cap_app/models/date_interval.dart';
import 'package:coin_cap_app/providers/currency_provider.dart';
import 'package:coin_cap_app/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'title_text.dart';

class IntervalToggleButtons extends StatefulWidget {
  const IntervalToggleButtons({Key? key}) : super(key: key);

  @override
  State<IntervalToggleButtons> createState() => _IntervalToggleButtonsState();
}

class _IntervalToggleButtonsState extends State<IntervalToggleButtons> {
  late CurrencyProvider _provider;
  late Map<String, dynamic> options;

  @override
  void initState() {
    options = {};
    IntervalEnum.values.asMap().forEach((index, intervalEnum) {
      options[intervalEnum.asString()] = index;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _provider = context.watch<CurrencyProvider>();

    return Column(children: [
      const TitleText('Select interval:'),
      ToggleButtons(
        children: buildOptions(),
        isSelected: _provider.isSelected,
        onPressed: _provider.changeSelected,
      )
    ]);
  }

  List<Widget> buildOptions() => options.keys
      .map((option) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(option),
          ))
      .toList();
}
