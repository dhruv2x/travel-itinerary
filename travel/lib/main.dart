import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGPTPage extends StatefulWidget {
  @override
  _ChatGPTPageState createState() => _ChatGPTPageState();
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();

  String _response = '';

  Future<String> sendMessageToChatGpt(
      String destination, String duration) async {
    Uri uri = Uri.parse(
        "https://travel-api-production-2908.up.railway.app/chatgpt_api");

    String message =
        "You are a trip planner. I'm travelling to $destination for $duration. Plan a day-by-day travel itinerary with famous locations and hotels. I'm a traveller, so suggest some unique destinations and tips. Also, suggest some great food along the way.";

    Map<String, dynamic> body = {
      "destination": destination,
      "duration": duration,
    };

    final response = await http.post(
      uri,
      headers: {
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    Map<String, dynamic> parsedResponse = json.decode(response.body);

    String reply = parsedResponse['event_description'];
    return reply;
  }

  void onSendMessage() {
    String destination = destinationController.text;
    String duration = durationController.text;

    if (destination.isEmpty || duration.isEmpty) {
      setState(() {
        _response = "Please provide both destination and duration.";
      });
      return;
    }

    destinationController.clear();
    durationController.clear();

    sendMessageToChatGpt(destination, duration).then((response) {
      setState(() {
        _response = response;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Let AI Plan Your Next Trip'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextField(
                controller: destinationController,
                decoration: InputDecoration(
                  labelText: 'Where? ex. Mumbai',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 16.0),
              TextField(
                controller: durationController,
                decoration: InputDecoration(
                  labelText: 'How long?  ex. 2 Day',
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: onSendMessage,
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                ),
                child: Text(
                  'Generate Travel Itinerary',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  'Note : AI will take 5-10 sec to think.',
                  style: TextStyle(
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                _response,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            AboutListTile(
              icon: Icon(Icons.info),
              child: Text('About'),
              applicationVersion: '1.0.0',
              applicationLegalese: '© 2023 Dhruv Chauhan',
              aboutBoxChildren: [
                Text(
                  'This app generates travel itineraries using AI.',
                ),
                Text(
                  'GitHub Repository',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Open your GitHub repository link here
                  },
                  child: Text(
                    'https://github.com/dhruv2x/travel-itinerary',
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ChatGPTPage(),
  ));
}
