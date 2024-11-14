import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tesi/model/course.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

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
}
