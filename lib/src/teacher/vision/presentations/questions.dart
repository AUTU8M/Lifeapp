import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// MCQ Questions List
final List<Map<String, dynamic>> mcqQuestions = [
  {
    'question': 'What is the capital of France?',
    'options': ['Paris', 'Berlin', 'Rome', 'Madrid'],
    'correctAnswer': 'Paris'
  },
  {
    'question': 'Which planet is known as the Red Planet?',
    'options': ['Earth', 'Mars', 'Venus', 'Jupiter'],
    'correctAnswer': 'Mars'
  },
  {
    'question': 'Who wrote Hamlet?',
    'options': ['Shakespeare', 'Dickens', 'Hemingway', 'Twain'],
    'correctAnswer': 'Shakespeare'
  },
];

class TeacherQuizPreviewScreen extends StatelessWidget {
  final String videoTitle;
  final String? navName;
  final String? subjectName;

  const TeacherQuizPreviewScreen({
    Key? key,
    required this.videoTitle,
    this.navName,
    this.subjectName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: Colors.blueAccent,
        ),
      ),
      home: TeacherQuestion1Screen(
        videoTitle: videoTitle,
        navName: navName,
        subjectName: subjectName,
      ),
    );
  }
}

class QuizBackground extends StatelessWidget {
  final Widget child;
  const QuizBackground({Key? key, required this.child}) : super(key: key);

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

class TeacherQuestion1Screen extends StatefulWidget {
  final String videoTitle;
  final String? navName;
  final String? subjectName;

  const TeacherQuestion1Screen({
    Key? key,
    required this.videoTitle,
    this.navName,
    this.subjectName,
  }) : super(key: key);

  @override
  State<TeacherQuestion1Screen> createState() => _TeacherQuestion1ScreenState();
}

class _TeacherQuestion1ScreenState extends State<TeacherQuestion1Screen> {
  int currentMCQIndex = 0;
  String? selectedOption;

  void _goToNextMCQ() {
    if (currentMCQIndex < mcqQuestions.length - 1) {
      setState(() {
        currentMCQIndex++;
        selectedOption = null;
      });
    } else {
      // Move to description question
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeacherQuestion2Screen(
            videoTitle: widget.videoTitle,
            navName: widget.navName,
            subjectName: widget.subjectName,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = mcqQuestions[currentMCQIndex];
    final questionText = currentQuestion['question'];
    final options = List<String>.from(currentQuestion['options']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Questions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
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
                            const SizedBox(height: 10),
                            _buildMCQTabs(currentMCQIndex),
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
                            ...options.map((option) => _buildOption(option)),
                            const Spacer(),
                            const SizedBox(height: 20),
                            _buildAssignButton(() {
                              _goToNextMCQ();
                            }),
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

  Widget _buildOption(String text) {
    final isSelected = selectedOption == text;
    final isCorrect = text == mcqQuestions[currentMCQIndex]['correctAnswer'];

    return GestureDetector(
      onTap: () => setState(() => selectedOption = text),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected
              ? (isCorrect
                  ? Colors.green.withOpacity(0.7)
                  : Colors.blue.withOpacity(0.7))
              : Colors.white.withOpacity(0.7),
          borderRadius: BorderRadius.circular(70),
          border: Border.all(
            color: isCorrect ? Colors.green.shade400 : Colors.blue.shade400,
            width: isCorrect ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            ),
            if (isCorrect)
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavLine() {
    return Container(
      width: 170,
      height: 2, // Changed from 0 to 2 to make it visible
      color: Colors.blue,
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
    );
  }

  Widget _buildMCQTabs(int currentIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(mcqQuestions.length, (index) {
        final isActive = index == currentIndex;
        final isCompleted = index < currentIndex;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? Colors.green
                : isActive
                    ? Colors.blue
                    : Colors.grey.shade300,
            border: Border.all(
              color: isActive ? Colors.blue.shade700 : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              '${index + 1}',
              style: TextStyle(
                color: (isActive || isCompleted)
                    ? Colors.white
                    : Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _buildAssignButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TeacherQuestion2Screen extends StatefulWidget {
  final String videoTitle;
  final String? navName;
  final String? subjectName;

  const TeacherQuestion2Screen({
    Key? key,
    required this.videoTitle,
    this.navName,
    this.subjectName,
  }) : super(key: key);

  @override
  State<TeacherQuestion2Screen> createState() => _TeacherQuestion2ScreenState();
}

class _TeacherQuestion2ScreenState extends State<TeacherQuestion2Screen> {
  final TextEditingController _answerController = TextEditingController();

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Questions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            _buildNavLine(),
                            const SizedBox(height: 30),
                            const Text(
                              'Description Question',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Explain in your own words what you learned from the video:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade400),
                              ),
                              child: TextField(
                                controller: _answerController,
                                expands: true,
                                maxLines: null,
                                textAlignVertical: TextAlignVertical.top,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Students will write their answer here...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.blue.shade200),
                              ),
                              child: const Row(
                                children: [
                                  Icon(Icons.info_outline, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Students earn 75 coins for answers with 20+ characters',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 20),
                            _buildAssignButton(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => TeacherQuestion3Screen(
                                    videoTitle: widget.videoTitle,
                                    navName: widget.navName,
                                    subjectName: widget.subjectName,
                                  ),
                                ),
                              );
                            }),
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

  Widget _buildNavLine() {
    return Container(
      width: 170,
      height: 2, // Changed from 0 to 2 to make it visible
      color: Colors.blue,
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
    );
  }

  Widget _buildAssignButton(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Next',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class TeacherQuestion3Screen extends StatefulWidget {
  final String videoTitle;
  final String? navName;
  final String? subjectName;

  const TeacherQuestion3Screen({
    Key? key,
    required this.videoTitle,
    this.navName,
    this.subjectName,
  }) : super(key: key);

  @override
  State<TeacherQuestion3Screen> createState() => _TeacherQuestion3ScreenState();
}

class _TeacherQuestion3ScreenState extends State<TeacherQuestion3Screen> {
  File? _image;
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Questions'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
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
                            const SizedBox(height: 10),
                            const SizedBox(height: 10),
                            _buildNavLine(),
                            const SizedBox(height: 30),
                            const Text(
                              'Image Upload Question',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Upload a photo related to the video content:',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  border:
                                      Border.all(color: Colors.blue.shade400),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: _image == null
                                    ? const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              size: 40, color: Colors.grey),
                                          SizedBox(height: 10),
                                          Text(
                                            'Students will upload picture here',
                                            style:
                                                TextStyle(color: Colors.grey),
                                          )
                                        ],
                                      )
                                    : ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.file(_image!,
                                            fit: BoxFit.cover),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade400),
                              ),
                              child: TextField(
                                controller: _descriptionController,
                                maxLines: 5,
                                decoration: const InputDecoration(
                                  hintText:
                                      'Students will describe the image and how it relates to the video...',
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.all(12),
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border:
                                    Border.all(color: Colors.green.shade200),
                              ),
                              child: const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star, color: Colors.green),
                                      SizedBox(width: 8),
                                      Text(
                                        'Coin Rewards:',
                                        style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      '• 100 coins: Both image and description (10+ chars)'),
                                  Text(
                                      '• 50 coins: Either image or description only'),
                                ],
                              ),
                            ),
                            const Spacer(),
                            const SizedBox(height: 20),
                            _buildAssignButtonForLastScreen(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AssignVisionScreen(
                                    videoTitle: widget.videoTitle,
                                    navName: widget.navName,
                                    subjectName: widget.subjectName,
                                  ),
                                ),
                              );
                            }),
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

  Widget _buildNavLine() {
    return Container(
      width: 170,
      height: 2, // Changed from 0 to 2 to make it visible
      color: Colors.blue,
      transform: Matrix4.translationValues(0.0, -30.0, 0.0),
    );
  }

  Widget _buildAssignButtonForLastScreen(VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
        ),
        child: const Text(
          'Continue to Assignment',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class AssignVisionScreen extends StatefulWidget {
  final String videoTitle;
  final String? navName;
  final String? subjectName;

  const AssignVisionScreen({
    Key? key,
    required this.videoTitle,
    this.navName,
    this.subjectName,
  }) : super(key: key);

  @override
  State<AssignVisionScreen> createState() => _AssignVisionScreenState();
}

class _AssignVisionScreenState extends State<AssignVisionScreen> {
  final TextEditingController _assignmentNameController =
      TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  DateTime? _dueDate;
  TimeOfDay? _dueTime;
  List<String> selectedClasses = [];

  // Mock class data - replace with actual data
  final List<String> availableClasses = [
    'Class 10A',
    'Class 10B',
    'Class 10C',
    'Class 9A',
    'Class 9B',
  ];

  @override
  void initState() {
    super.initState();
    _assignmentNameController.text = 'Quiz: ${widget.videoTitle}';
  }

  @override
  void dispose() {
    _assignmentNameController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 23, minute: 59),
    );
    if (picked != null) {
      setState(() => _dueTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Assign Vision'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.transparent,
      body: QuizBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Assignment Details',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Assignment Name
                const Text(
                  'Assignment Name',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade400),
                  ),
                  child: TextField(
                    controller: _assignmentNameController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Instructions
                const Text(
                  'Instructions for Students',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade400),
                  ),
                  child: TextField(
                    controller: _instructionsController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText:
                          'Watch the video carefully and answer all questions thoughtfully...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Due Date and Time
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _selectDate,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    _dueDate != null
                                        ? '${_dueDate!.day}/${_dueDate!.month}/${_dueDate!.year}'
                                        : 'Select Date',
                                    style: TextStyle(
                                      color: _dueDate != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Time',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: _selectTime,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.blue.shade400),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: Colors.blue),
                                  const SizedBox(width: 8),
                                  Text(
                                    _dueTime != null
                                        ? _dueTime!.format(context)
                                        : 'Select Time',
                                    style: TextStyle(
                                      color: _dueTime != null
                                          ? Colors.black
                                          : Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Select Classes
                const Text(
                  'Assign to Classes',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade400),
                  ),
                  child: Column(
                    children: availableClasses.map((className) {
                      final isSelected = selectedClasses.contains(className);
                      return CheckboxListTile(
                        title: Text(className),
                        value: isSelected,
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedClasses.add(className);
                            } else {
                              selectedClasses.remove(className);
                            }
                          });
                        },
                        activeColor: Colors.blue,
                        contentPadding: EdgeInsets.zero,
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 30),

                // Summary Box
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.assignment, color: Colors.blue),
                          SizedBox(width: 8),
                          Text(
                            'Assignment Summary',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Video: ${widget.videoTitle}'),
                      const Text(
                          'Questions: 3 MCQ + 1 Description + 1 Image Upload'),
                      const Text('Total Possible Coins: 275'),
                      if (selectedClasses.isNotEmpty)
                        Text('Classes: ${selectedClasses.join(', ')}'),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Assign Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _canAssign() ? _assignVision : null,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Assign Vision',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
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

  bool _canAssign() {
    return _assignmentNameController.text.isNotEmpty &&
        selectedClasses.isNotEmpty &&
        _dueDate != null;
  }

  void _assignVision() {
    // Show success dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Assignment Created!'),
            ],
          ),
          content: Text(
            'Vision "${_assignmentNameController.text}" has been successfully assigned to ${selectedClasses.length} class(es).',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.popUntil(
                    context, (route) => route.isFirst); // Return to main screen
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

// Helper widgets - Fixed the function references and made them consistent
