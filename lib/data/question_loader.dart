import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/question.dart';

class QuestionLoader {
  static Future<List<Question>> loadQuestions(String category) async {
    try {
      final String response = await rootBundle.loadString('assets/questions/$category.json');
      final data = await json.decode(response);
      
      List<Question> questions = (data['questions'] as List)
          .map((q) => Question.fromJson(q))
          .toList();
      
      questions.shuffle();
      
      return questions.take(20).toList();
    } catch (e) {
      // Error loading questions
      return [];
    }
  }
}
