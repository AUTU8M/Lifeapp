import 'package:flutter/material.dart';
import 'package:lifelab3/src/student/home/models/campaign_model.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../subject_level_list/presentation/pages/quiz_topic_list_page.dart';
import '../../../subject_level_list/provider/subject_level_provider.dart';
import '../../provider/dashboard_provider.dart';
import '../../../vision/models/vision_video.dart';
import '../../../vision/presentations/video_player.dart';
import '../../../vision/providers/vision_provider.dart';
import 'package:lifelab3/src/student/mission/presentations/pages/submit_mission_page.dart';
import 'package:lifelab3/src/student/subject_level_list/models/mission_list_model.dart';
import 'dart:async';

class CampaignSliderWidget extends StatefulWidget {
  const CampaignSliderWidget({super.key});

  @override
  State<CampaignSliderWidget> createState() => _CampaignSliderWidgetState();
}

class _CampaignSliderWidgetState extends State<CampaignSliderWidget> {
  final PageController _pageController = PageController();
  Timer? _autoSlideTimer;
  int _currentPage = 0;


  Future<void> _handleCampaignTap(Campaign campaign) async {
    debugPrint("🟡 Campaign tapped:");
    debugPrint("🟡 title: ${campaign.title}");
    debugPrint("🟡 gameType(raw): ${campaign.gameType}");
    debugPrint("🟡 referenceId(raw): ${campaign.referenceId}");
    debugPrint("🟡 subjectId: ${campaign.subjectId}");
    debugPrint("🟡 levelId: ${campaign.levelId}");

    final int gameId = campaign.gameType;
    final int referenceId = campaign.referenceId;
    final String subjectId = campaign.subjectId;
    final String levelId = campaign.levelId;

    if (gameId == null || referenceId== null) {
      debugPrint("🔴 Invalid gameId or referenceId: gameId=$gameId, refId=$referenceId");
      Fluttertoast.showToast(msg: "Invalid campaign data");
      return;
    }
    debugPrint("🟢 Proceeding with campaign gameId=$gameId, refId=$referenceId");
    if (gameId == 7) {
      // Vision campaign
      debugPrint("Campaign type: Vision");

      final visionProvider = Provider.of<VisionProvider>(context, listen: false);
      VisionVideo? video;

      // You can modify subjectId param here if needed; now passing empty string as in your example
      for (int level = 1; level <= 4; level++) {
        debugPrint("Trying level $level for vision referenceId $referenceId");

        await visionProvider.initWithSubject(subjectId, levelId);

        // Print all loaded videos IDs and titles to debug
        debugPrint("Loaded videos at level $level:");
        for (var videoItem in visionProvider.videos) {
          debugPrint(" - Video ID: ${videoItem.id}, Title: ${videoItem.title}");
        }
        video = visionProvider.getVideoById(referenceId.toString());
        if (video != null) {
          debugPrint("Video found at level $level: ${video.title}");
          break;
        }
      }
      if (video == null) {
        debugPrint("No video found for referenceId $referenceId");
        Fluttertoast.showToast(msg: "Video not found for this campaign");
        return;
      }
      Navigator.of(context, rootNavigator: true).push(
        MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider.value(
            value: visionProvider,
            child: VideoPlayerPage(
              video: video!,
              navName: "Campaign",
              subjectId: subjectId,
              onVideoCompleted: () {},
            ),
          ),
        ),
      );
    }else if (gameId == 2) {
      debugPrint("📘 Campaign type: Quiz");
      debugPrint("📘 Attempting to fetch quiz topics for:");
      debugPrint("   ▶ Subject ID: $subjectId");
      debugPrint("   ▶ Level ID: $levelId");
      debugPrint("   ▶ Reference ID (topicId from DB): $referenceId");

      final subjectLevelProvider = Provider.of<SubjectLevelProvider>(context, listen: false);

      try {
        await subjectLevelProvider.getQuizTopic({
          "la_subject_id": subjectId,
          "la_level_id": levelId,
          "type" : gameId,
        });

        // Print all loaded quiz topic IDs and titles
        final topics = subjectLevelProvider.quizTopicModel?.data?.laTopics ?? [];
        debugPrint("📘 Loaded ${topics.length} quiz topics:");
        for (var topic in topics) {
          debugPrint("   🔹 ID: ${topic.id}, Title: ${topic.title}");
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QuizTopicListPage(
              provider: subjectLevelProvider,
              subjectId: subjectId,
              levelId: levelId,
              filterTopicId: referenceId,
            ),
          ),
        );
      } catch (e) {
        debugPrint("❌ Failed to load quiz topics: $e");
        Fluttertoast.showToast(msg: "Failed to load quiz topics");
      }
    }

    else if (gameId == 1) {
      debugPrint("Campaign type: Mission");

      final missionProvider = Provider.of<SubjectLevelProvider>(
          context, listen: false);

      final missionData = {
        "type": 1,
        "la_subject_id": campaign.subjectId,
        "la_level_id": campaign.levelId,
      };

      await missionProvider.getMission(missionData);

      final missionModel = missionProvider.missionListModel;

      if (missionModel != null && missionModel.data != null) {
        final referenceId = campaign.referenceId;
        final allMissions = missionModel.data?.missions?.data ?? [];

        MissionDatum? targetMission;
        try {
          targetMission = allMissions.firstWhere(
                (m) => m.id.toString() == referenceId.toString(),
          );
        } catch (e) {
          targetMission = null;
        }

        if (targetMission != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  SubmitMissionPage(mission: targetMission!), // Use '!' here
            ),
          );
        } else {
          Fluttertoast.showToast(msg: "Mission not found");
        }
      }
    }

      else {
      debugPrint("Unknown gameId: $gameId");
      Fluttertoast.showToast(msg: "Unknown campaign type");
    }
  }

  @override
  void initState() {
    super.initState();
    _startAutoSlide(); // 👈 Start the auto-slide timer
  }
  void _startAutoSlide() {
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients && mounted) {
        setState(() {
          _currentPage++;
          if (_currentPage >= Provider.of<DashboardProvider>(context, listen: false).campaigns.length) {
            _currentPage = 0;
          }
          _pageController.animateToPage(
            _currentPage,
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  void dispose() {
    _autoSlideTimer?.cancel(); // 👈 cancel timer to prevent memory leaks
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final campaigns = Provider.of<DashboardProvider>(context).campaigns;
    if (campaigns.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: campaigns.length,
            onPageChanged: (index) => _currentPage = index, // 👈 update current page index
            itemBuilder: (context, index)
            {
              final campaign = campaigns[index];
              return GestureDetector(
                onTap: () => _handleCampaignTap(campaign),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: campaign.imageUrl != null && campaign.imageUrl.isNotEmpty
                          ? Image.network(
                        campaign.imageUrl,
                        width: double.infinity,
                        height: 220,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildFallbackImage();
                        },
                      )
                          : _buildFallbackImage(),
                    ),
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 12,
                      right: 12,
                      bottom: 12,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  campaign.title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  campaign.description,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _handleCampaignTap(campaign),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                                side: const BorderSide(
                                  color: Colors.blue,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  campaign.buttonName.isNotEmpty ? campaign.buttonName : "Start",
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(width: 2),
                                const Icon(Icons.arrow_forward, size: 14),
                              ],
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
        const SizedBox(height: 10),
        SmoothPageIndicator(
          controller: _pageController,
          count: campaigns.length,
          effect: ExpandingDotsEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue,
            dotColor: Colors.grey.shade300,
          ),
        ),
      ],
    );
  }

  Widget _buildFallbackImage() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: const Icon(
        Icons.broken_image,
        size: 80,
        color: Colors.grey,
      ),
    );
  }
}
