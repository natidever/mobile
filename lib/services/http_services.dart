import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

// const BASE_URL = 'http://192.168.137.74:8000/';

const BASE_URL = 'http://10.0.2.2:8000/';

final tokenBox = GetStorage();

var accessToken = tokenBox.read('accessToken');
var refreshToken = tokenBox.read('refreshToken');

class HttpServices {
  Dio dio = Dio();

  Future<Response> postRequest(String url, dynamic data) async {
    final response;
    try {
      response = dio.post(url, data: data);
      return response;
    } on DioException catch (e) {
      print('Error on post method$e');
      throw Exception(e);
    }
  }

  Future<Response> getRequest(String url, {dynamic data}) async {
    final response;
    try {
      response = dio.get(url, data: data);
      return response;
    } on DioException catch (e) {
      print('Error on get method$e');
      throw Exception(e);
    }
  }

  Future<Response> patchRequest(String url, dynamic data) async {
    final response;
    try {
      response = dio.patch(url, data: data);
      return response;
    } on DioException catch (e) {
      print('Error on patch method$e');
      throw Exception(e);
    }
  }

  Future<String> getNewAccessToken(String tokenRefresh) {
    final response;
    try {
      response = postRequest('/user/api/token/refresh/', tokenRefresh);

      return response;
    } on DioException catch (e) {
      print('Error on patch method$e');
      throw Exception(e);
    }
  }

  void init() {
    dio = Dio(BaseOptions(
      baseUrl: BASE_URL,
    ));
  }

  void initAuthenticated() {
    dio.options.baseUrl = BASE_URL;
    dio.options.headers["Authorization"] = "Bearer $accessToken";

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = "Bearer $accessToken";
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          print(error);
          String newAcessToken = await getNewAccessToken(refreshToken);
          error.requestOptions.headers["Authorization"] = newAcessToken;

          return handler.resolve(await dio.fetch(error.requestOptions));
        }
      },
    ));
  }
}
