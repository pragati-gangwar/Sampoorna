import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildSectionContainer(context, 'Welcome to Sampoorna',
                'Welcome to our comprehensive mobile application designed with utmost care and empathy for specially-abled individuals. At Sampoorna, we believe in harnessing the power of technology to transform lives and foster inclusive communities. Our app is not just a tool; it\'s a beacon of hope, a source of empowerment, and a platform for change.'
            ),
            _buildSectionContainer(context, 'Our Mission',
                'To enhance the overall well-being, connectivity, and access to essential services for individuals who are specially-abled, ensuring they lead fulfilling and empowered lives.'
            ),
            _buildSectionContainer(context, 'Our Vision',
                'A world where every individual, regardless of ability, has equal opportunities, support, and resources to thrive and succeed.'
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(
                'Features:',
                style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            _buildFeatureTile(context, 'Empathetic Community Engagement', 'Facilitates connections among individuals with disabilities to foster a supportive community environment, promoting empathy, understanding, and a sense of belonging.', Icons.people_outline),
            _buildFeatureTile(context, 'Emergency SOS Assistance', 'Offers a quick and reliable SOS feature for users to seek immediate assistance during emergencies.', Icons.warning_amber_outlined),
            _buildFeatureTile(context, 'Comprehensive Healthcare Support (Medicare)', 'Provides robust healthcare management features tailored to the unique needs of individuals with disabilities.', Icons.local_hospital_outlined),
            _buildFeatureTile(context, 'Empowering User Contributions (Report and Recommendation)', 'Empower users to actively contribute to creating a safer and more accessible environment.', Icons.lightbulb_outline),
            _buildFeatureTile(context, 'Feed', 'Offers a customizable feed where users can create, share, and consume content.', Icons.rss_feed_outlined),
            _buildFeatureTile(context, 'Chatbot Assistance', 'Integrates a chatbot feature to provide immediate assistance and support to users.', Icons.chat_outlined),
            _buildFeatureTile(context, 'Multimedia Education Platform', 'Delivers educational content in diverse formats to cater to different learning preferences and accessibility needs.', Icons.video_library_outlined),
            _buildFeatureTile(context, 'Mood Tracker', 'Helps users track their daily moods to monitor emotional well-being and mental health over time.', Icons.mood_outlined),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionContainer(BuildContext context, String title, String content) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[500], // Adjust the color to fit your theme
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, String title, String description,IconData icon) {
     return Card(
      elevation: 2,
      shadowColor: Colors.grey[50],
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 30, color: Dcream),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

  }
}



// import 'package:flutter/material.dart';
//
//
// class AboutPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('About Us'),
//         backgroundColor: Theme.of(context).primaryColor,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             Text(
//               'Welcome to Sampoorna',
//               style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 16),
//             Text(
//               'Welcome to our comprehensive mobile application designed with utmost care and empathy for specially-abled individuals. At Sampoorna, we believe in harnessing the power of technology to transform lives and foster inclusive communities. Our app is not just a tool; it\'s a beacon of hope, a source of empowerment, and a platform for change.',
//               style: Theme.of(context).textTheme.bodyText1,
//             ),
//             SizedBox(height: 20),
//             _buildSectionHeader(context, 'Our Mission:'),
//             _buildSectionText(context, 'To enhance the overall well-being, connectivity, and access to essential services for individuals who are specially-abled, ensuring they lead fulfilling and empowered lives.'),
//             _buildSectionHeader(context, 'Our Vision:'),
//             _buildSectionText(context, 'A world where every individual, regardless of ability, has equal opportunities, support, and resources to thrive and succeed.'),
//             SizedBox(height: 20),
//             _buildSectionHeader(context, 'Features:'),
//             _buildFeatureTile(context, 'Empathetic Community Engagement', 'Facilitates connections among individuals with disabilities to foster a supportive community environment, promoting empathy, understanding, and a sense of belonging.', Icons.people_outline),
//             _buildFeatureTile(context, 'Emergency SOS Assistance', 'Offers a quick and reliable SOS feature for users to seek immediate assistance during emergencies.', Icons.warning_amber_outlined),
//             _buildFeatureTile(context, 'Comprehensive Healthcare Support (Medicare)', 'Provides robust healthcare management features tailored to the unique needs of individuals with disabilities.', Icons.local_hospital_outlined),
//             _buildFeatureTile(context, 'Empowering User Contributions (Report and Recommendation)', 'Empower users to actively contribute to creating a safer and more accessible environment.', Icons.lightbulb_outline),
//             _buildFeatureTile(context, 'Feed', 'Offers a customizable feed where users can create, share, and consume content.', Icons.rss_feed_outlined),
//             _buildFeatureTile(context, 'Chatbot Assistance', 'Integrates a chatbot feature to provide immediate assistance and support to users.', Icons.chat_outlined),
//             _buildFeatureTile(context, 'Multimedia Education Platform', 'Delivers educational content in diverse formats to cater to different learning preferences and accessibility needs.', Icons.video_library_outlined),
//             _buildFeatureTile(context, 'Mood Tracker', 'Helps users track their daily moods to monitor emotional well-being and mental health over time.', Icons.mood_outlined),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildSectionHeader(BuildContext context, String text) {
//     return Text(
//       text,
//       style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
//     );
//   }
//
//   Widget _buildSectionText(BuildContext context, String text) {
//     return Padding(
//       padding: const EdgeInsets.only(top: 8.0, bottom: 20.0),
//       child: Text(
//         text,
//         style: Theme.of(context).textTheme.bodyText1,
//       ),
//     );
//   }
//
//   Widget _buildFeatureTile(BuildContext context, String title, String description, IconData icon) {
//     return Card(
//       elevation: 2,
//       shadowColor: Colors.grey[50],
//       margin: const EdgeInsets.only(bottom: 20),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Icon(icon, size: 30, color: Theme.of(context).primaryColor),
//             SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     title,
//                     style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
//                   ),
//                   SizedBox(height: 8),
//                   Text(
//                     description,
//                     style: Theme.of(context).textTheme.bodyText1,
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// //
// // class AboutPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('About Us'),
// //         backgroundColor: Theme.of(context).primaryColor,
// //       ),
// //       body: SingleChildScrollView(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: <Widget>[
// //             Text(
// //               'Welcome to Sampoorna',
// //               style: Theme.of(context).textTheme.headline5?.copyWith(fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 16),
// //             Text(
// //               'Welcome to our comprehensive mobile application designed with utmost care and empathy for specially-abled individuals. At Sampoorna, we believe in harnessing the power of technology to transform lives and foster inclusive communities. Our app is not just a tool; it\'s a beacon of hope, a source of empowerment, and a platform for change.',
// //               style: Theme.of(context).textTheme.bodyText1,
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               'Our Mission:',
// //               style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               'To enhance the overall well-being, connectivity, and access to essential services for individuals who are specially-abled, ensuring they lead fulfilling and empowered lives.',
// //               style: Theme.of(context).textTheme.bodyText1,
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               'Our Vision:',
// //               style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             Text(
// //               'A world where every individual, regardless of ability, has equal opportunities, support, and resources to thrive and succeed.',
// //               style: Theme.of(context).textTheme.bodyText1,
// //             ),
// //             SizedBox(height: 20),
// //             Text(
// //               'Features:',
// //               style: Theme.of(context).textTheme.headline6?.copyWith(fontWeight: FontWeight.bold),
// //             ),
// //             SizedBox(height: 8),
// //             _buildFeatureTile(context, 'Empathetic Community Engagement', 'Facilitates connections among individuals with disabilities to foster a supportive community environment, promoting empathy, understanding, and a sense of belonging.'),
// //             _buildFeatureTile(context, 'Emergency SOS Assistance', 'Offers a quick and reliable SOS feature for users to seek immediate assistance during emergencies.'),
// //             _buildFeatureTile(context, 'Comprehensive Healthcare Support (Medicare)', 'Provides robust healthcare management features tailored to the unique needs of individuals with disabilities.'),
// //             _buildFeatureTile(context, 'Empowering User Contributions (Report and Recommendation)', 'Empower users to actively contribute to creating a safer and more accessible environment.'),
// //             _buildFeatureTile(context, 'Feed', 'Offers a customizable feed where users can create, share, and consume content.'),
// //             _buildFeatureTile(context, 'Chatbot Assistance', 'Integrates a chatbot feature to provide immediate assistance and support to users.'),
// //             _buildFeatureTile(context, 'Multimedia Education Platform', 'Delivers educational content in diverse formats to cater to different learning preferences and accessibility needs.'),
// //             _buildFeatureTile(context, 'Mood Tracker', 'Helps users track their daily moods to monitor emotional well-being and mental health over time.'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildFeatureTile(BuildContext context, String title, String description) {
// //     return Padding(
// //       padding: const EdgeInsets.only(bottom: 16.0),
// //       child: Column(
// //         crossAxisAlignment: CrossAxisAlignment.start,
// //         children: [
// //           Text(
// //             title,
// //             style: Theme.of(context).textTheme.subtitle1?.copyWith(fontWeight: FontWeight.bold),
// //           ),
// //           SizedBox(height: 8),
// //           Text(
// //             description,
// //             style: Theme.of(context).textTheme.bodyText1,
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }
