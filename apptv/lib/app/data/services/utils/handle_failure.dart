import '../../../domain/either/either.dart';
import '../../../domain/failures/http_request/http_request_failure.dart';
import '../../http/http.dart';

Either<HttpRequestFailure, R> handleHttpFailure<R>(HttpFailure httpFailure) {
  final failure = () {
    final statusCode = httpFailure.statusCode;
    switch (statusCode) {
      case 404:
        return HttpRequestFailure.NotFound();
      case 401:
        return HttpRequestFailure.Unauthorized();
    }
    if (httpFailure.exception is NetworkException) {
      return HttpRequestFailure.Network();
    }
    return HttpRequestFailure.Unknown();
  }();
  return Either.left(failure);
}
