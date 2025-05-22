class RecoverResponse {
  final String message;

  RecoverResponse({required this.message});

  factory RecoverResponse.fromMap(Map<String, dynamic> map) {
    return RecoverResponse(
      message: map['message'] as String,
    );
  }
}
