import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/perfomers/performer.dart';
import '../../../../../../domain/repositories/trending_repository.dart';
import '../../../../../global/widgets/request_failed.dart';
import 'performer_tile.dart';

typedef EitherListPerfomer = Either<HttpRequestFailure, List<Performer>>;

class TrendingPerformers extends StatefulWidget {
  const TrendingPerformers({super.key});

  @override
  State<TrendingPerformers> createState() => _TrendingPerformersState();
}

class _TrendingPerformersState extends State<TrendingPerformers> {
  late Future<EitherListPerfomer> _future;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _future = context.read<TrendingRepository>().getPerformers();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FutureBuilder<EitherListPerfomer>(
        key: ValueKey(_future),
        future: _future,
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return snapshot.data!.when(
            left: (_) => RequestFailed(onRetry: () {
              setState(() {
                _future = context.read<TrendingRepository>().getPerformers();
              });
            }),
            right: (list) => Stack(
              alignment: Alignment.bottomCenter,
              children: [
                PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    final performer = list[index];
                    return PerformerTile(performer: performer);
                  },
                ),
                Positioned(
                  bottom: 30,
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (_, __) {
                      final int currentCard =
                          _pageController.page?.toInt() ?? 0;
                      return Row(
                        children: List.generate(
                          list.length,
                          (index) => Icon(
                            Icons.circle,
                            size: 14,
                            color: currentCard == index
                                ? Colors.blue
                                : Colors.white30,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
