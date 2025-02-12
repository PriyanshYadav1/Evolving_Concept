import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class MediaPlayerPage extends StatefulWidget {
  @override
  _MediaPlayerPageState createState() => _MediaPlayerPageState();
}

class _MediaPlayerPageState extends State<MediaPlayerPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  bool _isPlayingAudio = false;
  bool _isPlayingVideo = false;
  bool _isNetworkAudio = false;
  bool _isNetworkVideo = false;
  String _currentAudio = '';
  String _currentVideo = '';

  String _localAudioPath = '';
  String _localVideoPath = '';
  bool _isPermissionGranted = false;
  bool _isAudioBuffering = false; // To track if audio is buffering

  @override
  void initState() {
    super.initState();
    _requestPermissions();

    // Listen to playbackStateStream to track buffering
    _audioPlayer.playbackStateStream.listen((playbackState) {
      if (playbackState.processingState == ProcessingState.buffering) {
        setState(() {
          _isAudioBuffering = true;
        });
      } else {
        setState(() {
          _isAudioBuffering = false;
        });
      }
    });
  }

  // Request necessary permissions at runtime
  Future<void> _requestPermissions() async {
    PermissionStatus storagePermission = await Permission.audio.request();

    if (storagePermission.isGranted) {
      setState(() {
        _isPermissionGranted = true;
      });
      _initializeLocalMedia();
    } else {
      setState(() {
        _isPermissionGranted = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Storage permission is denied. Please enable it in settings."),
      ));
    }
  }

  // Load local media paths if permission is granted
  Future<void> _initializeLocalMedia() async {
    Directory appDocDir = await getApplicationDocumentsDirectory();
    setState(() {
      _localAudioPath = '${appDocDir.path}/sample_audio.mp3'; // Ensure a local file exists here.
      _localVideoPath = '${appDocDir.path}/sample_video.mp4'; // Ensure a local file exists here.
    });
  }

  // Play network audio
  Future<void> _playNetworkAudio(String url) async {
    try {
      await _audioPlayer.setUrl(url);
      await _audioPlayer.play();
      setState(() {
        _isNetworkAudio = true;
        _currentAudio = url;
        _isPlayingAudio = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error playing network audio: $e"),
      ));
    }
  }

  // Play local audio
  Future<void> _playLocalAudio() async {
    try {
      await _audioPlayer.setFilePath(_localAudioPath);
      await _audioPlayer.play();
      setState(() {
        _isNetworkAudio = false;
        _currentAudio = _localAudioPath;
        _isPlayingAudio = true;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error playing local audio: $e"),
      ));
    }
  }

  // Pause audio
  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      _isPlayingAudio = false;
    });
  }

  // Stop audio
  void _stopAudio() async {
    await _audioPlayer.stop();
    setState(() {
      _isPlayingAudio = false;
    });
  }

  // Play network video
  Future<void> _playNetworkVideo(String url) async {
    try {
      _videoPlayerController = VideoPlayerController.network(url)
        ..initialize().then((_) {
          setState(() {
            _isNetworkVideo = true;
            _currentVideo = url;
            _isPlayingVideo = true;
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController!,
              autoPlay: true,
              looping: false,
            );
          });
          _videoPlayerController?.play();
        });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error playing network video: $e"),
      ));
    }
  }

  // Play local video
  Future<void> _playLocalVideo() async {
    try {
      _videoPlayerController = VideoPlayerController.file(File(_localVideoPath))
        ..initialize().then((_) {
          setState(() {
            _isNetworkVideo = false;
            _currentVideo = _localVideoPath;
            _isPlayingVideo = true;
            _chewieController = ChewieController(
              videoPlayerController: _videoPlayerController!,
              autoPlay: true,
              looping: false,
            );
          });
          _videoPlayerController?.play();
        });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error playing local video: $e"),
      ));
    }
  }

  // Pause video
  void _pauseVideo() {
    _videoPlayerController?.pause();
    setState(() {
      _isPlayingVideo = false;
    });
  }

  // Stop video
  void _stopVideo() {
    _videoPlayerController?.pause();
    _videoPlayerController?.seekTo(Duration.zero);
    setState(() {
      _isPlayingVideo = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _audioPlayer.dispose();
    _chewieController?.dispose();
    _videoPlayerController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Media Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (!_isPermissionGranted)
              Column(
                children: [
                  Text(
                    "Permission to access storage is required.",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _requestPermissions,
                    child: Text('Request Permission'),
                  ),
                ],
              ),
            if (_isPermissionGranted)
              Column(
                children: [
                  Text(
                    _isPlayingAudio
                        ? 'Now Playing Audio: ${_currentAudio}'
                        : 'Select an audio to play',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _playNetworkAudio('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
                        child: Text('Play Network Audio'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _playLocalAudio,
                        child: Text('Play Local Audio'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isAudioBuffering
                      ? CircularProgressIndicator()
                      : _isPlayingAudio
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: _pauseAudio,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: _stopAudio,
                      ),
                    ],
                  )
                      : Container(),
                  SizedBox(height: 40),
                  Text(
                    _isPlayingVideo
                        ? 'Now Playing Video: ${_currentVideo}'
                        : 'Select a video to play',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () => _playNetworkVideo('https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4'),
                        child: Text('Play Network Video'),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: _playLocalVideo,
                        child: Text('Play Local Video'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  _isPlayingVideo
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.pause),
                        onPressed: _pauseVideo,
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: _stopVideo,
                      ),
                    ],
                  )
                      : Container(),
                  SizedBox(height: 20),
                  _isPlayingVideo && _chewieController != null
                      ? AspectRatio(
                    aspectRatio: _videoPlayerController!.value.aspectRatio,
                    child: Chewie(controller: _chewieController!),
                  )
                      : Container(),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

extension on AudioPlayer {
  get playbackStateStream => null;
}




// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
//
// class MediaPlayerPage extends StatefulWidget {
//   @override
//   _MediaPlayerPageState createState() => _MediaPlayerPageState();
// }
//
// class _MediaPlayerPageState extends State<MediaPlayerPage> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isPlayingAudio = false;
//   bool _isPlayingVideo = false;
//   bool _isNetworkAudio = false;
//   bool _isNetworkVideo = false;
//   String _currentAudio = '';
//   String _currentVideo = '';
//
//   String _localAudioPath = '';
//   String _localVideoPath = '';
//   bool _isPermissionGranted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }
//
//   // Request necessary permissions at runtime
//   Future<void> _requestPermissions() async {
//     // Request permissions for storage
//     PermissionStatus storagePermission = await Permission.audio.request();
//
//     if (storagePermission.isGranted) {
//       setState(() {
//         _isPermissionGranted = true;
//       });
//       _initializeLocalMedia();
//     } else if (storagePermission.isDenied) {
//       setState(() {
//         _isPermissionGranted = false;
//       });
//       // Optionally, show a message to the user if permission is denied
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Storage permission is denied. Please enable it in settings."),
//       ));
//     } else if (storagePermission.isPermanentlyDenied) {
//       // Handle case where the user has permanently denied permission
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Storage permission is permanently denied. Please enable it in settings."),
//       ));
//     }
//   }
//
//   // Load local media paths if permission is granted
//   _initializeLocalMedia() async {
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     _localAudioPath = '${appDocDir.path}/sample_audio.mp3'; // Ensure a local file exists here.
//     _localVideoPath = '${appDocDir.path}/sample_video.mp4'; // Ensure a local file exists here.
//   }
//
//   // Play network audio
//   void _playNetworkAudio(String url) async {
//     await _audioPlayer.setUrl(url);
//     await _audioPlayer.play();
//     setState(() {
//       _isNetworkAudio = true;
//       _currentAudio = url;
//       _isPlayingAudio = true;
//     });
//   }
//
//   // Play local audio
//   void _playLocalAudio() async {
//     await _audioPlayer.setFilePath(_localAudioPath);
//     await _audioPlayer.play();
//     setState(() {
//       _isNetworkAudio = false;
//       _currentAudio = _localAudioPath;
//       _isPlayingAudio = true;
//     });
//   }
//
//   // Pause audio
//   void _pauseAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       _isPlayingAudio = false;
//     });
//   }
//
//   // Stop audio
//   void _stopAudio() async {
//     await _audioPlayer.stop();
//     setState(() {
//       _isPlayingAudio = false;
//     });
//   }
//
//   // Play network video
//   void _playNetworkVideo(String url) {
//     _videoPlayerController = VideoPlayerController.network(url)
//       ..initialize().then((_) {
//         setState(() {
//           _isNetworkVideo = true;
//           _currentVideo = url;
//           _isPlayingVideo = true;
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController!,
//             autoPlay: true,
//             looping: false,
//           );
//         });
//         _videoPlayerController?.play();
//       });
//   }
//
//   // Play local video
//   void _playLocalVideo() {
//     _videoPlayerController = VideoPlayerController.file(File(_localVideoPath))
//       ..initialize().then((_) {
//         setState(() {
//           _isNetworkVideo = false;
//           _currentVideo = _localVideoPath;
//           _isPlayingVideo = true;
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController!,
//             autoPlay: true,
//             looping: false,
//           );
//         });
//         _videoPlayerController?.play();
//       });
//   }
//
//   // Pause video
//   void _pauseVideo() {
//     _videoPlayerController?.pause();
//     setState(() {
//       _isPlayingVideo = false;
//     });
//   }
//
//   // Stop video
//   void _stopVideo() {
//     _videoPlayerController?.pause();
//     _videoPlayerController?.seekTo(Duration.zero);
//     setState(() {
//       _isPlayingVideo = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _audioPlayer.dispose();
//     _chewieController?.dispose();
//     _videoPlayerController?.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Player'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             if (!_isPermissionGranted)
//               Column(
//                 children: [
//                   Text(
//                     "Permission to access storage is required.",
//                     style: TextStyle(fontSize: 18, color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _requestPermissions,
//                     child: Text('Request Permission'),
//                   ),
//                 ],
//               ),
//             if (_isPermissionGranted)
//               Column(
//                 children: [
//                   Text(
//                     _isPlayingAudio
//                         ? 'Now Playing Audio: ${_currentAudio}'
//                         : 'Select an audio to play',
//                     style: TextStyle(fontSize: 18),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _playNetworkAudio('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
//                         child: Text('Play Network Audio'),
//                       ),
//                       SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: _playLocalAudio,
//                         child: Text('Play Local Audio'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   _isPlayingAudio
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.pause),
//                         onPressed: _pauseAudio,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.stop),
//                         onPressed: _stopAudio,
//                       ),
//                     ],
//                   )
//                       : Container(),
//                   SizedBox(height: 40),
//                   Text(
//                     _isPlayingVideo
//                         ? 'Now Playing Video: ${_currentVideo}'
//                         : 'Select a video to play',
//                     style: TextStyle(fontSize: 18),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _playNetworkVideo('https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4'),
//                         child: Text('Play Network Video'),
//                       ),
//                       SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: _playLocalVideo,
//                         child: Text('Play Local Video'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   _isPlayingVideo
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.pause),
//                         onPressed: _pauseVideo,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.stop),
//                         onPressed: _stopVideo,
//                       ),
//                     ],
//                   )
//                       : Container(),
//                   SizedBox(height: 20),
//                   _isPlayingVideo && _chewieController != null
//                       ? AspectRatio(
//                     aspectRatio: _videoPlayerController!.value.aspectRatio,
//                     child: Chewie(controller: _chewieController!),
//                   )
//                       : Container(),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }




// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';
// import 'package:video_player/video_player.dart';
// import 'package:chewie/chewie.dart';
// import 'package:path_provider/path_provider.dart';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
//
// class MediaPlayerPage extends StatefulWidget {
//   @override
//   _MediaPlayerPageState createState() => _MediaPlayerPageState();
// }
//
// class _MediaPlayerPageState extends State<MediaPlayerPage> {
//   final AudioPlayer _audioPlayer = AudioPlayer();
//   VideoPlayerController? _videoPlayerController;
//   ChewieController? _chewieController;
//   bool _isPlayingAudio = false;
//   bool _isPlayingVideo = false;
//   bool _isNetworkAudio = false;
//   bool _isNetworkVideo = false;
//   String _currentAudio = '';
//   String _currentVideo = '';
//
//   String _localAudioPath = '';
//   String _localVideoPath = '';
//   bool _isPermissionGranted = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }
//
//   // Request necessary permissions at runtime
//   Future<void> _requestPermissions() async {
//     // Request permissions for storage
//     PermissionStatus storagePermission = await Permission.storage.request();
//
//     if (storagePermission.isGranted) {
//       setState(() {
//         _isPermissionGranted = true;
//       });
//       _initializeLocalMedia();
//     } else {
//       setState(() {
//         _isPermissionGranted = false;
//       });
//       // Optionally, show a message to the user if permission is denied
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Storage permission is required to play media."),
//       ));
//     }
//   }
//
//   // Load local media paths if permission is granted
//   _initializeLocalMedia() async {
//     Directory appDocDir = await getApplicationDocumentsDirectory();
//     _localAudioPath = '${appDocDir.path}/sample_audio.mp3'; // Ensure a local file exists here.
//     _localVideoPath = '${appDocDir.path}/sample_video.mp4'; // Ensure a local file exists here.
//   }
//
//   // Play network audio
//   void _playNetworkAudio(String url) async {
//     await _audioPlayer.setUrl(url);
//     await _audioPlayer.play();
//     setState(() {
//       _isNetworkAudio = true;
//       _currentAudio = url;
//       _isPlayingAudio = true;
//     });
//   }
//
//   // Play local audio
//   void _playLocalAudio() async {
//     await _audioPlayer.setFilePath(_localAudioPath);
//     await _audioPlayer.play();
//     setState(() {
//       _isNetworkAudio = false;
//       _currentAudio = _localAudioPath;
//       _isPlayingAudio = true;
//     });
//   }
//
//   // Pause audio
//   void _pauseAudio() async {
//     await _audioPlayer.pause();
//     setState(() {
//       _isPlayingAudio = false;
//     });
//   }
//
//   // Stop audio
//   void _stopAudio() async {
//     await _audioPlayer.stop();
//     setState(() {
//       _isPlayingAudio = false;
//     });
//   }
//
//   // Play network video
//   void _playNetworkVideo(String url) {
//     _videoPlayerController = VideoPlayerController.network(url)
//       ..initialize().then((_) {
//         setState(() {
//           _isNetworkVideo = true;
//           _currentVideo = url;
//           _isPlayingVideo = true;
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController!,
//             autoPlay: true,
//             looping: false,
//           );
//         });
//         _videoPlayerController?.play();
//       });
//   }
//
//   // Play local video
//   void _playLocalVideo() {
//     _videoPlayerController = VideoPlayerController.file(File(_localVideoPath))
//       ..initialize().then((_) {
//         setState(() {
//           _isNetworkVideo = false;
//           _currentVideo = _localVideoPath;
//           _isPlayingVideo = true;
//           _chewieController = ChewieController(
//             videoPlayerController: _videoPlayerController!,
//             autoPlay: true,
//             looping: false,
//           );
//         });
//         _videoPlayerController?.play();
//       });
//   }
//
//   // Pause video
//   void _pauseVideo() {
//     _videoPlayerController?.pause();
//     setState(() {
//       _isPlayingVideo = false;
//     });
//   }
//
//   // Stop video
//   void _stopVideo() {
//     _videoPlayerController?.pause();
//     _videoPlayerController?.seekTo(Duration.zero);
//     setState(() {
//       _isPlayingVideo = false;
//     });
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _audioPlayer.dispose();
//     _chewieController?.dispose();
//     _videoPlayerController?.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Media Player'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             if (!_isPermissionGranted)
//               Column(
//                 children: [
//                   Text(
//                     "Permission to access storage is required.",
//                     style: TextStyle(fontSize: 18, color: Colors.red),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: _requestPermissions,
//                     child: Text('Request Permission'),
//                   ),
//                 ],
//               ),
//             if (_isPermissionGranted)
//               Column(
//                 children: [
//                   Text(
//                     _isPlayingAudio
//                         ? 'Now Playing Audio: ${_currentAudio}'
//                         : 'Select an audio to play',
//                     style: TextStyle(fontSize: 18),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _playNetworkAudio('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3'),
//                         child: Text('Play Network Audio'),
//                       ),
//                       SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: _playLocalAudio,
//                         child: Text('Play Local Audio'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   _isPlayingAudio
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.pause),
//                         onPressed: _pauseAudio,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.stop),
//                         onPressed: _stopAudio,
//                       ),
//                     ],
//                   )
//                       : Container(),
//                   SizedBox(height: 40),
//                   Text(
//                     _isPlayingVideo
//                         ? 'Now Playing Video: ${_currentVideo}'
//                         : 'Select a video to play',
//                     style: TextStyle(fontSize: 18),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 20),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       ElevatedButton(
//                         onPressed: () => _playNetworkVideo('https://www.sample-videos.com/video123/mp4/480/asdasdas.mp4'),
//                         child: Text('Play Network Video'),
//                       ),
//                       SizedBox(width: 20),
//                       ElevatedButton(
//                         onPressed: _playLocalVideo,
//                         child: Text('Play Local Video'),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 20),
//                   _isPlayingVideo
//                       ? Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       IconButton(
//                         icon: Icon(Icons.pause),
//                         onPressed: _pauseVideo,
//                       ),
//                       IconButton(
//                         icon: Icon(Icons.stop),
//                         onPressed: _stopVideo,
//                       ),
//                     ],
//                   )
//                       : Container(),
//                   SizedBox(height: 20),
//                   _isPlayingVideo && _chewieController != null
//                       ? AspectRatio(
//                     aspectRatio: _videoPlayerController!.value.aspectRatio,
//                     child: Chewie(controller: _chewieController!),
//                   )
//                       : Container(),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
