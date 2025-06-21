import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:provider/provider.dart';
import '../models/vision_model.dart';
import '../providers/vision_provider.dart';
import 'student_assign.dart';
import 'package:lifelab3/src/teacher/teacher_dashboard/provider/teacher_dashboard_provider.dart';

class TeacherVideoPlayerPage extends StatefulWidget {
  final TeacherVisionVideo video;
  final VoidCallback? onBack;
  final String sectionId;
  final String gradeId;
  final String classId;

  const TeacherVideoPlayerPage({
    Key? key,
    required this.video,
    this.onBack,
    required this.sectionId,
    required this.gradeId,
    required this.classId,
  }) : super(key: key);

  @override
  State<TeacherVideoPlayerPage> createState() => _TeacherVideoPlayerPageState();
}

class _TeacherVideoPlayerPageState extends State<TeacherVideoPlayerPage> {
  late YoutubePlayerController _controller;
  bool _isMuted = false;
  bool _isPlaying = true;
  bool _isPlayerReady = false;
  bool _isVideoPlaying = false; // New flag to track if video has started playing
  double _currentPosition = 0;
  double _videoDuration = 1;
  bool _showOverlay = true;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    final videoId = YoutubePlayer.convertUrlToId(widget.video.youtubeUrl) ?? '';
    _controller = YoutubePlayerController(
      initialVideoId: videoId.isNotEmpty ? videoId : 'dQw4w9WgXcQ',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        hideControls: true,
        loop: false,
        disableDragSeek: false,
        enableCaption: false,
      ),
    );
    _controller.setPlaybackRate(1.0);
    _controller.addListener(_videoListener);
  }

  void _videoListener() {
    if (_isPlayerReady && mounted) {
      final position = _controller.value.position.inMilliseconds / 1000;
      final duration = _controller.metadata.duration.inMilliseconds / 1000;

      // Check if video has started playing
      if (!_isVideoPlaying && position > 0) {
        setState(() {
          _isVideoPlaying = true;
        });
      }

      if (position != _currentPosition || duration != _videoDuration) {
        setState(() {
          _currentPosition = position;
          if (duration > 0) _videoDuration = duration;
        });
      }

      if (_isFullscreen != _controller.value.isFullScreen) {
        setState(() {
          _isFullscreen = _controller.value.isFullScreen;
          _showOverlay = true;
        });

        if (_isFullscreen) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          _startOverlayTimer();
        } else {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
        }
      }
    }
  }

  void _startOverlayTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      if (_isFullscreen && mounted) {
        setState(() => _showOverlay = false);
      }
    });
  }

  void _toggleOverlay() {
    setState(() => _showOverlay = !_showOverlay);
    if (_showOverlay && _isFullscreen) {
      _startOverlayTimer();
    }
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _controller.removeListener(_videoListener);
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_isPlaying) {
      _controller.pause();
    } else {
      _controller.play();
    }
    setState(() => _isPlaying = !_isPlaying);
  }

  String _formatDuration(double seconds) {
    final Duration duration = Duration(seconds: seconds.round());
    final String minutes =
    duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final String secs =
    duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$secs";
  }

  void _handleBackButton() {
    if (_isFullscreen) {
      _controller.toggleFullScreenMode();
    } else {
      if (widget.onBack != null) {
        widget.onBack!();
      }
      Navigator.pop(context);
    }
  }

  void _navigateToAssignPage() {
    _controller.pause();
    final visionProvider = Provider.of<VisionProvider>(context, listen: false);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MultiProvider(
          providers: [
            ChangeNotifierProvider<VisionProvider>.value(
              value: visionProvider,
            ),
            ChangeNotifierProvider<TeacherDashboardProvider>.value(
              value:
              Provider.of<TeacherDashboardProvider>(context, listen: false),
            ),
          ],
          child: StudentAssignPage(
            videoTitle: widget.video.title,
            videoId: widget.video.id,
            gradeId: widget.gradeId,
            subjectId: '2',
            sectionId: widget.sectionId,
            classId: widget.classId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: !_isFullscreen,
      onPopInvoked: (didPop) {
        if (!didPop && _isFullscreen) {
          _controller.toggleFullScreenMode();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleOverlay,
          child: Stack(
            children: [
              // Always build the player
              Center(
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: YoutubePlayer(
                    controller: _controller,
                    showVideoProgressIndicator: false,
                    progressColors: const ProgressBarColors(
                      playedColor: Colors.deepPurple,
                      handleColor: Colors.deepPurpleAccent,
                    ),
                    onReady: () {
                      setState(() {
                        _isPlayerReady = true;
                        if (_controller.metadata.duration.inMilliseconds > 0) {
                          _videoDuration =
                              _controller.metadata.duration.inMilliseconds / 1000;
                        }
                      });
                    },
                    bottomActions: const [],
                  ),
                ),
              ),

              // Show preloader until video actually starts playing
              if (!_isVideoPlaying)
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: Colors.black,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.deepPurple),
                  ),
                ),

              // Show overlay controls when not in fullscreen OR when overlay is visible in fullscreen
              if ((!_isFullscreen || (_isFullscreen && _showOverlay))&& _isVideoPlaying) ...[
                // Top navigation bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back,
                                color: Colors.white),
                            onPressed: _handleBackButton,
                          ),
                          const Text(
                            'Vision',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Video title and tags (only show in portrait mode)
                if (!_isFullscreen)
                  Positioned(
                    bottom: 200,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.video.title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(1, 1),
                                blurRadius: 3.0,
                                color: Color.fromARGB(150, 0, 0, 0),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              margin: const EdgeInsets.only(top: 8, right: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.deepPurple.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.video.subject,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                widget.video.level,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                  ),

                // Video controls (progress bar and time)
                Positioned(
                  bottom: _isFullscreen
                      ? 60
                      : MediaQuery.of(context).size.height * 0.4 - 200,
                  left: 3,
                  right: 3,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatDuration(_currentPosition),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                              Text(_formatDuration(_videoDuration),
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 12)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                          child: SliderTheme(
                            data: SliderThemeData(
                              trackHeight: 4,
                              thumbShape: const RoundSliderThumbShape(
                                  enabledThumbRadius: 6),
                              overlayShape: const RoundSliderOverlayShape(
                                  overlayRadius: 12),
                              activeTrackColor: Colors.deepPurple,
                              inactiveTrackColor: Colors.grey.withOpacity(0.5),
                              thumbColor: Colors.deepPurpleAccent,
                            ),
                            child: Slider(
                              min: 0,
                              max: _videoDuration > 0 ? _videoDuration : 100,
                              value: _currentPosition.clamp(0, _videoDuration),
                              onChanged: (value) =>
                                  setState(() => _currentPosition = value),
                              onChangeEnd: (value) => _controller.seekTo(
                                  Duration(
                                      milliseconds: (value * 1000).toInt())),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Play/Pause button
                // Play/Pause button
                Positioned(
                  bottom: _isFullscreen
                      ? 100
                      : MediaQuery.of(context).size.height * 0.21,
                  left: 5,
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Colors.white),
                      onPressed: _togglePlayPause,
                      padding: EdgeInsets.zero,
                      iconSize: 24,
                    ),
                  ),
                ),


                // Mute and Fullscreen buttons
                Positioned(
                  right: 5,
                  bottom: _isFullscreen
                      ? 100
                      : MediaQuery.of(context).size.height * 0.21,
                  child: Row(
                    children: [
                      Container(
                        height: 40,
                        width: 40,
                        margin: const EdgeInsets.only(right: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: Icon(
                              _isMuted ? Icons.volume_off : Icons.volume_up,
                              color: Colors.white),
                          onPressed: () {
                            setState(() {
                              _isMuted = !_isMuted;
                              _isMuted
                                  ? _controller.mute()
                                  : _controller.unMute();
                            });
                          },
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                        ),
                      ),
                      Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon:
                          const Icon(Icons.fullscreen, color: Colors.white),
                          onPressed: () => _controller.toggleFullScreenMode(),
                          padding: EdgeInsets.zero,
                          iconSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),

                // Assign Vision button (only show in portrait mode and if not assigned)
                if (!_isFullscreen && !widget.video.teacherAssigned)
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton.icon(
                        onPressed: _navigateToAssignPage,
                        icon: const Icon(Icons.assignment, color: Colors.white),
                        label: const Text("Assign Vision"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}