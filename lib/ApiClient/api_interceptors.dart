// import 'dart:io' show Platform;
//
// import 'package:dio/dio.dart';
// import 'package:hooks_riverpod/hooks_riverpod.dart';
//
// import 'api.dart';
//
// class ApiInterceptors extends InterceptorsWrapper {
//   final Ref ref;
//
//   ApiInterceptors(this.ref);
//
//   @override
//   Future onError(DioError err, ErrorInterceptorHandler handler) async {
//     NetworkExceptions networkException = NetworkExceptions.getDioException(err);
//     if (networkException.networkException == NetworkException.unauthorisedRequest) {
//       ref.invalidate(dioProvider);
//     }
//     handler.next(err);
//   }
//
//   @override
//   void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
//     if (Platform.isAndroid) {
//       options.headers['User-Agent'] = 'android';
//     } else if (Platform.isIOS) {
//       options.headers['User-Agent'] = 'ios';
//     }
//     handler.next(options);
//   }
// }
