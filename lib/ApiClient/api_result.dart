enum ApiResultType { success, failure }

class ApiResult<T> {
  ApiResultType type;
  T? data;
  String? message;

  ApiResult({required this.type, this.data, this.message});

  factory ApiResult.success(T? data) => ApiResult(type: ApiResultType.success, data: data);

  factory ApiResult.failure(String? errorMsg) => ApiResult(type: ApiResultType.failure, message: errorMsg);

  String get errorMessage => message ?? 'error';

  @override
  String toString() {
    return 'ApiResult :{ type: $type,  message: $message , ${data == null ? '' : 'data'} }';
  }
}
