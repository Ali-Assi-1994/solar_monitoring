import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'api.dart';

final dioProvider = Provider((ref) => ApiClient(ref));

class ApiClient {
  final Ref ref;

  ApiClient(this.ref) {
    initDio();
  }

  late Dio _dio;

  initDio() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost/',
      //FlavorConfig.instance!.baseUrl,
      contentType: 'application/json',
      followRedirects: false,
      validateStatus: (status) {
        return status == null ? false : status < 500;
      },
      headers: {
        Headers.acceptHeader: "application/json",
      },
    );

    _dio = Dio(options);
    if (kDebugMode) {
      void debugPrint(Object object) {
        assert(() {
          log(object.toString());
          return true;
        }());
      }

      _dio.interceptors.add(
        LogInterceptor(
          request: true,
          responseBody: true,
          responseHeader: true,
          requestBody: true,
          requestHeader: true,
          error: true,
          logPrint: debugPrint,
        ),
      );
    }
  }

  /// post methods is not used in this project, but added as an example
  Future<ApiResult> post({required String url, var data, StreamController<double>? uploadingStream, CancelToken? cancelToken}) async {
    try {
      final response = await _dio.post(_dio.options.baseUrl + url, data: data, onSendProgress: (rcv, total) {
        if (uploadingStream != null) {
          uploadingStream.sink.add((rcv / total));
        }
      }, cancelToken: cancelToken).timeout(const Duration(minutes: 15));
      if (response.statusCode == 200) {
        return ApiResult.successFromJson(response.data);
      } else {
        return ApiResult.failureFromJson(response.data);
      }
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getErrorMessage(e));
    }
  }

  Future<ApiResult> get({
    required String url,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await _dio
          .get(
            _dio.options.baseUrl + url,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: 15));
      if (response.statusCode == 200) {
        return ApiResult.successFromJson(response.data);
      } else {
        return ApiResult.failureFromJson(response.data);
      }
    } catch (e) {
      return ApiResult.failure(NetworkExceptions.getErrorMessage(e));
    }
  }
}
