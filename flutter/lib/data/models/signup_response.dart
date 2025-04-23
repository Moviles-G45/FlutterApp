class SignupResponse {
  final String message;

  SignupResponse({required this.message});

  factory SignupResponse.fromMap(Map<String, dynamic> map) {
    return SignupResponse(
      message: map['message'] as String,
    );
  }
}
