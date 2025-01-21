// lib/view/pages/homepage.dart
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:video_player/video_player.dart';
import '../widgets/media_preview.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  File? audioFile;
  File? videoFile;
  VideoPlayerController? _videoController;
  bool isAnalyzing = false;
  String? mlResult;
  String? doctorResponse;
  bool isVideoPlaying = false;



  void handleVideoPlayPause() {
    if (_videoController == null) return;

    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        isVideoPlaying = false;
      } else {
        _videoController!.play();
        isVideoPlaying = true;
      }
    });
  }


  Future<void> pickAudioFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          audioFile = File(result.files.single.path!);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Audio file uploaded successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading audio file'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> pickVideoFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.video,
        allowMultiple: false,
      );

      if (result != null) {
        setState(() {
          videoFile = File(result.files.single.path!);
          isVideoPlaying = false;  // Reset video playing state
        });

        // Initialize video player
        _videoController?.dispose(); // Dispose previous controller if exists
        _videoController = VideoPlayerController.file(videoFile!)
          ..initialize().then((_) {
            setState(() {}); // Rebuild to show video preview
          });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Video file uploaded successfully'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error uploading video file'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> analyzeData() async {
    if (audioFile == null || videoFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload both audio and video files'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() {
      isAnalyzing = true;
    });

    // TODO: Implement ML model analysis
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      mlResult = "Preliminary ML Analysis: High probability of Parkinson's detected";
      isAnalyzing = false;
    });
  }

  @override
  void dispose() {
    _videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Parkinsons Disease Detection',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MediaUploadSection(
              audioFile: audioFile,
              videoFile: videoFile,
              videoController: _videoController,
              isVideoPlaying: isVideoPlaying,  // Add this
              onVideoPlayPause: handleVideoPlayPause,  // Add this
              onAudioPick: pickAudioFile,
              onVideoPick: pickVideoFile,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isAnalyzing ? null : analyzeData,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: isAnalyzing
                  ? const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  SizedBox(width: 12),
                  Text('Analyzing...'),
                ],
              )
                  : const Text('Analyze Data'),
            ),
            if (mlResult != null) ...[
              const SizedBox(height: 24),
              ResultsSection(
                mlResult: mlResult!,
                doctorResponse: doctorResponse,
              ),
            ],
          ],
        ),
      ),
    );
  }
}