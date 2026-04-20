import 'package:flutter/material.dart';
import '../data/question_loader.dart';
import './quiz_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          "Quiz Uygulaması",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Hoş Geldin!",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Bir kategori seçin ve bilginizi test edin.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 32),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _CategoryCard(
                  title: "Java",
                  icon: "☕",
                  color: const Color(0xFFE65100),
                  onTap: () => _startQuiz(context, "java", "Java", const Color(0xFFE65100)),
                ),
                _CategoryCard(
                  title: "Flutter",
                  icon: "💙",
                  color: const Color(0xFF1565C0),
                  onTap: () => _startQuiz(context, "flutter", "Flutter", const Color(0xFF1565C0)),
                ),
                _CategoryCard(
                  title: "Python",
                  icon: "🐍",
                  color: const Color(0xFF2E7D32),
                  onTap: () => _startQuiz(context, "python", "Python", const Color(0xFF2E7D32)),
                ),
                _CategoryCard(
                  title: "React",
                  icon: "⚛️",
                  color: const Color(0xFF00838F),
                  onTap: () => _startQuiz(context, "react", "React", const Color(0xFF00838F)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startQuiz(BuildContext context, String categoryKey, String categoryName, Color color) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    final questions = await QuestionLoader.loadQuestions(categoryKey);
    
    if (context.mounted) Navigator.pop(context);

    if (questions.isNotEmpty && context.mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => QuizScreen(
            questions: questions,
            categoryName: categoryName,
            categoryKey: categoryKey,
            accentColor: color,
          ),
        ),
      );
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sorular yüklenemedi!")),
        );
      }
    }
  }
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final String icon;
  final Color color;
  final VoidCallback onTap;

  const _CategoryCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: color.withValues(alpha: 0.1), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      icon,
                      style: const TextStyle(fontSize: 40),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
