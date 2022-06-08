import 'package:flutter/material.dart';

class RankWidget extends StatelessWidget {
  final int rank;

  const RankWidget(this.rank, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        child: Column(
          children: [
            buildIcon(),
            const Text(
              'Rank',
              style: TextStyle(color: Colors.white),
            )
          ],
        ));
  }

  Color getRankingColor() {
    switch (rank) {
      case 1:
        return Colors.yellow;
      case 2:
        return Colors.grey;
      default:
        return Colors.brown;
    }
  }

  Widget buildTopIcon() => Icon(
        Icons.emoji_events,
        size: 64.0,
        color: getRankingColor(),
      );

  Widget buildOtherIcon() => Column(children: [
        const Icon(
          Icons.military_tech,
          size: 64.0,
          color: Colors.teal,
        ),
        Text('$rank')
      ]);

  Widget buildIcon() => rank > 3 ? buildOtherIcon() : buildTopIcon();
}
