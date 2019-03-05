import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wowsy/home.dart';

Future<MathFact> fetchFact(String number) async {
  final response =
  await http.get('http://numbersapi.com/$number');

  if (response.statusCode == 200) {
    return MathFact.fromJson(response.body.toString());
  } else {
    throw Exception('Failed to load fact');
  }
}
