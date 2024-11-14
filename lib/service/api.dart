import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tesi/model/api/check.dart';
import 'package:tesi/model/course.dart';

class ApiService {
  static const String baseUrl = 'https://b709-5-91-173-217.ngrok-free.app';

  static Future<List<Course>> getAllCourses() async {
    var response = await http.get(Uri.parse("$baseUrl/courses/corsi"));

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Course> courses =
          body.map((dynamic item) => Course.fromJson(item)).toList();
      return courses;
    } else {
      throw "Can't get courses.";
    }
  }

  static Future<Course> getCourseData(Course course) async {
    var response =
        await http.get(Uri.parse("$baseUrl/courses/corso/${course.id}"));

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Course.fromJson(body);
    } else {
      throw "Can't get course data.";
    }
  }

  static Future<Check> checkAnswer(String domanda, String risposta) async {
    var response = await http.post(
      Uri.parse("$baseUrl/ai/checkOQ"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'domanda': domanda,
        'risposta': risposta,
      }),
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Check.fromJson(body);
    } else {
      throw "Can't check answer.";
    }
  }
}
