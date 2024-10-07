import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// Using Dio for api services and adding some settings related to Dio here
// it is core of the api services
class ApiService {
  static final ApiService _instance = ApiService._internal();

  final Dio _dio = Dio();
  final Duration timeOut = const Duration(seconds: 60);

  factory ApiService() {
    return _instance;
  }

  ApiService._internal() {
    // Pretty Dio logger is a Dio interceptor that logs network calls in a pretty, easy to read format.
    _dio.interceptors.add(PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 120,
    ));
  }

  Dio get dio => _dio;
}
