import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../Models/Canvas/assignment.dart';
import '../../Models/Canvas/quiz.dart';
import '../../Models/Canvas/quiz_submission.dart';
import '../../Providers/http_provider.dart';

class QuizScreen extends StatefulWidget {
  final Assignment assignment;

  const QuizScreen({super.key, required this.assignment});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  bool _isLoading = true;
  Quiz? _quiz;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadQuizData();
  }

  Future<void> _loadQuizData() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      final response = await HttpProvider().get<Quiz>(
        'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}',
      );

      setState(() {
        _quiz = response.first;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load quiz: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  Future<void> _startQuiz() async {
    try {
      print("Starting quiz submission...");

      // First try to get existing submissions
      final existingSubmissions = await HttpProvider().getJson(
        'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/submissions',
      );

      print("Got existing submissions: $existingSubmissions");

      Map<String, dynamic>? quizSubmission;

      if (existingSubmissions is Map<String, dynamic> &&
          existingSubmissions['quiz_submissions'] != null &&
          (existingSubmissions['quiz_submissions'] as List).isNotEmpty) {
        // Use the existing submission
        quizSubmission = existingSubmissions['quiz_submissions'][0];
        print("Using existing submission: ${quizSubmission!['id']}");
      } else {
        // Create a new submission if none exists
        final sessionResponse = await HttpProvider().post(
          'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/submissions',
          body: {
            'quiz_submission': {'attempt': 1}
          },
        );

        print("Created new submission: $sessionResponse");
        if (sessionResponse == null ||
            sessionResponse['quiz_submissions'] == null ||
            (sessionResponse['quiz_submissions'] as List).isEmpty) {
          throw Exception('Failed to create quiz session');
        }
        quizSubmission = sessionResponse['quiz_submissions'][0];
      }

      if (quizSubmission == null) {
        throw Exception('No quiz submission available');
      }

      // Start or resume the quiz session
      await HttpProvider().post(
        'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/submissions/${quizSubmission['id']}/events',
        body: {'event': 'start'},
      );

      // Fetch the questions through the submission endpoint
      final submissionResponse = await HttpProvider().getJson(
        'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/submissions/${quizSubmission['id']}?include[]=questions',
      );

      print("Got quiz questions: $submissionResponse");

      print("Full submission response: $submissionResponse");

      // Check for nested keys that might contain questions
      for (var key in submissionResponse.keys) {
        print("Key: $key, Value: ${submissionResponse[key]}");
      }

      if (submissionResponse == null ||
          submissionResponse['quiz_submissions'] == null ||
          submissionResponse['quiz_submissions'].isEmpty ||
          submissionResponse['quiz_submissions'][0]['questions'] == null) {
        throw Exception('Failed to load quiz questions');
      }

      // Check if questions are present in the submission response
      List<dynamic> questions =
          submissionResponse['quiz_submissions'][0]['questions'] as List? ?? [];

      // If questions are not present, fetch them separately
      if (questions.isEmpty) {
        final questionsResponse = await HttpProvider().getJson(
          'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/questions',
        );

        print("Fetched questions separately: $questionsResponse");

        // Log the full response for debugging
        if (questionsResponse != null) {
          for (var key in questionsResponse.keys) {
            print("Questions Key: $key, Value: ${questionsResponse[key]}");
          }
        }

        if (questionsResponse == null) {
          throw Exception('Failed to load quiz questions');
        }

        questions = questionsResponse as List? ?? [];
      }

      // Extract submission data from the response
      final submission = QuizSubmission(
        id: quizSubmission['id'].toString(),
        quizId: widget.assignment.quizId!,
        questions: questions.map((q) => QuizQuestion.fromJson(q)).toList(),
        attempt: quizSubmission['attempt'] ?? 1,
        validationToken: quizSubmission['validation_token'] ?? '',
      );

      print("Created submission with ${submission.questions.length} questions");

      if (submission.questions.isEmpty) {
        throw Exception('No questions available for this quiz');
      }

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizTakingScreen(
              assignment: widget.assignment,
              submission: submission,
            ),
          ),
        );
      }
    } catch (e, stackTrace) {
      print("Error starting quiz: $e");
      print("Stack trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start quiz: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assignment.name),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadQuizData,
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_quiz?.description.isNotEmpty == true) ...[
                        const Text(
                          'Instructions:',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        HtmlWidget(_quiz!.description),
                        const SizedBox(height: 16),
                      ],
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildQuizInfo('Time Limit',
                                  '${_quiz?.timeLimit ?? 'No'} minutes'),
                              _buildQuizInfo(
                                  'Questions', '${_quiz?.questionCount ?? 0}'),
                              _buildQuizInfo(
                                  'Points', '${_quiz?.pointsPossible ?? 0}'),
                              _buildQuizInfo('Attempts Allowed',
                                  '${_quiz?.allowedAttempts == -1 ? 'Unlimited' : _quiz?.allowedAttempts ?? 1}'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _startQuiz,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text('Start Quiz'),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildQuizInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }
}

class QuizTakingScreen extends StatefulWidget {
  final Assignment assignment;
  final QuizSubmission submission;

  const QuizTakingScreen({
    super.key,
    required this.assignment,
    required this.submission,
  });

  @override
  State<QuizTakingScreen> createState() => _QuizTakingScreenState();
}

class _QuizTakingScreenState extends State<QuizTakingScreen> {
  final Map<String, String> _answers = {};
  bool _isSubmitting = false;

  Future<void> _submitQuiz() async {
    try {
      setState(() => _isSubmitting = true);

      // Submit the quiz answers
      await HttpProvider().post(
        'courses/${widget.assignment.courseId}/quizzes/${widget.assignment.quizId}/submissions/${widget.submission.id}/complete',
        body: {
          'attempt': widget.submission.attempt,
          'validation_token': widget.submission.validationToken,
          'quiz_questions': _answers.entries
              .map((e) => {
                    'id': e.key,
                    'answer': e.value,
                  })
              .toList(),
        },
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Quiz submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
        Navigator.pop(context);
      }
    } catch (e) {
      print("Error submitting quiz: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to submit quiz: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.submission.questions.length,
              itemBuilder: (context, index) {
                final question = widget.submission.questions[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HtmlWidget(question.questionText),
                        const SizedBox(height: 16),
                        ...question.answers
                            .map((answer) => RadioListTile<String>(
                                  title: Text(answer.text),
                                  value: answer.id,
                                  groupValue: _answers[question.id],
                                  onChanged: (value) {
                                    setState(() {
                                      _answers[question.id] = value ?? '';
                                    });
                                  },
                                )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitQuiz,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Submit Quiz'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
