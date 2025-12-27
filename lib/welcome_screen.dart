import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  // Vachanas from Lingayat saints
  final List<Map<String, dynamic>> vachanas = const [
    {
      'message': 'ಕಾಯವೇ ಕೈಲಾಸ ಕಾಯವೇ ಕೈಲಾಸ\nಕಾಯವೇ ಕೂಡಲಸಂಗಮದೇವನ ನಿವಾಸ\n\nThe body itself is Kailasa, the body itself is the abode of Kudalasangamadeva.',
      'author': 'ಬಸವಣ್ಣ (Basavanna)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': true,
    },
    {
      'message': 'ಉಳ್ಳವರು ಶಿವಾಲಯವ ಮಾಡುವರು, ನಾನೇನು ಮಾಡಲಿ ಬಡವನಯ್ಯಾ?\nಎನ್ನ ಕಾಲೇ ಕಂಬ, ದೇಹವೇ ದೇಗುಲ, ಶಿರವೇ ಹೊನ್ನ ಕಳಸವಯ್ಯಾ,\nಕೂಡಲಸಂಗಮದೇವಾ, ಕೇಳಯ್ಯಾ, ಸ್ಥಾವರಕ್ಕಳಿವುಂಟು, ಜಂಗಮಕ್ಕಳಿವಿಲ್ಲ.\n\nThe rich will make temples for Shiva. What shall I, a poor man, do? My legs are pillars, the body the shrine, the head a cupola of gold. Listen, O lord of the meeting rivers, things standing shall fall, but the moving ever shall stay.',
      'author': 'ಬಸವಣ್ಣ (Basavanna)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': true,
    },
    {
      'message': 'ಬಾಯಿ ಮುಚ್ಚಿದೆಯಾದರೆ ಶಿವಾರಾಧನೆಯಲ್ಲ,\nಮುಂಗೋಪವಿದ್ದರೆ ಶಿವಾರಾಧನೆಯಲ್ಲ,\nಅರಿವಿಲ್ಲದ ಪೂಜೆ ಶಿವಾರಾಧನೆಯಲ್ಲ.\n\nClosing the mouth is not worshipping Shiva,\nHaving anger is not worshipping Shiva,\nWorship without understanding is not worshipping Shiva.',
      'author': 'ಅಕ್ಕ ಮಹಾದೇವಿ (Akka Mahadevi)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': false,
    },
    {
      'message': 'ಕೈ ಬಳಲಿಕೊಂಡು ಊಟವೆಂಬುದಿಲ್ಲ,\nಕಾಲು ಬಳಲಿಕೊಂಡು ಚಲನವೆಂಬುದಿಲ್ಲ,\nಹಾಗೆಯೇ ಹೃದಯ ಬಳಲಿಕೊಂಡು ಭಕ್ತಿಯೆಂಬುದಿಲ್ಲ.\n\nUsing hands is not called eating,\nUsing legs is not called walking,\nSimilarly, using heart is not called devotion.',
      'author': 'ಅಲ್ಲಮ ಪ್ರಭು (Allama Prabhu)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': false,
    },
    {
      'message': 'ಕಲ್ಲು ಕರಗಿ ನೀರಾದರೆ ನಂಬುವೆನು,\nನೀರು ಹೆಪ್ಪಿ ಕಲ್ಲಾದರೆ ನಂಬುವೆನು,\nಆದರೆ ಜಂಗಮ ಲಿಂಗವೇ ಅರಿದೆನು.\n\nIf stone melts and becomes water, I will believe,\nIf water freezes and becomes stone, I will believe,\nBut I have known that the Jangama is the Linga.',
      'author': 'ಬಸವಣ್ಣ (Basavanna)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': true,
    },
    {
      'message': 'ಬೇಡದಿರು ಬೇಡದಿರು ಜನರ ಮುಂದೆ,\nಕೊಡದಿರು ಕೊಡದಿರು ಮರುಳ ಬುದ್ಧಿಯನು,\nಹುಡುಕಾಡು ಹುಡುಕಾಡು ಗುಹೇಶ್ವರನ ಪಾದವನು.\n\nDo not beg, do not beg before people,\nDo not give, do not give foolish advice,\nSearch, search for the feet of Guheshwara.',
      'author': 'ಚನ್ನಬಸವಣ್ಣ (Channabasavanna)',
      'timestamp': 'ಶರಣ ಸಂದೇಶ',
      'isImportant': false,
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
                                  '🕉️',
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
                                      'ಪ್ರಮುಖ',
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