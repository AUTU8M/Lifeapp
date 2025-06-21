import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vision_provider.dart';
import 'assignment_success.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';

class StudentAssignPage extends StatefulWidget {
  final String videoTitle;
  final String videoId;
  final String gradeId;
  final String subjectId;
  final String sectionId;
  final String classId;

  const StudentAssignPage({
    Key? key,
    required this.videoTitle,
    required this.videoId,
    required this.gradeId,
    required this.subjectId,
    required this.sectionId,
    required this.classId,
  }) : super(key: key);

  @override
  State<StudentAssignPage> createState() => _StudentAssignPageState();
}

class _StudentAssignPageState extends State<StudentAssignPage> {
  List<Map<String, dynamic>> _students = [];
  List<bool> _selectedStudents = [];
  bool _selectAll = true;
  DateTime? _dueDate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('🎬 StudentAssignPage initialized with:');
    debugPrint('   - videoId: ${widget.videoId}');
    debugPrint('   - videoTitle: ${widget.videoTitle}');
    debugPrint('   - sectionId: ${widget.sectionId}');
    debugPrint('   - gradeId: ${widget.gradeId}');
    debugPrint('   - subjectId: ${widget.subjectId}');
    debugPrint('   - sectionId is null: ${widget.sectionId == null}');
    debugPrint('   - sectionId is empty: ${widget.sectionId.isEmpty}');

    _fetchStudents();
  }

  Future<void> _fetchStudents() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Enhanced validation with better error messages
      debugPrint('🔍 Validating parameters...');
      debugPrint('   - sectionId: "${widget.sectionId}"');
      debugPrint('   - gradeId: "${widget.gradeId}"');
      debugPrint('   - subjectId: "${widget.subjectId}"');

      if (widget.sectionId.isEmpty) {
        debugPrint('❌ Section ID validation failed');
        setState(() {
          _errorMessage =
              'Section information is missing. Please go back and select a section first.';
          _isLoading = false;
        });
        return;
      }

      final provider = Provider.of<VisionProvider>(context, listen: false);
      final teacherProvider =
          Provider.of<TeacherDashboardProvider>(context, listen: false);

      debugPrint('🏫 Getting school information...');
      // Get school_id from TeacherDashboardProvider with better error handling
      final schoolId = teacherProvider.dashboardModel?.data?.user?.school?.id;
      debugPrint('   - schoolId: $schoolId');

      if (schoolId == null || schoolId == 0) {
        debugPrint('❌ School ID validation failed');
        setState(() {
          _errorMessage =
              'School information is not available. Please refresh the dashboard and try again.';
          _isLoading = false;
        });
        return;
      }

      Map<String, dynamic> data = {
        "school_id": schoolId,
        "la_section_id": widget.sectionId,
      };

      // Add optional parameters if they exist
      if (widget.gradeId.isNotEmpty) {
        data["la_grade_id"] = widget.gradeId;
        debugPrint('   - Added gradeId: ${widget.gradeId}');
      }
      if (widget.subjectId.isNotEmpty) {
        data["la_subject_id"] = widget.subjectId;
        debugPrint('   - Added subjectId: ${widget.subjectId}');
      }

      debugPrint('📤 Sending data to API: $data');

      _students = await provider.getStudentsForAssignment(data);
      _selectedStudents = List.filled(_students.length, true);

      debugPrint('✅ Fetched ${_students.length} students for assignment');
      if (_students.isNotEmpty) {
        debugPrint('   - First student: ${_students.first}');
      }

      if (_students.isEmpty) {
        setState(() {
          _errorMessage =
              'No students found for the selected section. Please check if students are enrolled in this section.';
        });
      }
    } catch (e) {
      debugPrint('❌ Error fetching students: $e');
      debugPrint('❌ Error type: ${e.runtimeType}');
      setState(() {
        _errorMessage =
            'Failed to load students: ${e.toString()}. Please check your internet connection and try again.';
        _students = [];
        _selectedStudents = [];
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      for (int i = 0; i < _selectedStudents.length; i++) {
        _selectedStudents[i] = _selectAll;
      }
    });
  }

  Future<void> _selectDueDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  Widget _buildStudentTile(String name, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/user.png'),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _selectedStudents[index] = !_selectedStudents[index];
              });
            },
            child: Icon(
              _selectedStudents[index]
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: _selectedStudents[index] ? Colors.green : Colors.grey,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80,
              color: Colors.orange[600],
            ),
            const SizedBox(height: 24),
            Text(
              'Unable to Load Students',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage ?? 'An unknown error occurred',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: _fetchStudents,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Go Back'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _assignVideoToStudents() async {
    final selectedStudentIds = <String>[];
    for (int i = 0; i < _selectedStudents.length; i++) {
      if (_selectedStudents[i]) {
        selectedStudentIds.add(_students[i]['id'].toString());
      }
    }

    if (selectedStudentIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one student.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please set a due date before assigning the vision.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    debugPrint('📝 Assigning video to ${selectedStudentIds.length} students');
    debugPrint('   - Selected student IDs: $selectedStudentIds');
    debugPrint('   - Due date: ${_dueDate?.toIso8601String()}');

    setState(() => _isLoading = true);
    try {
      final provider = Provider.of<VisionProvider>(context, listen: false);

      final success = await provider.assignVideoToStudents(
        widget.videoId,
        selectedStudentIds,
        dueDate: _dueDate!.toIso8601String(),
      );

      if (success) {
        debugPrint('✅ Video assigned successfully');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AssignmentSuccessScreen(
                assignedCount: selectedStudentIds.length),
          ),
        );
      } else {
        debugPrint('❌ Assignment failed');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Something went wrong. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Error assigning video: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error assigning video: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Vision",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  if (_students.isNotEmpty)
                    GestureDetector(
                      onTap: _toggleSelectAll,
                      child: Text(
                        _selectAll ? "Deselect all" : "Select all",
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Video title being assigned
              if (widget.videoTitle.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[200]!),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Assigning Video:",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue[800],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.videoTitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[900],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

              // Student list or error
              Expanded(
                child: _errorMessage != null
                    ? _buildErrorWidget()
                    : _isLoading
                        ? const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text('Loading students...'),
                              ],
                            ),
                          )
                        : _students.isEmpty
                            ? const Center(
                                child: Text(
                                  'No students found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                      'Students (${_students.length})',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Expanded(
                                    child: ListView.builder(
                                      itemCount: _students.length,
                                      itemBuilder: (context, index) =>
                                          _buildStudentTile(
                                        _students[index]['name'] ??
                                            'Student ${index + 1}',
                                        index,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
              ),

              // Buttons - only show if we have students
              if (_students.isNotEmpty) ...[
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _selectDueDate,
                        icon: const Icon(Icons.calendar_today, size: 18),
                        label: Text(
                          _dueDate == null
                              ? 'Set Due Date'
                              : 'Due: ${_dueDate!.toLocal()}'.split(' ')[0],
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _assignVideoToStudents,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              )
                            : const Icon(Icons.assignment_turned_in, size: 18),
                        label: Text(
                          _isLoading ? 'Assigning...' : 'Assign Video',
                          style: const TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
