import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tesi/model/api/check.dart';
import 'package:tesi/model/course.dart';

class ApiService {
  static const String baseUrl = 'https://b709-5-91-173-217.ngrok-free.app';

  static Future<List<Course>> getAllCourses() async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.get(
      Uri.parse("$baseUrl/courses/corsi"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Course> courses =
          body.map((dynamic item) => Course.fromJson(item)).toList();
      return courses;
    } else {
      throw "Non sono riuscito a recuperare i corsi!";
    }
  }

  static Future<Course> getCourseData(Course course) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.get(
      Uri.parse("$baseUrl/courses/corso/${course.id}"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Course.fromJson(body);
    } else {
      throw "Non sono riuscito a recuperare le informazioni del corso.";
    }
  }

  static Future<Check> checkAnswer(String domanda, String risposta) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    var response = await http.post(
      Uri.parse("$baseUrl/ai/checkOQ"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        {
          'domanda': domanda,
          'risposta': risposta,
        },
      ),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Check.fromJson(body);
    } else {
      throw "Non sono riuscito a verificare la risposta.";
    }
  }
}
