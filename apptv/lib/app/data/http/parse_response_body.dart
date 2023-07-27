part of 'http.dart';

dynamic _parseResponseBody(String responseBody) {
  try {
    return jsonDecode(responseBody);
  } catch (e) {
    return responseBody;
  }
}
