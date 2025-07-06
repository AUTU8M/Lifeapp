  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:image_picker/image_picker.dart';
  import 'dart:io';
  import '../../../../main.dart';
import '../../home/presentations/pages/home_page.dart';
import '../../nav_bar/presentations/pages/nav_bar_page.dart';
import '../providers/vision_provider.dart';
  import 'vision_page.dart';
  import 'package:lifelab3/src/common/utils/mixpanel_service.dart';
  import 'package:flutter/foundation.dart';

  class SubmitButtonWithAnimatedText extends StatefulWidget {
    final bool isLoading;
    final bool isSubmitButton;
    final VoidCallback? onPressed;

    const SubmitButtonWithAnimatedText({
      Key? key,
      required this.isLoading,
      this.isSubmitButton = true,
      required this.onPressed,
    }) : super(key: key);

    @override
    _SubmitButtonWithAnimatedTextState createState() => _SubmitButtonWithAnimatedTextState();
  }
  class _SubmitButtonWithAnimatedTextState extends State<SubmitButtonWithAnimatedText>
      with SingleTickerProviderStateMixin {
    late AnimationController _controller;
    late Animation<double> _opacityAnimation;
    @override
    void initState() {
      super.initState();
      _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
      _opacityAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(_controller);
      _controller.forward();
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });
    }

    @override
    void dispose() {
      _controller.dispose();
      super.dispose();
    }

    @override
    Widget build(BuildContext context) {
      return ElevatedButton(
        onPressed: widget.isLoading ? null : widget.onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: widget.isLoading && widget.isSubmitButton
            ? FadeTransition(
          opacity: _opacityAnimation,
          child: const Text(
            'Hold a sec... Submitting your answer',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            textAlign: TextAlign.center,
          ),
        )
            : Text(
          widget.isSubmitButton ? 'Submit' : 'Next',
          style: const TextStyle(fontSize: 16),
        ),
      );
    }
  }

  class QuizScreen extends StatelessWidget {
    final String videoTitle;
    final String visionId;
    final Function? onReplayVideo;
    final String navName;
    final String subjectId;

    const QuizScreen({
      super.key,
      required this.videoTitle,
      required this.visionId,
      this.onReplayVideo,
      required this.navName,
      required this.subjectId,
    });

    @override
    Widget build(BuildContext context) {
      return ChangeNotifierProvider.value(
        value: Provider.of<VisionProvider>(context, listen: false),
        child: Question1Screen(
          videoTitle: videoTitle,
          visionId: visionId,
          onReplayVideo: onReplayVideo,
          navName: navName,
          subjectId: subjectId,
        ),
      );
    }
  }

  class QuizBackground extends StatelessWidget {
    final Widget child;
    const QuizBackground({super.key, required this.child});

    @override
    Widget build(BuildContext context) {
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      );
    }
  }

  class Question1Screen extends StatefulWidget {
    final String videoTitle;
    final String visionId;
    final Function? onReplayVideo;
    final String navName;
    final String subjectId;

    const Question1Screen({
      super.key,
      required this.videoTitle,
      required this.visionId,
      this.onReplayVideo,
      required this.navName,
      required this.subjectId,
    });

    @override
    State<Question1Screen> createState() => _Question1ScreenState();
  }

  class _Question1ScreenState extends State<Question1Screen> {
    int currentMCQIndex = 0;
    String? selectedOptionKey;
    List<Map<String, dynamic>> answers = [];
    int earnedCoins = 0;
    bool _isSubmitting = false;

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<VisionProvider>(context, listen: false)
            .fetchQuizQuestions(widget.visionId);
      });
    }

    Widget _buildMCQTabs(int activeIndex, int totalQuestions) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          totalQuestions,
              (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: index == activeIndex
                  ? Colors.blue
                  : Colors.white.withOpacity(0.7),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.blue),
            ),
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: index == activeIndex ? Colors.white : Colors.black87,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      );
    }
    Widget _buildSubmitButton(VoidCallback onPressed) {
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    void launchQuiz(
        BuildContext context,
        String videoTitle,
        String visionId, {
          Function? onReplayVideo,
          required String navName,
          required String subjectId,
        }) {
      Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(name: '/quiz/vision'),
          builder: (context) => QuizScreen(
            videoTitle: videoTitle,
            visionId: visionId,
            onReplayVideo: onReplayVideo,
            navName: navName,
            subjectId: subjectId,
          ),
        ),
      );
    }
    @override
    Widget build(BuildContext context) {
      final visionProvider = Provider.of<VisionProvider>(context);

      if (visionProvider.isLoadingQuestions) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      if (visionProvider.questionsError.isNotEmpty) {
        return Scaffold(
          body: Center(
            child: Text(
              'Error: ${visionProvider.questionsError}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        );
      }

      final hasMCQs = (visionProvider.currentQuestions?['mcq_questions']?.isNotEmpty ?? false);
      final hasDescriptive = visionProvider.currentQuestions?['descriptive_question'] != null;
      final hasImage = visionProvider.currentQuestions?['image_question'] != null;

      if (!hasMCQs && !hasDescriptive && !hasImage) {
        return const Scaffold(
          body: Center(child: Text('Press Back To Explore More')),
        );
      }

      // If no MCQs but other types exist, skip to next appropriate screen
      if (!hasMCQs) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (hasDescriptive) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: visionProvider,
                  child: Question2Screen(
                    videoTitle: widget.videoTitle,
                    visionId: widget.visionId,
                    earnedCoins: 0,
                    answers: const [],
                    onReplayVideo: widget.onReplayVideo,
                    navName: widget.navName,
                    subjectId: widget.subjectId,
                  ),
                ),
              ),
            );
          } else if (hasImage) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: visionProvider,
                  child: Question3Screen(
                    videoTitle: widget.videoTitle,
                    visionId: widget.visionId,
                    earnedCoins: 0,
                    answers: const [],
                    onReplayVideo: widget.onReplayVideo,
                    navName: widget.navName,
                    subjectId: widget.subjectId,
                  ),
                ),
              ),
            );
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final questions = visionProvider.currentQuestions?['mcq_questions'];

      final currentQuestion = questions[currentMCQIndex];
      final questionText =
          currentQuestion['question']?['en'] ?? 'No question text';
      final optionsMap =
      Map<String, dynamic>.from(currentQuestion['options'] ?? {});
      final optionEntries = optionsMap.entries.toList();

      return Scaffold(
        body: QuizBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              _buildTopNavigation(context),
                              const SizedBox(height: 10),
                              _buildMCQTabs(currentMCQIndex, questions.length),
                              const SizedBox(height: 10),
                              _buildNavLine(),
                              const SizedBox(height: 30),
                              Text(
                                'Question ${currentMCQIndex + 1}',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                questionText,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 30),
                              ...optionEntries.map((entry) => _buildOption(
                                  entry.key, entry.value.toString())),
                              const Spacer(),
                              const SizedBox(height: 20),
                              _buildNavigationButtons(
                                context,
                                currentMCQIndex,
                                questions.length,
                                currentQuestion,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }

    Widget _buildNavigationButtons(
        BuildContext context,
        int currentIndex,
        int totalQuestions,
        Map<String, dynamic> currentQuestion,
        ) {
      final isLastQuestion = currentIndex == totalQuestions - 1;
      return Row(
        children: [
          Expanded(
            child: SubmitButtonWithAnimatedText(
              isLoading: _isSubmitting,
              isSubmitButton: isLastQuestion,
              onPressed: () async {
                if (_isSubmitting) return; // prevent multiple taps
                setState(() {
                  _isSubmitting = true;
                });
                await _goToNextMCQ(context, currentQuestion, isLastQuestion);
                setState(() {
                  _isSubmitting = false;
                });
              },

            ),
          ),
        ],
      );
    }

    Future<void> _goToNextMCQ(
        BuildContext context,
        Map<String, dynamic> currentQuestion,
        bool isLastQuestion,
        ) async  {
      if (selectedOptionKey == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select an option')),
        );
        return;
      }
      // Track answer submission
      MixpanelService.track("MCQ Answer Submitted", properties: {
        "vision_id": widget.visionId,
        "question_id": currentQuestion['id'].toString(),
        "is_correct": selectedOptionKey == currentQuestion['correct_answer'],
        "timestamp": DateTime.now().toIso8601String(),
      });
      answers.add({
        'id': currentQuestion['id'].toString(),
        'answer': selectedOptionKey,
        'type': 'mcq',
      });
      if (selectedOptionKey == currentQuestion['correct_answer']) {
        earnedCoins += 50;
      }
      final visionProvider = Provider.of<VisionProvider>(context, listen: false);
      final questions = visionProvider.currentQuestions!['mcq_questions'];
      if (!isLastQuestion) {
        setState(() {
          currentMCQIndex++;
          selectedOptionKey = null;
        });
      } else {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final hasDescriptive =
              visionProvider.currentQuestions?['descriptive_question'] != null;
          final hasImage =
              visionProvider.currentQuestions?['image_question'] != null;

          if (!hasDescriptive && !hasImage) {
            _submitQuiz(context, visionProvider);
          } else if (hasDescriptive) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: visionProvider,
                  child: Question2Screen(
                    videoTitle: widget.videoTitle,
                    visionId: widget.visionId,
                    earnedCoins: earnedCoins,
                    answers: answers,
                    onReplayVideo: widget.onReplayVideo,
                    navName: widget.navName,
                    subjectId: widget.subjectId,
                  ),
                ),
              ),
            );
          } else if (hasImage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: visionProvider,
                  child: Question3Screen(
                    videoTitle: widget.videoTitle,
                    visionId: widget.visionId,
                    earnedCoins: earnedCoins,
                    answers: answers,
                    onReplayVideo: widget.onReplayVideo,
                    navName: widget.navName,
                    subjectId: widget.subjectId,
                  ),
                ),
              ),
            );
          }
        });
      }
    }
    Future<void> _submitQuiz(BuildContext context, VisionProvider visionProvider) async {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => false, // Disable back button while loading
            child: Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 12,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      width: 60,
                      height: 60,
                      child: CircularProgressIndicator(
                        strokeWidth: 6,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Hold a sec...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Submitting your answer',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );

      try {
        final result = await visionProvider.submitAnswersAndGetResult(
            widget.visionId, answers);

        Navigator.of(context).pop(); // Hide loading dialog

        if (!mounted) return;

        if (result != null && result['submission_successful'] == false) {
          final errorMessage = result['error']?.toString() ?? 'Submission failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          return;
        }

        // Navigate to completed screen after submission
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: visionProvider,
              child: QuizCompletedScreen(
                videoTitle: widget.videoTitle,
                visionId: widget.visionId,
                earnedCoins: earnedCoins,
                answer: answers,
                quizResult: result?['quiz_result'] as Map<String, dynamic>?,
                navName: widget.navName,
                subjectId: widget.subjectId,
              ),
            ),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Hide loading dialog

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting quiz: $e')),
          );
        }
      }
    }
    Widget _buildOption(String key, String value) {
      final isSelected = selectedOptionKey == key;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            setState(() {
              selectedOptionKey = key;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.shade600 : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? Colors.blue.shade800 : Colors.grey.shade300,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3),
                  offset: const Offset(0, 4),
                  blurRadius: 8,
                ),
              ]
                  : [
                BoxShadow(
                  color: Colors.black12,
                  offset: const Offset(0, 2),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Circle with key letter
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.blue.shade100,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    key.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.blue.shade600 : Colors.blue.shade700,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Option Text
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 18,
                      color: isSelected ? Colors.white : Colors.black87,
                      height: 1.3,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    Widget _buildTopNavigation(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              final vision = Provider.of<VisionProvider>(context, listen: false)
                  .getVideoById(widget.visionId);

              if (vision == null) {
                // Fallback if vision not found
                debugPrint('⚠️ Vision not found for ID ${widget.visionId}');
                return;
              }

              final status = vision.status.toLowerCase();

              if (status == 'submitted' || status == 'completed') {
                // 🚀 Skip the dialog and go directly to home
                Navigator.pop(context); // close current screen
                Navigator.pop(context);
              } else {
                // 🔁 Show the skip confirmation dialog
                _showSkipWarning(context);
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            label: const Text(
              'Skip',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          if (widget.onReplayVideo != null)
            OutlinedButton.icon(
              onPressed: () {
                // Track rewatch action
                MixpanelService.track("Vision Rewatch", properties: {
                  "vision_id": widget.visionId,
                  "timestamp": DateTime.now().toIso8601String(),
                  "screen": "mcq_questions",
                });
                widget.onReplayVideo!();
                Navigator.pop(context);
              },
              icon: const Icon(Icons.replay),
              label: const Text(
                'Rewatch',
                style: TextStyle(color: Colors.blue, fontSize: 16),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.blue),
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
            ),
        ],
      );
    }
    Widget _buildNavLine() {
      return Container(
        width: 170,
        height: 0,
        color: Colors.blue,
        transform: Matrix4.translationValues(0, -30, 0),
      );
    }
    void _showSkipWarning(BuildContext context) {

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: Provider.of<VisionProvider>(context, listen: false),
            child: SkipWarningScreen(
              visionId: widget.visionId,
              onReplayVideo: widget.onReplayVideo,
              navName: widget.navName,
              subjectId: widget.subjectId,
            ),
          ),
        ),
      );
    }
  }

  class Question2Screen extends StatefulWidget {
    final String videoTitle;
    final String visionId;
    final int earnedCoins;
    final List<Map<String, dynamic>> answers;
    final Function? onReplayVideo;
    final String navName;
    final String subjectId;

    const Question2Screen({
      super.key,
      required this.videoTitle,
      required this.visionId,
      required this.earnedCoins,
      required this.answers,
      this.onReplayVideo,
      required this.navName,
      required this.subjectId,
    });

    @override
    State<Question2Screen> createState() => _Question2ScreenState();
  }

  class _Question2ScreenState extends State<Question2Screen> {
    final TextEditingController _answerController = TextEditingController();
    int earnedCoins = 0;
    late List<Map<String, dynamic>> _answers;

    Route createFadeRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      );
    }
    @override
    void initState() {
      super.initState();
      earnedCoins = widget.earnedCoins;
      _answers = List<Map<String, dynamic>>.from(widget.answers); // <-- clone it
    }
    @override
    void dispose() {
      _answerController.dispose();
      super.dispose();
    }
    @override
    Widget build(BuildContext context) {
      final visionProvider = Provider.of<VisionProvider>(context);
      final descriptiveQuestion =
      visionProvider.currentQuestions?['descriptive_question'];
      if (descriptiveQuestion == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final hasImage =
              visionProvider.currentQuestions?['image_question'] != null;
          if (hasImage && mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider.value(
                  value: visionProvider,
                  child: Question3Screen(
                    videoTitle: widget.videoTitle,
                    visionId: widget.visionId,
                    earnedCoins: earnedCoins,
                    answers: widget.answers,
                    onReplayVideo: widget.onReplayVideo,
                    navName: widget.navName,
                    subjectId: widget.subjectId,
                  ),
                ),
              ),
            );
          } else if (mounted && !_isSubmitting) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(
                    child: Text('No descriptive or image question found.'),
                  ),
                ),
              ),
            );
          }
        });
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }
      return Scaffold(
        body: QuizBackground(
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Scrollbar(
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints:
                      BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (widget.onReplayVideo != null)
                                _buildTopNavigation(context),
                              const SizedBox(height: 20),
                              const Text(
                                'Descriptive Question',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                descriptiveQuestion['question']?['en'] ??
                                    'No question text',
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: Colors.blue),
                                ),
                                child: TextField(
                                  controller: _answerController,
                                  expands: true,
                                  maxLines: null,
                                  textAlignVertical: TextAlignVertical.top,
                                  decoration: const InputDecoration(
                                    hintText: 'Type your answer here...',
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.all(16),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  final answerText = _answerController.text.trim();
                                  if (answerText.length >= 20) {
                                    setState(() {
                                      earnedCoins += 75;
                                      _answers.add({
                                        'id': descriptiveQuestion['id'].toString(),
                                        'answer': answerText,
                                        'type': 'descriptive',
                                      });
                                    });
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      _goToNextScreen(context, visionProvider);
                                    });
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Answer must be at least 20 characters')),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 48),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );
    }
    void showLoadingDialog(BuildContext context, {String message = 'Submitting your answer...'}) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Flexible(
                  child: Text(
                    message,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    void _goToNextScreen(BuildContext context, VisionProvider visionProvider) {
      final hasImage =
          visionProvider.currentQuestions?['image_question'] != null;
      if (hasImage) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider.value(
              value: visionProvider,
              child: Question3Screen(
                videoTitle: widget.videoTitle,
                visionId: widget.visionId,
                earnedCoins: earnedCoins,
                answers: _answers,
                onReplayVideo: widget.onReplayVideo,
                navName: widget.navName,
                subjectId: widget.subjectId,
              ),
            ),
          ),
        );
      } else {
        _submitQuiz(context, visionProvider);
      }
    }
    bool _isSubmitting = false;
    Future<void> _submitQuiz(BuildContext context, VisionProvider visionProvider) async {
      if (_isSubmitting) return;
      _isSubmitting = true;

      try {
        // Show loader
        showLoadingDialog(context, message: 'Submitting your answer...');

        // Mixpanel Tracking
        MixpanelService.track("Descriptive Answer Submitted", properties: {
          "vision_id": widget.visionId,
          "answer_length": _answerController.text.length,
          "timestamp": DateTime.now().toIso8601String(),
        });

        final result = await visionProvider.submitAnswersAndGetResult(widget.visionId, _answers);

        // Close loader
        Navigator.of(context).pop();

        if (!mounted) return;

        if (result != null && result['submission_successful'] == false) {
          final errorMessage = result['error']?.toString() ?? 'Submission failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          _isSubmitting = false;
          return;
        }

        // ✅ Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade800, Colors.blue.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.check_circle_outline, size: 60, color: Colors.white),
                  const SizedBox(height: 24),
                  const Text(
                    'Hooray!',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your answers are on their way to the review squad. We’ll ping you as soon as they’re graded keep up the great work! ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context); // close current screen
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Go to vision',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  )],
              ),
            ),
          ),
        );
      } catch (e) {
        Navigator.of(context).pop(); // Close loader on error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting quiz: $e')),
          );
        }
      } finally {
        _isSubmitting = false;
      }
    }

    Widget _buildTopNavigation(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              final vision = Provider.of<VisionProvider>(context, listen: false)
                  .getVideoById(widget.visionId);

              if (vision == null) {
                // Fallback if vision not found
                debugPrint('⚠️ Vision not found for ID ${widget.visionId}');
                return;
              }

              final status = vision.status.toLowerCase();

              if (status == 'submitted' || status == 'completed') {
                // 🚀 Skip the dialog and go directly to home
                Navigator.pop(context); // close current screen
                Navigator.pop(context);
              } else {
                // 🔁 Show the skip confirmation dialog
                _showSkipWarning(context);
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            label: const Text(
              'Skip',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          OutlinedButton.icon(
            onPressed: widget.onReplayVideo != null
                ? () {
              // Track rewatch action
              MixpanelService.track("Vision Rewatch", properties: {
                "vision_id": widget.visionId,
                "timestamp": DateTime.now().toIso8601String(),
                "screen": "descriptive_question",
              });
              widget.onReplayVideo!();
              Navigator.pop(context);
            }
                : () => Navigator.of(context).pop(),
            icon: const Icon(Icons.replay),
            label: const Text(
              'Rewatch',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      );
    }
    void _showSkipWarning(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider.value(
            value: Provider.of<VisionProvider>(context, listen: false),
            child: SkipWarningScreen(
              visionId: widget.visionId,
              onReplayVideo: widget.onReplayVideo,
              navName: widget.navName,
              subjectId: widget.subjectId,
            ),
          ),
        ),
      );
    }
  }

  class Question3Screen extends StatefulWidget {
    final String videoTitle;
    final String visionId;
    final int earnedCoins;
    final List<Map<String, dynamic>> answers;
    final Function? onReplayVideo;
    final String navName;
    final String subjectId;

    const Question3Screen({
      super.key,
      required this.videoTitle,
      required this.visionId,
      required this.earnedCoins,
      required this.answers,
      this.onReplayVideo,
      required this.navName,
      required this.subjectId,
    });

    @override
    State<Question3Screen> createState() => _Question3ScreenState();
  }

  class _Question3ScreenState extends State<Question3Screen> {
    final TextEditingController _descriptionController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    XFile? _imageFile;
    int earnedCoins = 0;
    List<Map<String, dynamic>> _answers1 = [];

    Route createFadeRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      );
    }
    @override
    void initState() {
      super.initState();
      _answers1 = List<Map<String, dynamic>>.from(widget.answers); // <-- clone it
      earnedCoins = widget.earnedCoins;
    }
    @override
    void dispose() {
      _descriptionController.dispose();
      super.dispose();
    }
    Future<void> _pickImage() async {
      showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take a Photo'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageFromSource(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () async {
                    Navigator.pop(context);
                    await _pickImageFromSource(ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    Future<void> _pickImageFromSource(ImageSource source) async {
      try {
        final XFile? image = await _picker.pickImage(source: source);
        if (image != null && mounted) {
          setState(() {
            _imageFile = image;
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to pick image: $e')),
          );
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      final visionProvider = Provider.of<VisionProvider>(context);
      final imageQuestion = visionProvider.currentQuestions?['image_question'];

      if (imageQuestion == null) {
        return const Scaffold(
          body: Center(child: Text('No image question found.')),
        );
      }
      return Scaffold(
        body: QuizBackground(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.onReplayVideo != null)
                            _buildTopNavigation(context),

                          const SizedBox(height: 20),

                          Text(
                            imageQuestion['question']?['en'] ?? 'Upload your activity image',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 30),

                          ElevatedButton(
                            onPressed: _pickImage,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                            ),
                            child: const Text('Upload Image or Take a Photo'),
                          ),

                          const SizedBox(height: 20),

                          if (_imageFile != null)
                            Column(
                              children: [
                                Image.file(
                                  File(_imageFile!.path),
                                  height: 200,
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),

                          TextField(
                            controller: _descriptionController,
                            maxLines: null,
                            maxLength: 100,
                            decoration: InputDecoration(
                              hintText: 'Describe your activity...',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.all(16),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Colors.blue, width: 2),
                              ),
                            ),
                          ),


                          const SizedBox(height: 20),
                          // Extra space to account for the fixed button
                          const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),

                  // Fixed submit button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _submitAnswer(context, visionProvider),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: Colors.blue, // Button background color
                        foregroundColor: Colors.white, // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Optional: rounded corners
                        ),
                      ),
                      child: const Text('Submit'),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget _buildTopNavigation(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton.icon(
            onPressed: () {
              final vision = Provider.of<VisionProvider>(context, listen: false)
                  .getVideoById(widget.visionId);

              if (vision == null) {
                // Fallback if vision not found
                debugPrint('⚠️ Vision not found for ID ${widget.visionId}');
                return;
              }

              final status = vision.status.toLowerCase();

              if (status == 'submitted' || status == 'completed') {
                // 🚀 Skip the dialog and go directly to home
                Navigator.pop(context); // close current screen
                Navigator.pop(context);
              } else {
                // 🔁 Show the skip confirmation dialog
                _showSkipWarning(context);
              }
            },
            icon: const Icon(Icons.arrow_back, color: Colors.blue),
            label: const Text(
              'Skip',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
          ),

          OutlinedButton.icon(
            onPressed: () {
              // Track rewatch action
              MixpanelService.track("Vision Rewatch", properties: {
                "vision_id": widget.visionId,
                "timestamp": DateTime.now().toIso8601String(),
                "screen": "image_question",
              });
              widget.onReplayVideo?.call();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.replay),
            label: const Text('Rewatch'),
          ),
        ],
      );
    }
    void showLoadingDialog(BuildContext context, {String message = 'Submitting '
        'answers...'}) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 32),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(width: 20),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Future<void> _submitAnswer(
        BuildContext context, VisionProvider visionProvider) async {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please upload an image')),
        );
        return;
      }
      // Track image submission
      MixpanelService.track("Image Answer Submitted", properties: {
        "vision_id": widget.visionId,
        "image_size": File(_imageFile!.path).lengthSync(),
        "description_length": _descriptionController.text.length,
        "timestamp": DateTime.now().toString(),
      });
      // Use actual description if entered, or fallback text
      final description = _descriptionController.text.trim().isNotEmpty
          ? _descriptionController.text.trim()
          : 'No Description Submitted';  // ✅ fallback
      _answers1.add({
        'id': visionProvider.currentQuestions?['image_question']?['id'].toString(),
        'answer': description,
        'image_path': _imageFile!.path,
        'type': 'image',
      });
      debugPrint('✅ Final submitted answers: $_answers1');
      await _submitQuiz(context, visionProvider);
    }
    bool _isSubmitting = false;
    Future<void> _submitQuiz(BuildContext context, VisionProvider visionProvider) async {
      if (_isSubmitting) return;
      _isSubmitting = true;
      try {
        // Show loading dialog
        showLoadingDialog(context);
        final result = await visionProvider.submitAnswersAndGetResult(widget.visionId, _answers1);
        // Hide loading dialog
        Navigator.of(context).pop();
        if (!mounted) return;
        if (result != null && result['submission_successful'] == false) {
          final errorMessage = result['error']?.toString() ?? 'Submission failed';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage)),
          );
          _isSubmitting = false;
          return;
        }
        // Show success dialog here (use your fancy dialog)
        await showSubmissionSuccessDialog(context, visionProvider);

      } catch (e) {
        // Hide loading dialog if error occurs
        Navigator.of(context).pop();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error submitting quiz: $e')),
          );
        }
      } finally {
        _isSubmitting = false;
      }
    }

    // Show dialog and navigate
    Future<void> showSubmissionSuccessDialog(BuildContext context, VisionProvider visionProvider) {
      return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 28),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue.shade700, Colors.blue.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.4),
                  offset: const Offset(0, 12),
                  blurRadius: 24,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white.withOpacity(0.25),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child:
                  const Icon(Icons.check_circle_outline, size: 60, color: Colors.white),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Hooray! Submission Received',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your answers are on their way to the review team. '
                      'You will be notified once they have been checked. '
                      'Thank you for your effort!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    height: 1.5,
                    color: Colors.white70,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(36),
                      ),
                      elevation: 8,
                      shadowColor: Colors.white70,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      visionProvider.clearQuizQuestions();
                      Navigator.pop(context); // close current screen
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Go to Vision',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        letterSpacing: 0.6,
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


    void _showSkipWarning(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SkipWarningScreen(
            visionId: widget.visionId,
            onReplayVideo: widget.onReplayVideo,
            navName: widget.navName,
            subjectId: widget.subjectId,
          ),

        ),
      );
    }
  }

  class QuizCompletedScreen extends StatefulWidget {
    final String videoTitle;
    final String visionId;
    final int earnedCoins;
    final Map<String, dynamic>? quizResult;
    final String navName;
    final String subjectId;
    final List<Map<String, dynamic>> answer;

    const QuizCompletedScreen({
      super.key,
      required this.videoTitle,
      required this.visionId,
      required this.earnedCoins,
      this.quizResult,
      required this.navName,
      required this.subjectId, required this.answer,
    });

    @override
    State<QuizCompletedScreen> createState() => _QuizCompletedScreenState();
  }
  late Map<String, dynamic>? _quiz = {};
  class _QuizCompletedScreenState extends State<QuizCompletedScreen> {

    Map<String, dynamic>? _quizResult;
    bool _isLoading = false;
    String? _error;
    late List<Map<String, dynamic>> answer;
    Route createFadeRoute(Widget page) {
      return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 500),
      );
    }

    @override
    void initState() {
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<VisionProvider>(context, listen: false)
            .fetchQuizQuestions(widget.visionId);
      });
      _quizResult = widget.quizResult;
      _quiz = _quizResult;
      answer = widget.answer;
      debugPrint("poisa $answer");
      if (_quizResult == null) {
        _fetchResult();
      }
    }

    Future<void> _fetchResult() async {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      try {
        final visionProvider = Provider.of<VisionProvider>(context, listen: false);
        final result = await visionProvider.getQuizResult(widget.visionId);
        if (mounted) {
          setState(() {
            _quizResult = result;
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _error = e.toString();
            _isLoading = false;
          });
        }
      }
    }

    @override
    Widget build(BuildContext context) {
      final visionProvider = Provider.of<VisionProvider>(context);
      debugPrint("piiiee $visionProvider");

      final questions = visionProvider.currentQuestions?['mcq_questions'];
    debugPrint("piii $questions");
      return Scaffold(
        body: QuizBackground(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_isLoading)
                      const CircularProgressIndicator()
                    else if (_error != null)
                      Text(
                        _error!.toLowerCase().contains('student id')
                            ? 'Please log in again'
                            : 'Error: $_error',
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 16,
                        ),
                      )
                    else
                      Column(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 64,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Quiz Completed!',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'You have successfully completed the quiz for "${widget.videoTitle}"',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Score: ${_quizResult?['earned_coins']}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Total Coins: ${_quizResult?['earned_coins'] ?? widget.earnedCoins}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 24),

                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.blue),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  'assets/images/coin.png',
                                  height: 24,
                                  width: 24,
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'You earned',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    Text(
                                      '${_quizResult?['earned_coins'] ?? widget.earnedCoins} Coins',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height:24),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    final provider =
                                    Provider.of<VisionProvider>(context, listen: false);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ChangeNotifierProvider.value(
                                          value: provider,
                                          child: QuizScreen(
                                            videoTitle: widget.videoTitle,
                                            visionId: widget.visionId,
                                            navName: widget.navName,
                                            subjectId: widget.subjectId,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 48),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Retake Quiz',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                          title: const Text(
                                            'Quiz Review',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          content: SizedBox(
                                            width: double.maxFinite,
                                            child: ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: answer.length,
                                              itemBuilder: (context, index) {
                                                final answe = answer[index];
                                                final currentQuestion = questions[index];
                                                final questionText = currentQuestion['question']?['en'] ?? 'No question text';
                                                final correctAnswer = currentQuestion['correct_answer'] ?? 'Not available';
                                                final userAnswer = answe['answer'] ?? 'N/A';

                                                final isCorrect = userAnswer.toString().trim().toLowerCase() ==
                                                    correctAnswer.toString().trim().toLowerCase();

                                                return Container(
                                                  margin: const EdgeInsets.only(bottom: 14),
                                                  padding: const EdgeInsets.all(16),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius: BorderRadius.circular(14),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black12,
                                                        blurRadius: 6,
                                                        offset: const Offset(0, 3),
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                      color: isCorrect ? Colors.green : Colors.redAccent,
                                                      width: 1.2,
                                                    ),
                                                  ),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        'Q${index + 1}: $questionText',
                                                        style: const TextStyle(
                                                          fontWeight: FontWeight.w600,
                                                          fontSize: 16,
                                                          color: Colors.black87,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 10),
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                              text: 'Your Answer: ',
                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                                                            ),
                                                            TextSpan(
                                                              text: userAnswer,
                                                              style: TextStyle(
                                                                color: isCorrect ? Colors.green : Colors.red,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text.rich(
                                                        TextSpan(
                                                          children: [
                                                            const TextSpan(
                                                              text: 'Correct Answer: ',
                                                              style: TextStyle(fontWeight: FontWeight.w500, color: Colors.black54),
                                                            ),
                                                            TextSpan(
                                                              text: correctAnswer,
                                                              style: const TextStyle(
                                                                color: Colors.blue,
                                                                fontWeight: FontWeight.bold,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text(
                                                'Close',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.deepPurple,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    minimumSize: const Size(double.infinity, 50),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    elevation: 3,
                                  ),
                                  child: const Text(
                                    'View Answers',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ],
                      ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<VisionProvider>(context, listen: false).clearQuizQuestions();

                        Navigator.pop(context); // close current screen
                        Navigator.pop(context);

                        // Wait for transition, then show snackbar
                        Future.delayed(const Duration(milliseconds: 600), () {
                          // Ensure context is still valid after navigation
                          final navContext = navKey.currentContext;
                          if (navContext != null) {
                            ScaffoldMessenger.of(navContext).showSnackBar(
                              SnackBar(
                                content: const Text(
                                  "🎉 Your vision has been submitted!",
                                  style: TextStyle(fontSize: 15),
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 3),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Go to Vision',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Feature coming soon!')),
                        );
                      },
                      child: const Text(
                        'View Achievements',
                        style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }

  class SkipWarningScreen extends StatelessWidget {
    final String visionId;
    final Function? onReplayVideo;
    final String navName;
    final String subjectId;

    const SkipWarningScreen({
      super.key,
      required this.visionId,
      this.onReplayVideo,
      required this.navName,
      required this.subjectId,
    });

    @override
    Widget build(BuildContext context) {
      final visionProvider = Provider.of<VisionProvider>(context, listen: false);
      final pointsToLose = visionProvider.currentVisionPoints;

      return Scaffold(
        body: QuizBackground(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 12),
                    const Text(
                      ' Uh-oh!!',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const Text(
                      'You\'re about to lose',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Image.asset(
                      "assets/images/coins_icon.png",
                      fit: BoxFit.fill,
                      height: 70,
                    ),
                    Column(
                      children: [
                        const SizedBox(height: 12),
                        Text(
                          '$pointsToLose coins',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.w900,
                            color: Colors.redAccent,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Complete this challenge now to boost your balance and level up—your adventure awaits! ',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black54,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),
                    const SizedBox(height: 40),

                    // 🌟 Stay button (Encouraged)
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                      ),
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'I’ll Stay',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // 🕒 Do Later
                    ElevatedButton.icon(
                      onPressed: () => _handleDoLater(context, visionProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      icon: const Icon(Icons.access_time),
                      label: const Text(
                        'Do It Later',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ❌ Skip button (Negative style)
                    ElevatedButton.icon(
                      onPressed: () => _handleSkip(context, visionProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                      ),
                      icon: const Icon(Icons.close_rounded),
                      label: const Text(
                        'Skip Anyway',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],

                ),
              ),
            ),
          ),
        ),
      );
    }

    Future<void> _handleSkip(BuildContext context, VisionProvider visionProvider) async {
      try {
        MixpanelService.track("Vision Skip Initiated", properties: {
          "vision_id": visionId,
          "timestamp": DateTime.now().toString(),
          "action_type": "skip",
        });
        final success = await visionProvider.skipQuiz(visionId);
        if (success) {
          MixpanelService.track("Vision Skipped", properties: {
            "vision_id": visionId,
            "timestamp": DateTime.now().toString(),
            "coins_lost": 50,
            "device_type": Platform.isAndroid ? "android" : Platform.isIOS ? "ios" : "other",
          });
        }
      } catch (e) {
        debugPrint('💥 Error skipping quiz: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to skip quiz: $e')),
          );
        }
      } finally {
        if (context.mounted) {
          visionProvider.clearQuizQuestions();
          Navigator.pop(context);
          Navigator.pop(context);
          Navigator.pop(context);
        }
      }
    }
    Future<void> _handleDoLater(BuildContext context, VisionProvider visionProvider) async {
      try {
        // Track do later action
        MixpanelService.track("Vision Do Later Initiated", properties: {
          "vision_id": visionId,
          "timestamp": DateTime.now().toString(),
        });

        final success = await visionProvider.markQuizPending(visionId);
        if (success) {
          MixpanelService.track("Vision Do Later", properties: {
            "vision_id": visionId,
            "timestamp": DateTime.now().toString(),
            "device_type": Platform.isAndroid ? "android" : Platform.isIOS ? "ios" : "other",
          });
        }
        if (!success) debugPrint('⚠️ Mark pending API returned false');
      } catch (e) {
        debugPrint('💥 Error marking quiz pending: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to mark quiz as pending: $e')),
          );
        }
      } finally {
        if (context.mounted) {
          visionProvider.clearQuizQuestions();

          // 👇 Pop twice (exit DoLater and go back to video or list)
          Navigator.pop(context); // Closes SkipWarningScreen
          Navigator.pop(context);
          Navigator.pop(context); // Closes previous screen (like quiz page or video page)
        }
      }
    }
  }
  void launchQuiz(
      BuildContext context,
      String videoTitle,
      String visionId, {
        Function? onReplayVideo,
        required String navName,
        required String subjectId,
      }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(name: '/quiz/vision'),
        builder: (context) => ChangeNotifierProvider.value(
          value: Provider.of<VisionProvider>(context, listen: false),
          child: QuizScreen(
            videoTitle: videoTitle,
            visionId: visionId,
            onReplayVideo: onReplayVideo,
            navName: navName,
            subjectId: subjectId,
          ),
        ),
      ),
    );
  }