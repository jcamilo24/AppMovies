import '../../domain/either/either.dart';
import '../../domain/enums.dart';
import '../../domain/failures/http_request/http_request_failure.dart';
import '../../domain/models/media/media.dart';
import '../../domain/models/perfomers/performer.dart';
import '../../domain/repositories/trending_repository.dart';
import '../services/remote/trending_api.dart';

class TrendingRepositoryImpl implements TrendingRepository {
  TrendingRepositoryImpl(this._trendingApi);
  final TrendingApi _trendingApi;
  @override
  Future<Either<HttpRequestFailure, List<Media>>> getMoviesAndSeries(
    TimeWindow timeWindow,
  ) {
    return _trendingApi.getMoviesAndSeries(timeWindow);
  }

  @override
  Future<Either<HttpRequestFailure, List<Performer>>> getPerformers() {
    return _trendingApi.getPerformers(TimeWindow.day);
  }
}
