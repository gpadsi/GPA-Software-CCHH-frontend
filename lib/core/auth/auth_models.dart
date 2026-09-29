import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_models.freezed.dart';
part 'auth_models.g.dart';

@freezed
abstract class TokenPair with _$TokenPair {
  const factory TokenPair({required String access, required String refresh}) =
      _TokenPair;
  factory TokenPair.fromJson(Map<String, dynamic> json) =>
      _$TokenPairFromJson(json);
}

@freezed
abstract class RefreshResponse with _$RefreshResponse {
  const factory RefreshResponse({required String access, String? refresh}) =
      _RefreshResponse;
  factory RefreshResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshResponseFromJson(json);
}

@freezed
abstract class SessionUser with _$SessionUser {
  const SessionUser._();
  const factory SessionUser({
    required String id,
    required String username,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'is_active') required bool isActive,
  }) = _SessionUser;
  factory SessionUser.fromJson(Map<String, dynamic> json) =>
      _$SessionUserFromJson(json);
  String get displayName {
    final name = '$firstName $lastName'.trim();
    return name.isEmpty ? username : name;
  }
}

enum SessionStatus { restoring, signedOut, signedIn, unavailable }

@freezed
abstract class SessionState with _$SessionState {
  const factory SessionState({
    @Default(SessionStatus.restoring) SessionStatus status,
    SessionUser? user,
    @Default(false) bool isSubmitting,
    String? message,
  }) = _SessionState;
}
