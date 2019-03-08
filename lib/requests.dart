import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:wowsy/home.dart';

Future<MathFact> fetchFact(String number, String target) async {
  String url = '';

  print(target);
  if (target == 'trivia'){
    url = 'http://numbersapi.com/$number/';
  }
  else if (target == 'date'){
    url = 'http://numbersapi.com/$number/date';
  }
  else if (target == 'math'){
    url = 'http://numbersapi.com/$number/math';
  }
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return MathFact.fromJson(response.body.toString());
  } else {
    throw Exception('Failed to load fact');
  }
}

