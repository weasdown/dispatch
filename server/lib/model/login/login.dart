/// Simple data class to hold login request data.
class LoginRequest {
  const LoginRequest({required this.email, required this.password});

  factory LoginRequest.fromJson(Map<String, dynamic> json) => switch (json) {
    {'email': String email, 'password': String password} => LoginRequest(
      email: email,
      password: password,
    ),
    _ => throw const FormatException('Failed to parse login request.'),
  };

  /// Email address.
  final String email;

  /// Plain text password.
  final String password;
}

/// LoginResponse model.
class LoginResponse {
  const LoginResponse({
    /// The token to be used for authentication.
    required this.token,

    /// The user's unique ESR number'.
    required this.esr,
  });

  final int esr;
  final String token;

  factory LoginResponse.fromJson(Map<String, dynamic> json) => switch (json) {
    {'token': String token, 'userId': int esr} => LoginResponse(
      token: token,
      esr: esr,
    ),
    _ => throw const FormatException('Failed to parse login response.'),
  };

  Map<String, dynamic> toJson() => {'token': token, 'esr': esr};
}
