import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Vachanas from Lingayat saints
  final List<Map<String, dynamic>> vachanas = const [
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
    {
      "message": "Doing something without purpose is just wasting time. Know why you do things.",
      "author": "Anonymous",
      "timestamp": "Life Message",
      "isImportant": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange[50]!, Colors.white],
          ),
        ),
        child: Column(
          children: [
            // Header banner


            // Vachanas list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: vachanas.length,
                itemBuilder: (context, index) {
                  final vachana = vachanas[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 20.0),
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: vachana['isImportant']
                          ? BorderSide(color: Colors.deepOrange[400]!, width: 2)
                          : BorderSide(color: Colors.grey[300]!),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: vachana['isImportant']
                              ? [Colors.orange[50]!, Colors.white]
                              : [Colors.white, Colors.grey[50]!],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Om symbol and important badge
                            Row(
                              children: [
                                Text(
                                  '',
                                  style: TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 8),
                                if (vachana['isImportant'])
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.deepOrange[100],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.deepOrange[900],
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            // Vachana content
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.orange[200]!),
                              ),
                              child: Text(
                                vachana['message'],
                                style: const TextStyle(
                                  fontSize: 15,
                                  height: 1.8,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Author attribution
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.person,
                                      size: 18,
                                      color: Colors.deepOrange[700],
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      '- ${vachana['author']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.deepOrange[800],
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
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