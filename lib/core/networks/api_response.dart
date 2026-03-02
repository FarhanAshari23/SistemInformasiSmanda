class ApiResponse<T> {
  final T? data;
  final String? message;
  final int statusCode;

  ApiResponse({
    required this.statusCode,
    this.data,
    this.message,
  });
}
