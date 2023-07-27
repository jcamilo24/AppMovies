import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../domain/either/either.dart';
import '../../../../../../domain/enums.dart';
import '../../../../../../domain/failures/http_request/http_request_failure.dart';
import '../../../../../../domain/models/media/media.dart';
import '../../../../../../domain/repositories/trending_repository.dart';
import '../../../../../global/widgets/request_failed.dart';
import 'trending_tile.dart';
import 'trending_timewindow.dart';

typedef ListMedia = Either<HttpRequestFailure, List<Media>>;

class TrendingList extends StatefulWidget {
  const TrendingList({super.key});

  @override
  State<TrendingList> createState() => _TrendingListState();
}

class _TrendingListState extends State<TrendingList> {
  TrendingRepository get _repository => context.read();
  late Future<ListMedia> _future;
  TimeWindow _timeWindow = TimeWindow.day;

  @override
  void initState() {
    super.initState();

    _future = _repository.getMoviesAndSeries(_timeWindow);
  }

  void _updateFuture(TimeWindow timeWindow) {
    setState(() {
      _timeWindow = timeWindow;
      _future = _repository.getMoviesAndSeries(_timeWindow);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TrendingTimeWindow(
          timeWindow: _timeWindow,
          onChanged: _updateFuture,
        ),
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
            aspectRatio: 16 / 8,
            child: LayoutBuilder(
              builder: (_, constraints) {
                final width = constraints.maxHeight * 0.65;
                return Center(
                  child: FutureBuilder<ListMedia>(
                    key: ValueKey(_future),
                    future: _future,
                    builder: (_, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      return snapshot.data!.when(
                        left: (failure) => RequestFailed(
                          onRetry: () {
                            _updateFuture(_timeWindow);
                          },
                        ),
                        right: (list) {
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (_, index) {
                              final media = list[index];
                              return TrendingTile(
                                media: media,
                                widht: width,
                              );
                            },
                            itemCount: list.length,
                            separatorBuilder: (_, __) => const SizedBox(
                              width: 10,
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              },
            )),
      ],
    );
  }
}
