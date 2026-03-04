import 'package:doctor_booking_app/core/testing/service.dart';
import 'package:flutter/material.dart';

class MessginTester extends StatefulWidget {
  const MessginTester({super.key});

  @override
  State<MessginTester> createState() => _MessginTesterState();
}

class _MessginTesterState extends State<MessginTester> {
  TextEditingController controller = TextEditingController();
  late final Service service;
  final List<String> logs = [];

  @override
  void initState() {
    super.initState();

    service = Service('ws://10.165.176.4:8090');

    service.stream.listen(
      (data) {
        setState(() {
          logs.insert(0, data.toString());
        });
      },
      onError: (error) {
        setState(() {
          logs.insert(0, 'Error: $error');
        });
      },
      onDone: () {
        setState(() {
          logs.insert(0, 'Connection closed');
        });
      },
    );
  }

  void sendMessage(String message) {
    final message = controller.text.trim();
    if (message.isEmpty) {
      return;
    }

    

    service.send(message);
    controller.clear();
  }

  @override
  void dispose() {
    super.dispose();
    service.close();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('WebSocket Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Type message',
                border: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue, width: 2),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          Colors.blue, // Set background color to blue
                    ),
                    onPressed: () => sendMessage(controller.text),
                    child: const Text('Send'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => service.send('get_service_data'),
                    child: const Text('Get Service Data'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  return Text(logs[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
