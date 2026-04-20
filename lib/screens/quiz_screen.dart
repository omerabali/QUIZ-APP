import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../widgets/option_button.dart';
import '../widgets/timer_widget.dart';
import './result_screen.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String categoryName;
  final String categoryKey;
  final Color accentColor;

  const QuizScreen({
    super.key,
    required this.questions,
    required this.categoryName,
    required this.categoryKey,
    required this.accentColor,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestionIndex = 0;
  int _score = 0;
  int? _selectedAnswer;
  int _timeLeft = 15;
  bool _isAnswered = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timeLeft = 15;
      _isAnswered = false;
      _selectedAnswer = null;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _handleTimeUp();
      }
    });
  }

  void _handleTimeUp() {
    _timer?.cancel();
    setState(() {
      _isAnswered = true;
    });
    _proceedToNext();
  }

  void _handleAnswerSelection(int index) {
    if (_isAnswered) return;

    _timer?.cancel();
    setState(() {
      _selectedAnswer = index;
      _isAnswered = true;
      if (index == widget.questions[_currentQuestionIndex].correctAnswer) {
        _score++;
      }
    });

    _proceedToNext();
  }

  void _proceedToNext() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted) return;
      
      if (_currentQuestionIndex < widget.questions.length - 1) {
        setState(() {
          _currentQuestionIndex++;
        });
        _startTimer();
      } else {
        _showResults();
      }
    });
  }

  void _showResults() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          score: _score,
          totalQuestions: widget.questions.length,
          categoryName: widget.categoryName,
          categoryKey: widget.categoryKey,
          accentColor: widget.accentColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.questions[_currentQuestionIndex];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "Puan: ${_score * 5}",
                  style: TextStyle(
                    color: widget.accentColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Soru ${_currentQuestionIndex + 1}/${widget.questions.length}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 4,
                        width: 100,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: (_currentQuestionIndex + 1) / widget.questions.length,
                          child: Container(
                            decoration: BoxDecoration(
                              color: widget.accentColor,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TimerWidget(timeLeft: _timeLeft),
              const SizedBox(height: 40),
              
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: SingleChildScrollView(
                    key: ValueKey<int>(_currentQuestionIndex),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question.question,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 32),
                        ...List.generate(question.options.length, (index) {
                          final option = question.options[index];
                          return OptionButton(
                            optionText: option,
                            isSelected: _selectedAnswer == index,
                            isCorrect: index == question.correctAnswer,
                            isAnswered: _isAnswered,
                            accentColor: widget.accentColor,
                            onTap: () => _handleAnswerSelection(index),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
