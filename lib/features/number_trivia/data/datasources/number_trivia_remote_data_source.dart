import 'dart:convert';

import 'package:clean_arch_tutorial/core/error/exceptions.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

const HTTP_STATUS_SUCCESS = 200;

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({@required this.httpClient});
  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) =>
      _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() =>
      _getTriviaFromUrl('http://numbersapi.com/random');

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await httpClient
        .get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode != HTTP_STATUS_SUCCESS) {
      throw ServerException();
    } else {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }
  }
}
