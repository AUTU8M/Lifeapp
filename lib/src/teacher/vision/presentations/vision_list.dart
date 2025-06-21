import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../models/vision_model.dart';
import '../providers/vision_provider.dart';
import 'video_player.dart';
import 'vision_review.dart';

class VisionPage extends StatefulWidget {
  final String navName;
  final String subjectName;
  final int? initialTabIndex;
  final String sectionId;
  final String gradeId;
  final String classId;

  const VisionPage({
    Key? key,
    required this.navName,
    required this.subjectName,
    required this.sectionId,
    required this.gradeId,
    required this.classId,
    this.initialTabIndex,
  }) : super(key: key);

  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _subjectFilter = '';
  String _levelFilter = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex ?? 0,
    );
    
    // Debug: Print the sectionId to verify it's being passed
    print('VisionPage sectionId: ${widget.sectionId}');
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToVideoPlayer(TeacherVisionVideo video) {
    // Check if sectionId is available
    if (widget.sectionId.isEmpty) {
      _showSectionErrorDialog();
      return;
    }

    final visionProvider = Provider.of<VisionProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: visionProvider,
          child: TeacherVideoPlayerPage(
            video: video,
            sectionId: widget.sectionId,
            gradeId: widget.gradeId,
            classId: widget.classId,
            onBack: () {
              setState(() {});
            },
          ),
        ),
      ),
    );
  }

  void _navigateToVisionReview(TeacherVisionVideo video) {
    final visionProvider = Provider.of<VisionProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: visionProvider,
          child: VisionReviewPage(video: video),
        ),
      ),
    );
  }

  void _showSectionErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Section Required'),
          content: const Text(
            'Section information is not available. Please navigate from the main Vision page or select a specific class section first.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Go back to previous page
              },
              child: const Text('Go Back'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFilterChip(String label, String selectedValue,
      Function(String) onChanged, List<String> options) {
    return PopupMenuButton<String>(
      onSelected: (value) => onChanged(value == 'All' ? '' : value),
      itemBuilder: (context) => [
        const PopupMenuItem(value: 'All', child: Text('All')),
        ...options
            .map((option) => PopupMenuItem(value: option, child: Text(option))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selectedValue.isEmpty ? Colors.white : const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selectedValue.isEmpty
                ? Colors.grey[300]!
                : const Color(0xFF6366F1),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selectedValue.isEmpty ? label : selectedValue,
              style: TextStyle(
                fontSize: 12,
                color: selectedValue.isEmpty ? Colors.grey[700] : Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: selectedValue.isEmpty ? Colors.grey[700] : Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer <VisionProvider>(
      builder: (context, provider, child) {
        // Get dynamic filter options from provider
        final availableSubjects = provider.getAvailableSubjects();
        final availableLevels = provider.getAvailableLevels();

        return Scaffold(
          backgroundColor: const Color(0xFFF8FAFC),
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Vision',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                // Show section info if available
                if (widget.sectionId.isNotEmpty)
                  Text(
                    'Section: ${widget.sectionId}',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh, color: Colors.black),
                onPressed: () => provider.refreshVideos(),
              ),
            ],
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(100),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    child: TabBar(
                      controller: _tabController,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF6366F1),
                      indicator: BoxDecoration(
                        color: const Color.fromARGB(255, 99, 177, 241),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerColor: Colors.transparent,
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      tabs: const [
                        Tab(text: 'All Vision'),
                        Tab(text: 'Track Assigned Vision'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        _buildFilterChip('Subject', _subjectFilter, (value) {
                          setState(() => _subjectFilter = value);
                          provider.setSubjectFilter(value);
                        }, availableSubjects),
                        const SizedBox(width: 8),
                        _buildFilterChip('Level', _levelFilter, (value) {
                          setState(() => _levelFilter = value);
                          provider.setLevelFilter(value);
                        }, availableLevels),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey[300]!),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                hintText: 'Search...',
                                hintStyle: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey[500],
                                  size: 20,
                                ),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              style: const TextStyle(fontSize: 14),
                              onChanged: (value) {
                                provider.setSearchQuery(value);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildVideoList(provider.filteredNonAssignedVideos, false),
              provider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _buildVideoList(provider.filteredAssignedVideos, true),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVideoList(List<TeacherVisionVideo> videos, bool isAssignedTab) {
    if (videos.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.video_library_outlined, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No videos available',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          Provider.of<VisionProvider>(context, listen: false).refreshVideos(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final videoId =
              YoutubePlayer.convertUrlToId(video.youtubeUrl) ?? 'dQw4w9WgXcQ';

          return GestureDetector(
            onTap: () => !isAssignedTab ? _navigateToVideoPlayer(video) : null,
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: isAssignedTab
                  ? _buildAssignedVideoCard(video, videoId)
                  : _buildRegularVideoCard(video, videoId),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRegularVideoCard(TeacherVisionVideo video, String videoId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Video thumbnail with rounded corners
        ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
          child: Stack(
            children: [
              Image.network(
                video.thumbnailUrl.isNotEmpty
                    ? video.thumbnailUrl
                    : 'https://img.youtube.com/vi/$videoId/0.jpg',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.grey,
                        size: 50,
                      ),
                    ),
                  );
                },
              ),
              // Play button overlay
              Positioned.fill(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black.withOpacity(0.6),
                    ),
                    child: const Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Assign',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        // Video details section
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                video.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (video.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  video.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF8B5CF6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      video.subject,
                      style: const TextStyle(
                        color: Color(0xFF8B5CF6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B82F6).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      video.level,
                      style: const TextStyle(
                        color: Color(0xFF3B82F6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAssignedVideoCard(TeacherVisionVideo video, String videoId) {
    return GestureDetector(
      onTap: () => _navigateToVideoPlayer(video),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Left side - Thumbnail with gradient overlay
            SizedBox(
              width: 120,
              height: 80,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  children: [
                    // Background image
                    Positioned.fill(
                      child: Image.network(
                        video.thumbnailUrl.isNotEmpty
                            ? video.thumbnailUrl
                            : 'https://img.youtube.com/vi/$videoId/0.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    // Light gradient overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xFF87CEEB).withOpacity(0.3),
                              const Color(0xFFFFB6C1).withOpacity(0.4),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Colorful paper airplane

                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Middle - Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    video.title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      height: 1.2,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  // Description
                  Text(
                    video.description.isNotEmpty
                        ? video.description
                        : 'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Right side - Submission count and Review button
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Review button
                ElevatedButton(
                  onPressed: () => _navigateToVisionReview(video),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6366F1),
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                    minimumSize: const Size(75, 32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                  child: const Text(
                    'Review',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}