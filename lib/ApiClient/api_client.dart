import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:solar_monitoring/utils/widgets/app_snackbar.dart';

import 'api.dart';

final dioProvider = Provider((ref) => ApiClient(Dio()));

class ApiClient {
  Dio dio;

  ApiClient(this.dio) {
    initDio();
  }

  initDio() {
    BaseOptions options = BaseOptions(
      baseUrl: 'http://localhost:3000',
      contentType: 'application/json',
      followRedirects: false,
      validateStatus: (status) {
        return status == null ? false : status < 500;
      },
      headers: {
        Headers.acceptHeader: "application/json",
      },
    );

    dio = Dio(options);
    if (kDebugMode) {
      void debugPrint(Object object) {
        assert(() {
          log(object.toString());
          return true;
        }());
      }

      dio.interceptors.add(
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

  Future<ApiResult> get({
    required String url,
    Options? options,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) async {
    try {
      final response = await dio
          .get(
            dio.options.baseUrl + url,
            queryParameters: queryParameters,
            cancelToken: cancelToken,
          )
          .timeout(const Duration(seconds: 15));

      // Add debug logs
      // debugPrint('Response statusCode: ${response.statusCode}');
      // debugPrint('Response data: ${response.data}');

      if (response.statusCode == 200) {
        return ApiResult.success(response.data);
      } else {
        AppSnackBar().showSnackBar(text: response.statusMessage, color: Colors.red);
        return ApiResult.failure(response.statusMessage);
      }
    } catch (e) {
      String errorMsg = NetworkExceptions.getErrorMessage(e);
      AppSnackBar().showSnackBar(text: errorMsg, color: Colors.red);
      return ApiResult.failure(errorMsg);
    }
  }
}
