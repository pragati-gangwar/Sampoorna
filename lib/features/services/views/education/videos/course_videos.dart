import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'video.dart';

class Videos extends ConsumerStatefulWidget {
  final List<String> videoLinks;
  final String courseTitle;

  const Videos({
    Key? key,
    required this.videoLinks,
    required this.courseTitle,
  }) : super(key: key);

  @override
  ConsumerState createState() => VideosState();
}

class VideosState extends ConsumerState<Videos> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initSharedPreferences();
  }

  Future<void> _initSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  void _incrementClickCount() {
    int clickCount = prefs.getInt('video_click_count') ?? 0;
    clickCount += 10;
    prefs.setInt('video_click_count', clickCount);
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = ref.watch(fontSizesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.courseTitle),
      ),
      body: ListView.separated(
        itemCount: widget.videoLinks.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.grey),
        itemBuilder: (context, index) {
          return Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: ListTile(
              onTap: () {
                _incrementClickCount();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => VideoScreen(
                      videoLinks: widget.videoLinks[index],
                      courseTitle: widget.courseTitle,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                // Use your video thumbnail here, or a placeholder like this
                child: Icon(Icons.video_camera_back_rounded, color: Colors.white),
                backgroundColor: Colors.grey.shade600,
              ),
              title: Text(
                'Video Tutorial ${index + 1}',
                style: TextStyle(
                  fontSize: fontSize.headingSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                widget.videoLinks[index],
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: fontSize.subheadingSize,
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Icon(Icons.play_circle_fill, color: Theme.of(context).primaryColor),
            ),
          );
        },
      ),
    );
  }
}



















// import 'package:flutter/material.dart';


// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hackathon_proj/theme/font_provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import 'video.dart';
//
// class Videos extends ConsumerStatefulWidget {
//   final List<String> videoLinks;
//   final String courseTitle;
//
//   const Videos({
//     Key? key,
//     required this.videoLinks,
//     required this.courseTitle,
//   }) : super(key: key);
//
//   @override
//   ConsumerState createState() => VideosState();
// }
//
// class VideosState extends ConsumerState<Videos> {
//   void _incrementClickCount() {
//     int clickCount = prefs.getInt('video_click_count') ?? 0; // Step 2
//     clickCount += 10;
//     prefs.setInt('video_click_count', clickCount); // Step 3
//   }
//
//   late SharedPreferences prefs; // Step 1
//
//   @override
//   void initState() {
//     super.initState();
//     _initSharedPreferences();
//   }
//
//   Future<void> _initSharedPreferences() async {
//     prefs = await SharedPreferences.getInstance();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final fontSize = ref.watch(fontSizesProvider);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           widget.courseTitle,
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: widget.videoLinks.length,
//         itemBuilder: (context, index) {
//           return Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: ListTile(
//               onTap: () {
//                 _incrementClickCount();
//                 Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: (context) => VideoScreen(
//                       videoLinks: widget.videoLinks[index],
//                       courseTitle: widget.courseTitle,
//                     ),
//                   ),
//                 );
//               },
//               title: Text(
//                 'Video Tutorial ${index}',
//                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(
//                       fontSize: fontSize.headingSize,
//                     ),
//               ),
//               subtitle: Text(
//                 widget.videoLinks[index],
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: Theme.of(context).textTheme.bodySmall!.copyWith(
//                       fontSize: fontSize.subheadingSize - 8,
//                     ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
