import 'package:http/retry.dart';
import 'package:http/http.dart' as http;

import 'package:http/http.dart' as http;

Future<http.Response> authInterceptor(http.Request request) async {
  final authToken = 'YOUR_AUTH_TOKEN_HERE';
  request.headers['Authorization'] = 'Bearer $authToken';
  return await http.Response.fromStream(await request.send());
}

RetryClient Api() {
  return RetryClient(
    http.Client(),
    retries: 2,
    when: (response) {
      return response.statusCode == 401;
    },
    onRetry: (req, res, retryCount) async {
      print('onRetry');
      print('retryCount $retryCount');
    },
  );
}
