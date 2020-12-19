import 'dart:convert';

import 'package:clean_arch_tutorial/core/error/exceptions.dart';
import 'package:clean_arch_tutorial/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:clean_arch_tutorial/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImpl dataSources;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = MockHttpClient();
    dataSources = NumberTriviaRemoteDataSourceImpl(httpClient: httpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async =>
            http.Response(fixture('trivia.json'), HTTP_STATUS_SUCCESS));
  }

  void setUpMockHttpClientFailure() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('fixture(trivia.json)', 404));
  }

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess();
      //act
      await dataSources.getConcreteNumberTrivia(tNumber);
      //assert
      verify(httpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return NumberTrivia when the response code 200 (success)''',
        () async {
      //arrange
      setUpMockHttpClientSuccess();
      //act
      final result = await dataSources.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        '''should throw a ServerException when the response code is 404 or other''',
        () async {
      //arrange
      setUpMockHttpClientFailure();
      //act
      final call = dataSources.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));
    test('''should perform a GET request on a URL with number 
        being the endpoint and with application/json header''', () async {
      //arrange
      setUpMockHttpClientSuccess();
      //act
      await dataSources.getRandomNumberTrivia();
      //assert
      verify(httpClient.get('http://numbersapi.com/random',
          headers: {'Content-Type': 'application/json'}));
    });

    test('''should return NumberTrivia when the response code 200 (success)''',
        () async {
      //arrange
      setUpMockHttpClientSuccess();
      //act
      final result = await dataSources.getRandomNumberTrivia();
      //assert
      expect(result, equals(tNumberTriviaModel));
    });

    test(
        '''should throw a ServerException when the response code is 404 or other''',
        () async {
      //arrange
      setUpMockHttpClientFailure();
      //act
      final call = dataSources.getRandomNumberTrivia();
      //assert
      expect(() => call, throwsA(isA<ServerException>()));
    });
  });
}
