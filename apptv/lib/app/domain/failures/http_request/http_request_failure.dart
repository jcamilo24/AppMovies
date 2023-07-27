import 'package:freezed_annotation/freezed_annotation.dart';

part 'http_request_failure.freezed.dart';

@freezed
class HttpRequestFailure with _$HttpRequestFailure {
  factory HttpRequestFailure.NotFound() = HttpRequestFailureNotFound;
  factory HttpRequestFailure.Network() = HttpRequestFailureNetwork;
  factory HttpRequestFailure.Unauthorized() = HttpRequestFailureUnathorized;
  factory HttpRequestFailure.Unknown() = HttpRequestFailureUnknown;
}
