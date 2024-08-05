import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

final dio = Dio();

void getHttp() async {
  final response = await dio.get('https://dart.dev');
  print(response);
}

class ApiService {
  bool isRefreshing = false;
  Completer<void>? completer;

  bool isStartRefresh = false;

  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://pokeapi.co/api/v2',
    connectTimeout: Duration(seconds: 5), // Connection timeout
    receiveTimeout: Duration(seconds: 5), // Receive timeout
    headers: {
      'Content-Type': 'application/json',
    },
  ));

  // Singleton pattern to reuse the same instance
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  Future<void> fakeRefreshToken() async {
    isStartRefresh = true;
    const duration = Duration(seconds: 10);
    var remaining = duration;
    var timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remaining = remaining - const Duration(seconds: 1);
      print('delaying for ${remaining.inSeconds} sec');
      if (remaining <= Duration.zero) {
        timer.cancel();
      }
    });

    await Future.delayed(Duration(seconds: 10));

    await Future.delayed(Duration(seconds: 2));
    print('Refreshing Success!!!');

    isStartRefresh = false;
    // await Future.delayed(Duration(seconds: 3));
  }

  ApiService._internal() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        // try {

        //   // Check if the token is about to expire
        //   if (await _isTokenExpiring() && !isRefreshing) {
        //     isRefreshing = true;
        //     completer = Completer<void>();
        //     await _refreshToken();
        //     isRefreshing = false;
        //     completer?.complete();

        //     if (isRefreshing) {
        //       // Already refreshing access token, waiting for it to complete.
        //       await completer?.future;
        //     }
        //   }
        // } catch (e) {
        //   return handler.reject(
        //       DioException(requestOptions: options)); // Reject the request
        // }

        // stagging
        // Check if the token is about to expire
        if (await _isTokenExpiring() && isStartRefresh == false) {
          if (!isRefreshing) {
            isRefreshing = true;
            completer = Completer<void>();
            try {
              print('Refreshing token...');
              // await fakeRefreshToken(); // ถ้าอยากให้รอ refres ให้เพิ่ม await
              fakeRefreshToken();

              completer?.complete();
            } catch (e) {
              // handle logout or other error handling
              completer?.completeError(e);
              print('Logout !!!!!!');

              return Future.error('Refresh token error: $e');
            } finally {
              isRefreshing = false;
            }
          } else {
            // Already refreshing access token, waiting for it to complete.
            print(
                "Already refreshing access token, waiting for it to complete.");
          }

          // Wait for the refresh token process to complete
          await completer?.future;
        }

        return handler.next(options); // Continue
      },
      onResponse: (response, handler) async {
        return handler.next(response);
      },
      onError: (DioException error, handler) async {
        return handler.next(error); // Continue with the error
      },
    ));
  }

  Dio get dio => _dio;

  Future<bool> _isTokenExpiring() async {
    final token = await GetStorage().read('access_token');
    if (token == null) return true;

    final parts = token.split('.');
    if (parts.length != 3) return true;

    final payload =
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    final Map<String, dynamic> payloadMap = json.decode(payload);

    if (!payloadMap.containsKey('exp')) return true;

    final expiry =
        DateTime.fromMillisecondsSinceEpoch(payloadMap['exp'] * 1000);
    final now = DateTime.now();
    final difference = expiry.difference(now).inMinutes;

    // Check if the token expires in less than 5 minutes
    return difference < 5;
  }

  Future<void> _refreshToken() async {
    try {
      final refreshToken = await GetStorage().read('refresh_token');
      if (refreshToken == null) throw Exception('No refresh token available');

      final response = await _dio.post('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      if (response.statusCode == 200) {
        await GetStorage().write('access_token', response.data['access_token']);
        await GetStorage()
            .write('refresh_token', response.data['refresh_token']);
      } else {
        throw Exception('Failed to refresh token');
      }
    } catch (e) {
      throw Exception('Token refresh error: $e');
    }
  }
}
