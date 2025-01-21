// lib/view/widgets/media_preview.dart
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'dart:io';

class MediaUploadSection extends StatelessWidget {
  final File? audioFile;
  final File? videoFile;
  final VideoPlayerController? videoController;
  final bool isVideoPlaying;
  final VoidCallback onAudioPick;
  final VoidCallback onVideoPick;
  final VoidCallback onVideoPlayPause;


  const MediaUploadSection({
    Key? key,
    required this.audioFile,
    required this.videoFile,
    required this.videoController,
    required this.isVideoPlaying,
    required this.onAudioPick,
    required this.onVideoPick,
    required this.onVideoPlayPause,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'Upload Recordings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _UploadCard(
                title: 'Voice Recording',
                icon: Icons.mic,
                isUploaded: audioFile != null,
                onTap: onAudioPick,
                fileName: audioFile?.path.split('/').last,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _UploadCard(
                title: 'Video Recording',
                icon: Icons.videocam,
                isUploaded: videoFile != null,
                onTap: onVideoPick,
                fileName: videoFile?.path.split('/').last,
              ),
            ),
          ],
        ),
        if (videoController != null && videoController!.value.isInitialized) ...[
          const SizedBox(height: 24),
          const Text(
            'Video Preview',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: AspectRatio(
                  aspectRatio: videoController!.value.aspectRatio,
                  child: VideoPlayer(videoController!),
                ),
              ),
              IconButton(
                onPressed: onVideoPlayPause,
                icon: Icon(
                  isVideoPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 48,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: VideoProgressIndicator(
                  videoController!,
                  allowScrubbing: true,
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}



// lib/view/widgets/media_preview.dart
// Add this widget inside the file

class VideoPreviewPlayer extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPreviewPlayer({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AspectRatio(
            aspectRatio: controller.value.aspectRatio,
            child: Stack(
              alignment: Alignment.center,
              children: [
                VideoPlayer(controller),
                GestureDetector(
                  onTap: () {
                    if (controller.value.isPlaying) {
                      controller.pause();
                    } else {
                      controller.play();
                    }
                  },
                  child: Container(
                    color: Colors.black26,
                    child: Icon(
                      controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton.icon(
              onPressed: () {
                controller.value.isPlaying
                    ? controller.pause()
                    : controller.play();
              },
              icon: Icon(
                controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              ),
              label: Text(
                controller.value.isPlaying ? 'Pause' : 'Play',
              ),
            ),
            TextButton.icon(
              onPressed: () {
                controller.seekTo(Duration.zero);
                controller.play();
              },
              icon: const Icon(Icons.replay),
              label: const Text('Replay'),
            ),
          ],
        ),
      ],
    );
  }
}



class _UploadCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isUploaded;
  final VoidCallback onTap;
  final String? fileName;

  const _UploadCard({
    required this.title,
    required this.icon,
    required this.isUploaded,
    required this.onTap,
    this.fileName,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isUploaded ? Theme.of(context).primaryColor : Colors.grey.shade300,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isUploaded ? Icons.check_circle : icon,
                size: 32,
                color: isUploaded ? Theme.of(context).primaryColor : Colors.grey.shade600,
              ),
              const SizedBox(height: 12),
              Text(
                isUploaded ? 'File Added' : title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isUploaded ? Theme.of(context).primaryColor : Colors.grey.shade700,
                ),
              ),
              if (fileName != null) ...[
                const SizedBox(height: 8),
                Text(
                  fileName!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ResultsSection extends StatelessWidget {
  final String mlResult;
  final String? doctorResponse;

  const ResultsSection({
    Key? key,
    required this.mlResult,
    this.doctorResponse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: Theme.of(context).primaryColor.withOpacity(0.2),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.analytics_outlined,
                  color: Theme.of(context).primaryColor,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Analysis Results',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                mlResult,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            if (doctorResponse != null) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Icon(
                    Icons.medical_services_outlined,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Doctor\'s Response',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doctorResponse!,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}