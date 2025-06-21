import 'package:flutter/material.dart';
import 'package:lifelab3/src/common/widgets/common_appbar.dart';
import 'package:provider/provider.dart';
import '../providers/vision_provider.dart';
import '../models/vision_video.dart';
import 'filter_page.dart';
import 'video_player.dart';

class VisionPage extends StatefulWidget {
  final String navName;
  final String subjectName;
  final String levelId;
  const VisionPage({
    super.key,
    required this.navName,
    required this.subjectName,
    required this.levelId
  });


  @override
  State<VisionPage> createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  @override
  void initState() {
    super.initState();

    // Fetch videos when page loads, but only if there aren't any videos yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('xssss ${widget.subjectName}');
      final provider = Provider.of<VisionProvider>(context, listen: false);

      provider.initWithSubject(widget.subjectName , widget.levelId);

      // Output current state for debugging
      debugPrint('VisionPage: isLoading=${provider.isLoading}, '
          'videoCount=${provider.videos.length}, '
          'error="${provider.error}"');
    });
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: commonAppBar(
        context: context,
        name: {
          '1': 'Science',
          '2': 'Maths',
          '12': 'Financial Literacy',
        }[widget.subjectName] ?? widget.subjectName,
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

  Widget _buildSearchFilterBar(BuildContext context, VisionProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          // Filter button
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
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
    Color statusBgColor;
    if (video.status == 'completed') {
      statusBgColor = Colors.green;
    } else if (video.status == 'pending') {
      statusBgColor = Colors.red;
    } else {
      statusBgColor = Colors.blue;
    }

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
                            .withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        video.teacherAssigned ? 'Teacher Assigned' : video.status,
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
            subjectName: widget.subjectName,
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