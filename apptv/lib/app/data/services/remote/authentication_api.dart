import '../../../domain/either/either.dart';
import '../../../domain/failures/sign_in/sign_in_failure.dart';
import '../../http/http.dart';

class AuthenticationApi {
  AuthenticationApi(this._http);

  final Http _http;

  Either<SignInFailure, String> _handleFailure(HttpFailure failure) {
    if (failure.statusCode != null) {
      switch (failure.statusCode!) {
        case 401:
          if (failure.data is Map &&
              (failure.data as Map)['status_code'] == 32) {
            return Either.left(SignInFailure.NotVerified());
          }
          return Either.left(SignInFailure.Unauthorized());
        case 404:
          return Either.left(SignInFailure.NotFound());
        default:
          return Either.left(SignInFailure.Unknown());
      }
    }
    if (failure.exception is NetworkException) {
      return Either.left(SignInFailure.Network());
    }
    return Either.left(SignInFailure.Unknown());
  }

  Future<Either<SignInFailure, String>> createRequestToken() async {
    final result = await _http.request(
      '/authentication/token/new',
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );

    return result.when(
      left: _handleFailure,
      right: (requestToken) => Either.right(requestToken),
    );
  }

  Future<Either<SignInFailure, String>> CreateSessionWithLogin({
    required String username,
    required String password,
    required String requestToken,
  }) async {
    final result = await _http.request(
      '/authentication/token/validate_with_login',
      method: HttpMethod.post,
      body: {
        'username': username,
        'password': password,
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['request_token'] as String;
      },
    );

    return result.when(
      left: _handleFailure,
      right: (newRequestToken) => Either.right(newRequestToken),
    );
  }

  Future<Either<SignInFailure, String>> CreateSession(
      String requestToken) async {
    final result = await _http.request(
      '/authentication/session/new',
      method: HttpMethod.post,
      body: {
        'request_token': requestToken,
      },
      onSuccess: (responseBody) {
        final json = responseBody as Map;
        return json['session_id'] as String;
      },
    );

    return result.when(
      left: _handleFailure,
      right: (sessionId) => Either.right(sessionId),
    );
  }
}
