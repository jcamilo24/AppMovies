import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_failure.freezed.dart';

@freezed
class SignInFailure with _$SignInFailure {
  factory SignInFailure.NotFound() = SignInFailureNotFound;
  factory SignInFailure.NotVerified() = SignInFailureNotVerified;
  factory SignInFailure.Network() = SignInFailureNetwork;
  factory SignInFailure.Unauthorized() = SignInFailureUnauthorized;
  factory SignInFailure.Unknown() = SignInFailureUnknown;
}
