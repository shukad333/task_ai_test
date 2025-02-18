import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(TaskApp());
}

class TaskApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TaskScreen(),
    );
  }
}

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final TextEditingController _taskController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();
  final TextEditingController _importanceController = TextEditingController();
  List<String> prioritizedTasks = [];

  Future<void> prioritizeTasks() async {
    final url = Uri.parse('http://your-api-url/prioritize_tasks');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'tasks': [_taskController.text],
        'deadlines': [_deadlineController.text],
        'importance': [int.parse(_importanceController.text)],
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        prioritizedTasks = List<String>.from(data['prioritized_tasks']);
      });
    } else {
      print('Error: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Task Prioritization')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _taskController, decoration: InputDecoration(labelText: 'Task')),
            TextField(controller: _deadlineController, decoration: InputDecoration(labelText: 'Deadline')),
            TextField(controller: _importanceController, decoration: InputDecoration(labelText: 'Importance (1-5)')),
            SizedBox(height: 20),
            ElevatedButton(onPressed: prioritizeTasks, child: Text('Prioritize')),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: prioritizedTasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(prioritizedTasks[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
