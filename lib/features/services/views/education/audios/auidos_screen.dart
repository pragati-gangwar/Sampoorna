import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart' as provider;
import '../../../../../theme/app_colors.dart';
import '../../../../../theme/theme_provider.dart';

class AudioScreen extends StatefulWidget {
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  late AudioPlayer audioPlayer;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  String currentAudio = '';

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();
    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  void playAudio(String assetPath) async {
    if (currentAudio == assetPath && isPlaying) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play(AssetSource(assetPath));
      setState(() {
        currentAudio = assetPath;
      });
    }
  }

  void stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      currentAudio = '';
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title:  Text('Audio Courses',
        style: Theme.of(context).textTheme.displayLarge!.copyWith(
      fontSize: 24,
      color: isDarkTheme ? Colors.white : Lcream,
        ),
      ),),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            buildAudioTile('Audio Tutorial 1', 'images/audio1.mp3'),
            const SizedBox(height: 16),
            buildAudioTile('Audio Tutorial 2', 'images/audio2.mp3'),
            const SizedBox(height: 16),
            buildAudioTile('Audio Tutorial 3', 'images/audio3.mp3'),
            const SizedBox(height: 32),
            if (currentAudio.isNotEmpty)
              Column(
                children: [
                  Text(
                    'Currently Playing: ${currentAudio.substring(7)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);

                      // If the user manually adjusts the slider, it will resume playing if it was paused
                      if (!isPlaying) {
                        playAudio(currentAudio);
                      }
                    },
                  ),
                ],
              ),
            const SizedBox(height: 16),
            if (currentAudio.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(isPlaying ? Icons.pause_circle : Icons.play_arrow_rounded),
                    iconSize: 48,
                    onPressed: () => playAudio(currentAudio),
                  ),
                  const SizedBox(width: 32),
                  IconButton(
                    icon: const Icon(Icons.stop_circle),
                    iconSize: 48,
                    onPressed: () => stopAudio(),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildAudioTile(String title, String assetPath) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    bool isActive = currentAudio == assetPath;
    return ListTile(
      tileColor: isActive ? isDarkTheme? Colors.yellow.shade100 : Colors.deepPurple.shade100 : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: isDarkTheme? Dcream :Colors.deepPurple.shade200),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isActive ? Colors.deepPurple : Colors.black,
        ),
      ),
      leading: Icon(
        Icons.music_note,
        color: isActive ? Colors.deepPurple : Colors.black54,
      ),
      trailing: isActive
          ? Icon(Icons.volume_up_sharp, color: Colors.deepPurple)
          : Icon(Icons.play_circle, color: Colors.deepPurple),
      onTap: () => playAudio(assetPath),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:audioplayers/audioplayers.dart';
//
// class AudioScreen extends StatefulWidget {
//   @override
//   _AudioScreenState createState() => _AudioScreenState();
// }
//
// class _AudioScreenState extends State<AudioScreen> {
//   late AudioPlayer audioPlayer;
//   bool isPlaying = false;
//   String currentAudio = '';
//
//   @override
//   void initState() {
//     super.initState();
//     audioPlayer = AudioPlayer();
//     audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
//       if (state == PlayerState.playing) {
//         setState(() {
//           isPlaying = true;
//         });
//       } else if (state == PlayerState.paused) {
//         setState(() {
//           isPlaying = false;
//         });
//       } else if (state == PlayerState.completed) {
//         setState(() {
//           isPlaying = false;
//           currentAudio = '';
//         });
//       }
//     });
//   }
//
//   void playAudio(String assetPath) {
//     if (isPlaying && currentAudio == assetPath) {
//       // If audio is playing, pause it
//       audioPlayer.pause();
//       setState(() {
//         isPlaying = false;
//       });
//     } else {
//       // If audio is paused, resume it
//       if (audioPlayer.state == PlayerState.paused) {
//         audioPlayer.resume();
//         setState(() {
//           isPlaying = true;
//         });
//       } else {
//         // If audio is stopped or not started, play from the beginning
//         audioPlayer.play(
//           AssetSource(assetPath),
//           volume: 1.0,
//           position: const Duration(milliseconds: 0),
//         );
//         setState(() {
//           currentAudio = assetPath;
//           isPlaying = true;
//         });
//       }
//     }
//   }
//
//   void stopAudio() {
//     audioPlayer.stop();
//     setState(() {
//       isPlaying = false;
//       currentAudio = '';
//     });
//   }
//
//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Audio Courses'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             buildAudioTile('Audio Tutorial 1', 'images/audio1.mp3'),
//             const SizedBox(height: 16),
//             buildAudioTile('Audio Tutorial 2', 'images/audio2.mp3'),
//             const SizedBox(height: 16),
//             buildAudioTile('Audio Tutorial 3', 'images/audio3.mp3'),
//             const SizedBox(height: 16),
//             Text(
//               currentAudio != ""
//                   ? 'Currently Playing:   ${currentAudio.substring(7)}'
//                   : 'No audio is playing',
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   width: 40,
//                   child: TextButton(
//                     child: const Text(
//                       'Play',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                     onPressed: () => playAudio('images/audio1.mp3'),
//                   ),
//                 ),
//                 Container(
//                   width: 40,
//                   child: TextButton(
//                     onPressed: isPlaying ? () => stopAudio() : null,
//                     child: const Text(
//                       'Pause',
//                       style: TextStyle(
//                         fontSize: 16,
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildAudioTile(String title, String assetPath) {
//     return Card(
//       elevation: 4,
//       child: ListTile(
//         title: Text(
//           title,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         leading: const Icon(Icons.music_note),
//         onTap: () => playAudio(assetPath),
//       ),
//     );
//   }
// }
