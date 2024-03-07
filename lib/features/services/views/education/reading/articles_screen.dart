
import 'package:flutter/material.dart';
import 'package:hackathon_proj/core/constants/courses_constant.dart';
import 'package:hackathon_proj/features/services/views/education/reading/text_reading_screen.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  _ArticlesScreenState createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reading Materials'),
        centerTitle: true, // Center the title
        // You may customize your AppBar color as needed
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView.builder(
          itemCount: reading_material.length,
          itemBuilder: (context, index) {
            // Use 'Reading Material #' as the placeholder title
            String placeholderTitle = 'Reading Material ${index + 1}';

            return Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: Text(
                  placeholderTitle,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                leading: const CircleAvatar(
                  // Consider changing the icon if needed
                  child: Icon(Icons.book),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => ReadingText(
                      content: reading_material[index],
                      title: placeholderTitle,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:hackathon_proj/core/constants/courses_constant.dart';
// import 'package:hackathon_proj/features/services/views/education/reading/text_reading_screen.dart';
// import 'package:hackathon_proj/features/services/views/education/videos/education_videos.dart';
//
// class ArticlesScreen extends StatefulWidget {
//   const ArticlesScreen({super.key});
//
//   @override
//   _ArticlesScreenState createState() => _ArticlesScreenState();
// }
//
// class _ArticlesScreenState extends State<ArticlesScreen> {
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Reading Materials'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(18.0),
//         child: ListView.builder(
//           itemCount: reading_material.length,
//           itemBuilder: (context, index) {
//             return Card(
//               elevation: 4,
//               child: ListTile(
//                 title: Text(
//                   courses[index],
//                   style: const TextStyle(fontWeight: FontWeight.bold),
//                 ),
//                 leading: const Icon(Icons.notes_outlined),
//                 onTap: () => Navigator.of(context).push(
//                   MaterialPageRoute(
//                     builder: ((context) => ReadingText(
//                           content: reading_material[index],
//                           title: courses[index],
//                         )),
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
