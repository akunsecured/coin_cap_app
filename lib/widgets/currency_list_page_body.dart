import 'package:coin_cap_app/providers/currency_list_provider.dart';
import 'package:coin_cap_app/utils/constants.dart';
import 'package:coin_cap_app/widgets/currency_data_table.dart';
import 'package:coin_cap_app/widgets/error_text.dart';
import 'package:coin_cap_app/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'rounded_button.dart';

class CurrencyListPageBody extends StatelessWidget {
  const CurrencyListPageBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CurrencyListProvider>();

    if (provider.error != null) {
      return ErrorText(provider.error);
    }

    if (provider.isLoading) {
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
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: const CurrencyDataTable(),
              ),
            ),
          ),
          !provider.isMaxLoaded()
              ? Container(
                  margin: const EdgeInsets.symmetric(
                      vertical: Constants.buttonVerticalMargin),
                  height:
                      !provider.isLoadingMore ? Constants.buttonHeight : null,
                  width: !provider.isLoadingMore ? Constants.buttonWidth : null,
                  child: provider.isLoadingMore
                      ? const CircularProgressIndicator()
                      : RoundedButton(
                          text: 'Show more',
                          onTap: () => provider.loadMore(),
                        ))
              : const SizedBox()
        ],
      )),
    );
  }
}
