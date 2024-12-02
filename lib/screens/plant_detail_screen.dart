import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:audioplayers/audioplayers.dart';
import '../models/plant_model.dart';

class PlantDetailScreen extends StatefulWidget {
  final Plant plant;

  const PlantDetailScreen({Key? key, required this.plant}) : super(key: key);

  @override
  State<PlantDetailScreen> createState() => _PlantDetailScreenState();
}

class _PlantDetailScreenState extends State<PlantDetailScreen> {
  late VideoPlayerController _videoController;
  late AudioPlayer _audioPlayer;
  bool _isPlayingAudio = false;

  @override
  void initState() {
    super.initState();

    // Initialize video controller
    _videoController = VideoPlayerController.network(widget.plant.videoUrl)
      ..initialize().then((_) {
        setState(() {}); // Rebuild UI after initialization
      });

    // Initialize audio player
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _videoController.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.plant.name), // Display plant name as the AppBar title
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Display plant image
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              widget.plant.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Text("No image available."),
              ),
            ),
          ),
          const SizedBox(height: 16.0),
          // Display plant description
          Text(
            widget.plant.description,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 16.0),
          // Render 3D model
          if (widget.plant.modelUrl.isNotEmpty && widget.plant.modelUrl.endsWith('.gltf'))
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "3D Model:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                SizedBox(
                  height: 300,
                  child: ModelViewer(
                    src: widget.plant.modelUrl, // URL of the .gltf file
                    alt: "A 3D model of ${widget.plant.name}",
                    ar: false, // Enable AR mode
                    autoRotate: true, // Automatically rotate the model
                    cameraControls: true,
                    backgroundColor: Colors.red,
                    
                     // Enable camera controls
                  ),
                  
                ),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No 3D model available."),
              ),
            ),
          const SizedBox(height: 16.0),
          // Render video
          if (_videoController.value.isInitialized)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Video:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                AspectRatio(
                  aspectRatio: _videoController.value.aspectRatio,
                  child: VideoPlayer(_videoController),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _videoController.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      onPressed: () {
                        setState(() {
                          if (_videoController.value.isPlaying) {
                            _videoController.pause();
                          } else {
                            _videoController.play();
                          }
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        setState(() {
                          _videoController.pause();
                          _videoController.seekTo(Duration.zero);
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No video available."),
              ),
            ),
          const SizedBox(height: 16.0),
          // Render audio player
          if (widget.plant.audioUrl.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Audio:",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(
                        _isPlayingAudio ? Icons.pause : Icons.play_arrow,
                      ),
                      onPressed: () async {
                        setState(() {
                          if (_isPlayingAudio) {
                            _audioPlayer.pause();
                          } else {
                            _audioPlayer.play(UrlSource(widget.plant.audioUrl));
                          }
                          _isPlayingAudio = !_isPlayingAudio;
                        });
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        _audioPlayer.stop();
                        setState(() {
                          _isPlayingAudio = false;
                        });
                      },
                    ),
                  ],
                ),
              ],
            )
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("No audio available."),
              ),
            ),
        ],
      ),
    );
  }
}
