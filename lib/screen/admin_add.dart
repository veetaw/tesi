import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:tesi/service/api.dart';

class AdminAddScreen extends StatelessWidget {
  final TextEditingController singleLineController = TextEditingController();
  final TextEditingController multiLineController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Add Screen'),
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: singleLineController,
              decoration: InputDecoration(
                labelText: 'Single Line Input',
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: multiLineController,
              decoration: InputDecoration(
                labelText: 'Multi Line Input',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                var response = await http.post(
                    Uri.parse(ApiService.baseUrl + "/ai/createCourse"),
                    body: {
                      "course_name": singleLineController.text,
                      "argomenti": multiLineController.text,
                    });

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text(response.statusCode.toString()),
                      content: Text(response.body),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('SEND'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AdminAddScreen(),
  ));
}
