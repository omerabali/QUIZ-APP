import 'package:flutter/material.dart';
import '../data/question_loader.dart';
import './quiz_screen.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final String categoryName;

  final String categoryKey;
  final Color accentColor;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.categoryName,
    required this.categoryKey,
    required this.accentColor,
  });

  void _restartQuiz(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final questions = await QuestionLoader.loadQuestions(categoryKey);
    
    if (context.mounted) {
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            questions: questions,
            categoryName: categoryName,
            categoryKey: categoryKey,
            accentColor: accentColor,
          ),
        ),
      );
    }
  }

  String get _performanceMessage {
    if (score <= 7) return "Daha fazla çalışman gerekiyor 📚";
    if (score <= 14) return "İyi iş! Biraz daha pratik yap 👍";
    return "Mükemmel! Harika bir performans 🏆";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.stars_rounded,
                  size: 80,
                  color: Colors.blue,
                ),
                const SizedBox(height: 24),
                const Text(
                  "Quiz Tamamlandı!",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Tebrikler, tüm soruları yanıtladınız.",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 40),
                
                Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue.shade50,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withValues(alpha: 0.1),
                        blurRadius: 20,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        "${score * 5}",
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const Text(
                        "Toplam Puan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                Text(
                  "Doğru Sayısı: $score / $totalQuestions",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                
                const SizedBox(height: 32),
                Text(
                  _performanceMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                
                const SizedBox(height: 48),
                
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => _restartQuiz(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      "Yeniden Başla",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: TextButton(
                    onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey.shade600,
                    ),
                    child: const Text(
                      "Ana Menü",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
