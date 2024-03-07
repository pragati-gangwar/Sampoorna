import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:hackathon_proj/theme/font_provider.dart';

final audioPlayingProvider = StateProvider<bool>((ref) => false);

class ReadingText extends ConsumerStatefulWidget {
  final String title;
  final String content;

  const ReadingText({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  ConsumerState<ReadingText> createState() => _ReadingTextState();
}

class _ReadingTextState extends ConsumerState<ReadingText> {
  FlutterTts flutterTts = FlutterTts();

  void toggleAudio() async {
    final bool isPlaying = ref.read(audioPlayingProvider.notifier).state;

    if (isPlaying) {
      await flutterTts.stop();
    } else {
      await flutterTts.speak(widget.content);
    }

    ref.read(audioPlayingProvider.notifier).state = !isPlaying;
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizesProvider);
    final isPlaying = ref.watch(audioPlayingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                widget.content,
                textAlign: TextAlign.justify,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontSize: fontSize.fontSize,
                    ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 100.0),
                child: ElevatedButton(

                    onPressed: () => toggleAudio(),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     isPlaying ? Text("Stop") :Text("Play"),
                     SizedBox(
                       width: 8,
                     ),
                     Icon(
                        isPlaying ? Icons.stop : Icons.play_arrow,
                       size: 30,
                      ),
                   ],
                 ),),
              )
            ],
          ),

        ),
      ),

    );
  }
}
