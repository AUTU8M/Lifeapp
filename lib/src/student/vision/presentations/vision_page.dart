import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/helper/string_helper.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:provider/provider.dart';
import '../providers/vision_provider.dart';
import '../models/vision_video.dart';
import 'filter_page.dart';
import 'video_player.dart';

class VisionPage extends StatefulWidget {
  final String navName;
  final String subjectId;
  final String levelId;
  const VisionPage({
    super.key,
    required this.navName,
    required this.subjectId,
    required this.levelId
  });


  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<VisionProvider>(context, listen: false);
      print("subject ${widget.subjectId}");

      print('Loaded videos: ${provider.videos.length}');
      print('Current Level ID: ${widget.levelId}');
      // Fetch videos first
      await provider.initWithSubject(widget.subjectId, widget.levelId);

      print('Is current level completed? ${provider.isCurrentLevelCompleted()}');
      // Then check if level is completed
      final currentLevel = int.tryParse(widget.levelId ?? '');
      const finalLevel = 4; // or make dynamic later

      if (provider.isCurrentLevelCompleted()) {
        String message = currentLevel == finalLevel
            ? '🎉 Congratulations!\nYou have completed all levels!'
            : '✅ You have successfully completed Level $currentLevel!';
        if (context.mounted) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.emoji_events,
                        color: Colors.amber.shade600,
                        size: 60,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "Level Complete!",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () {
                            Navigator.pop(context); // close dialog

                            final nextLevel = (int.tryParse(widget.levelId) ?? 1) + 1;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VisionPage(
                                  navName: widget.navName,
                                  subjectId: widget.subjectId,
                                  levelId: nextLevel.toString(),
                                ),
                              ),
                            );
                          },
                          child: const Text("Continue to Level 2",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600,color: Colors.white ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: StringHelper.navName,
      ),

      body: Consumer<VisionProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              _buildSearchFilterBar(context, provider),
              Expanded(
                child: _buildVisionCardsList(context, provider),
              ),
            ],
          );
        },
      ),
    );
  }
  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.black;
      case 'pending':
        return Colors.black;
      case 'submitted':
        return Colors.black;
      case 'rejected':
        return Colors.black; // you can use red or orange based on UI preference
      case 'skipped':
        return Colors.black;
      default:
        return Colors.black;
    }
  }

  String _getStatusLabel(VisionVideo video) {
    if (video.teacherAssigned && video.status == 'submitted') {
      return 'Submitted';
    }
    return video.status[0].toUpperCase() + video.status.substring(1);
  }

  Widget _buildSearchFilterBar(BuildContext context, VisionProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Filter button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.black12),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_alt_outlined),
              onPressed: () {
                _showFilterPage(context, provider);
              },
            ),
          ),
          const SizedBox(width: 12),
          // Search bar
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey.shade200,
              ),
              onChanged: (value) {
                provider.setSearchText(value);
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildVisionCardsList(BuildContext context, VisionProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.error.isNotEmpty && provider.videos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(provider.error, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchVideos(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final filteredVideos = provider.filteredVideos;
    if (filteredVideos.isEmpty) {
      return const Center(
        child: Text('No vision videos found', style: TextStyle(fontSize: 16)),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchVideos(),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        itemCount: filteredVideos.length,
        itemBuilder: (context, index) {
          final video = filteredVideos[index];
          return _buildVisionVideoCard(
            context,
            video: video,
            provider: provider,
          );
        },
      ),
    );
  }

  Widget _buildVisionVideoCard(
    BuildContext context, {
    required VisionVideo video,
    required VisionProvider provider,
  }) {
    final statusBgColor = _getStatusColor(video.status);

    return InkWell(
      onTap: () {
        _navigateToVideoPlayer(context, video, provider);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Stack(
                children: [
                  FadeInImage.assetNetwork(
                    placeholder: 'assets/images/video_placeholder.png',
                    image: video.thumbnailUrl,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 180,
                        width: double.infinity,
                        color: Colors.pink.shade100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.video_library,
                                  size: 50, color: Colors.pink.shade300),
                              const SizedBox(height: 8),
                              Text(
                                'Video Preview',
                                style: TextStyle(color: Colors.pink.shade800),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  Positioned.fill(
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 255, 255, 255)
                            .withOpacity(0.9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _getStatusLabel(video),
                        style: TextStyle(
                          color: statusBgColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),

                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
              child: Text(
                video.title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                video.description,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToVideoPlayer(
      BuildContext context, VisionVideo video, VisionProvider provider) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider.value(
          value: provider,
          child: VideoPlayerPage(
            video: video,
            navName: widget.navName,
            subjectId: widget.subjectId,
            onVideoCompleted: () {
            },
          ),
        ),
      ),
    );
  }

  void _showFilterPage(BuildContext context, VisionProvider provider) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FilterPage(
          onApplyFilters: (filters) {
            provider.setFilters(filters);
          },
          initialFilters: provider.activeFilters ?? {},
        ),
      ),
    );

    if (result != null && result is Map<String, bool>) {
      provider.setFilters(result);
    }
  }
}