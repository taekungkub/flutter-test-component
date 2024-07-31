import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_infinite_scroll/services/Api.dart';
import 'package:flutter_infinite_scroll/services/ApiDio.dart';
import 'package:http/http.dart' as http;

class FakeApi {
  final dio = Dio();

  Future getBeerList(page, size) async {
    try {
      var response = await dio.get(
          'https://jsonplaceholder.typicode.com/posts?_limit=${size}&_page=${page}');
      if (response.statusCode == 200) {
        print(jsonDecode(response.data));
        return jsonDecode(response.data);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future getPokemon(offset, limit) async {
    try {
      var response = await ApiService()
          .dio
          .get('/pokemon?limit=${limit}&offset=${offset}');
      if (response.statusCode == 200) {
        final result = response.data;
        return result['results'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future postPokemon(offset, limit) async {
    try {
      var response = await ApiService().dio.post(
        '/pokemon?limit=${limit}&offset=${offset}',
        data: {'id': 12, 'name': 'dio'},
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return result['results'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future getPokemonParams(offset, limit) async {
    try {
      var response = await ApiService().dio.get(
        '/pokemon?limit=${limit}&offset=${offset}',
        queryParameters: {'id': 12, 'name': 'dio'},
      );
      if (response.statusCode == 200) {
        final result = response.data;
        return result['results'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }

  Future postPokemonFormData() async {
    try {
      var formData = FormData.fromMap({
        'name': 'wendux',
        'age': 25,
        'file':
            await MultipartFile.fromFile('./text.txt', filename: 'upload.txt')
      });

      var response =
          await ApiService().dio.post('/pokemon?limit', data: formData);

      if (response.statusCode == 200) {
        final result = response.data;
        return result['results'];
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Failed to load data');
    }
  }
}
