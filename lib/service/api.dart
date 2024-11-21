import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:tesi/model/api/check.dart';
import 'package:http_parser/http_parser.dart';
import 'package:tesi/model/course.dart';
import 'package:tesi/model/leaderboard.dart';
import 'package:tesi/model/message.dart';
import 'package:tesi/model/multiple_choice.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8080';

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

  static Future<Message> getExplain(File pdfFile, String highlight) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/ai/explain"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'appunti',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    request.fields['highlight'] = highlight;

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);
      return Message.fromJson(body);
    } else {
      throw Exception("Errore nella richiesta: ${response.statusCode}");
    }
  }

  static Future<List<MultipleChoice>> genQuiz(File pdfFile) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/ai/genQuizPdf"),
    );

    request.headers['Authorization'] = 'Bearer $token';

    request.files.add(
      await http.MultipartFile.fromPath(
        'appunti',
        pdfFile.path,
        contentType: MediaType('application', 'pdf'),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseBody = await response.stream.bytesToString();
      var body = jsonDecode(responseBody);
      List<dynamic> bodyList = body as List<dynamic>;
      List<MultipleChoice> multipleChoices = bodyList
          .map((dynamic item) => MultipleChoice.fromJson(item))
          .toList();
      return multipleChoices;
    } else {
      throw Exception("Errore nella richiesta: ${response.statusCode}");
    }
  }

  static Future<void> closeChat() async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    await http.post(
      Uri.parse("$baseUrl/ai/closeChat"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    return;
  }

  static Future<Message> chatCourse(Course course, String domanda) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();

    var response = await http.post(
      Uri.parse("$baseUrl/ai/chatCourse"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "course_id": course.id.toString(),
        "domanda": domanda,
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Message.fromJson(body);
    } else {
      throw "Errore nella chat.";
    }
  }

  static Future<Message> chat(String domanda) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.post(
      Uri.parse("$baseUrl/ai/chat"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "domanda": domanda,
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      return Message.fromJson(body);
    } else {
      throw "Errore nella chat.";
    }
  }

  static Future<bool> uploadPoints(int points, Course course) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.post(
      Uri.parse("$baseUrl/courses/leaderboard"),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "points": points.toString(),
        "course_id": course.id.toString(),
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      throw "Errore nel caricamento dei punti.";
    }
  }

  static Future<List<Leaderboard>> getLeaderboard(Course course) async {
    String? token = await FirebaseAuth.instance.currentUser?.getIdToken();
    var response = await http.get(
      Uri.parse("$baseUrl/courses/leaderboard/${course.id}"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var body = jsonDecode(response.body);
      List<dynamic> bodyList = body as List<dynamic>;
      List<Leaderboard> leaderboard =
          bodyList.map((dynamic item) => Leaderboard.fromJson(item)).toList();
      return leaderboard;
    } else {
      throw "Errore nel recupero della classifica.";
    }
  }
}
