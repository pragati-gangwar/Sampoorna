import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart' as provider;
import '../../../theme/app_colors.dart';
import 'map_screen.dart';
import '../../../../theme/theme_provider.dart';

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return provider.Consumer<ThemeProvider>(
        builder: (context, ThemeProvider notifier, child) {
      return Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(50),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 30),
                    title: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Report & Recommendation',
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium
                            ?.copyWith(
                              color: isDarkTheme ? Colors.white : Lcream,
                            ),
                      ),
                    ),
                    subtitle: Text(
                        'Report, recommend, and revolutionize accessibility together!',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isDarkTheme ? Colors.white54 : Lcream)),
                    trailing: Switch(
                        activeColor: Dcream,
                        value: notifier.isDark,
                        onChanged: (value) => notifier.changeTheme()),
                  ),
                  const SizedBox(height: 30)
                ],
              ),
            ),
            Container(
                color: Theme.of(context).primaryColor,
                child: Container(
                  height: MediaQuery.of(context).size.height / 3,
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(200),
                    ),
                  ),
                  child:
                  GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 40,
                      mainAxisSpacing: 30,
                      children: [
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReportsPage()),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: isDarkTheme ?Dcream:Theme.of(context)
                                    .primaryColor, //the colour of boxes
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black,
                                    offset: const Offset(
                                      5.0,
                                      5.0,
                                    ), //Offset
                                    blurRadius: 15.0,
                                    spreadRadius: 1.0,
                                  ), //BoxShadow
                                  BoxShadow(
                                    color: Colors.grey.shade800,
                                    offset: const Offset(0.0, 0.0),
                                    blurRadius: 0.0,
                                    spreadRadius: 0.0,
                                  ), //BoxShadow
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  isDarkTheme ? Image.asset('assets/images/report.png',
                                    height: 110,) :Image.asset('assets/images/reportL.png', height: 110,) ,
                                  Text(
                                    "Report",
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          color: isDarkTheme
                                              ? Colors.black
                                              : Lcream,
                                        ),
                                  ),
                                ],
                              ),
                            )),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecommendationsPage(),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDarkTheme? Dcream : Theme.of(context)
                                  .primaryColor, //the colour of boxes
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black,
                                  offset: const Offset(
                                    5.0,
                                    5.0,
                                  ), //Offset
                                  blurRadius: 15.0,
                                  spreadRadius: 1.0,
                                ), //BoxShadow
                                BoxShadow(
                                  color: Colors.grey.shade800,
                                  offset: const Offset(0.0, 0.0),
                                  blurRadius: 0.0,
                                  spreadRadius: 0.0,
                                ), //BoxShadow
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                isDarkTheme ? Image.asset('assets/images/recommend.png',
                                  height: 110,) :Image.asset('assets/images/recommendL.png', height: 110,) ,
                                const SizedBox(height: 8),
                                Text(
                                  "Recommendation",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color:
                                            isDarkTheme ? Colors.black : Lcream,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                )),
          ],
        ),
      );
    });
  }
}

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _reports = [];
  bool _isloding = true;
  @override
  void initState() {
    super.initState();
    loadReports();
  }

  Future<void> loadReports() async {
    QuerySnapshot querySnapshot = await _firestore.collection('reports').get();
    setState(() {
      _reports = querySnapshot.docs;
      _isloding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
      ),
      body: _isloding
          ? const Center(child: CircularProgressIndicator())
          :StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('reports').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data!.docs;
          List<Widget> reportWidgets = reports.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
             return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: <Widget>[
                    const Text(
                      'Place: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        data['title'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Description: ${data['description'].length > 100 ? '${data['description'].substring(0, 100)}...' : data['description']}',
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RatingBar.builder(
                        initialRating: data['rating'],
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (value) => {},
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_drop_down_circle, // Change to a bigger arrow icon
                  color: isDarkTheme? Dcream :Theme.of(context).primaryColor,
                  size: 30.0, // Increase arrow size
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        if (data['location'] != null)
                          ElevatedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(data['location']));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                              onPrimary: Colors.white,
                            ),
                            child: const Text(
                              'View on Google Maps',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          const Text('No location available'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: reportWidgets,
          );
        },
      ),
      // ListView.builder(
      //         itemCount: _reports.length,
      //         itemBuilder: (context, index) {
      //           Map<String, dynamic> data =
      //               _reports[index].data() as Map<String, dynamic>;
      //           return
      //             Card(
      //             margin: const EdgeInsets.all(10),
      //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //             elevation: 5,
      //             child: ExpansionTile(
      //               tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //               title: Row(
      //                 children: <Widget>[
      //                   const Text(
      //                     'Place: ',
      //                     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                   ),
      //                   Expanded(
      //                     child: Text(
      //                       data['title'],
      //                       style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                       maxLines: 1,
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               subtitle: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: <Widget>[
      //                   Padding(
      //                     padding: const EdgeInsets.only(top: 4.0),
      //                     child: Text(
      //                       'Description: ${data['description'].length > 100 ? '${data['description'].substring(0, 100)}...' : data['description']}',
      //                       style: const TextStyle(fontSize: 16),
      //                       overflow: TextOverflow.ellipsis,
      //                     ),
      //                   ),
      //                   Padding(
      //                     padding: const EdgeInsets.symmetric(vertical: 8.0),
      //                     child: RatingBar.builder(
      //                       initialRating: data['rating'],
      //                       minRating: 1,
      //                       direction: Axis.horizontal,
      //                       allowHalfRating: true,
      //                       itemCount: 5,
      //                       itemSize: 20.0,
      //                       itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      //                       itemBuilder: (context, _) => const Icon(
      //                         Icons.star,
      //                         color: Colors.amber,
      //                       ),
      //                       ignoreGestures: true,
      //                       onRatingUpdate: (value) => {},
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //               trailing: Icon(
      //                 Icons.arrow_drop_down_circle, // Change to a bigger arrow icon
      //                 color: isDarkTheme? Dcream :Theme.of(context).primaryColor,
      //                 size: 30.0, // Increase arrow size
      //               ),
      //               children: <Widget>[
      //                 Padding(
      //                   padding: const EdgeInsets.all(16.0),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         data['description'],
      //                         style: const TextStyle(fontSize: 16),
      //                       ),
      //                       const SizedBox(height: 10),
      //                       if (data['location'] != null)
      //                         ElevatedButton(
      //                           onPressed: () {
      //                             launchUrl(Uri.parse(data['location']));
      //                           },
      //                           style: ElevatedButton.styleFrom(
      //                             primary: Theme.of(context).colorScheme.secondary,
      //                             onPrimary: Colors.white,
      //                           ),
      //                           child: const Text(
      //                             'View on Google Maps',
      //                             style: TextStyle(fontSize: 16),
      //                           ),
      //                         )
      //                       else
      //                         const Text('No location available'),
      //                     ],
      //                   ),
      //                 ),
      //               ],
      //             ),
      //           );
      //         },
      //       ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReportPage()),
          );
          // Navigate to a new page to add a report
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}

// Similar code for RecommendationsPage...
class RecommendationsPage extends StatefulWidget {
  @override
  _RecommendationsPageState createState() => _RecommendationsPageState();
}
class _RecommendationsPageState extends State<RecommendationsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<DocumentSnapshot> _recommendations = [];
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    loadRecommendations();
  }

  Future<void> loadRecommendations() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('recommendations').get();
    setState(() {
      _recommendations = querySnapshot.docs;
      _isloading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
      ),
      body: _isloading
          ? const Center(child: CircularProgressIndicator())
          :
      StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('recommendations').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final reports = snapshot.data!.docs;
          List<Widget> reportWidgets = reports.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  children: <Widget>[
                    const Text(
                      'Place: ',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Text(
                        data['title'],
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: Text(
                        'Description: ${data['description'].length > 100 ? '${data['description'].substring(0, 100)}...' : data['description']}',
                        style: const TextStyle(fontSize: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: RatingBar.builder(
                        initialRating: data['rating'],
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 20.0,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        ignoreGestures: true,
                        onRatingUpdate: (value) => {},
                      ),
                    ),
                  ],
                ),
                trailing: Icon(
                  Icons.arrow_drop_down_circle, // Change to a bigger arrow icon
                  color: isDarkTheme? Dcream :Theme.of(context).primaryColor,
                  size: 30.0, // Increase arrow size
                ),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['description'],
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        if (data['location'] != null)
                          ElevatedButton(
                            onPressed: () {
                              launchUrl(Uri.parse(data['location']));
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).colorScheme.secondary,
                              onPrimary: Colors.white,
                            ),
                            child: const Text(
                              'View on Google Maps',
                              style: TextStyle(fontSize: 16),
                            ),
                          )
                        else
                          const Text('No location available'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList();

          return ListView(
            children: reportWidgets,
          );
        },
      ),
      // ListView.builder(
      //         itemCount: _recommendations.length,
      //         itemBuilder: (context, index) {
      //           Map<String, dynamic> data =
      //               _recommendations[index].data() as Map<String, dynamic>;
      //           return
      //             Card(
      //               margin: const EdgeInsets.all(10),
      //               shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      //               elevation: 5,
      //               child: ExpansionTile(
      //                 tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      //                 title: Row(
      //                   children: <Widget>[
      //                     const Text(
      //                       'Place: ',
      //                       style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                     ),
      //                     Expanded(
      //                       child: Text(
      //                         data['title'],
      //                         style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      //                         maxLines: 1,
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 subtitle: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: <Widget>[
      //                     Padding(
      //                       padding: const EdgeInsets.only(top: 4.0),
      //                       child: Text(
      //                         'Description: ${data['description'].length > 100 ? '${data['description'].substring(0, 100)}...' : data['description']}',
      //                         style: const TextStyle(fontSize: 16),
      //                         overflow: TextOverflow.ellipsis,
      //                       ),
      //                     ),
      //                     Padding(
      //                       padding: const EdgeInsets.symmetric(vertical: 8.0),
      //                       child: RatingBar.builder(
      //                         initialRating: data['rating'],
      //                         minRating: 1,
      //                         direction: Axis.horizontal,
      //                         allowHalfRating: true,
      //                         itemCount: 5,
      //                         itemSize: 20.0,
      //                         itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
      //                         itemBuilder: (context, _) => const Icon(
      //                           Icons.star,
      //                           color: Colors.amber,
      //                         ),
      //                         ignoreGestures: true,
      //                         onRatingUpdate: (value) => {},
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //                 trailing: Icon(
      //                   Icons.arrow_drop_down_circle, // Change to a bigger arrow icon
      //                   color: isDarkTheme? Dcream :Theme.of(context).primaryColor,
      //                   size: 30.0, // Increase arrow size
      //                 ),
      //                 children: <Widget>[
      //                   Padding(
      //                     padding: const EdgeInsets.all(16.0),
      //                     child: Column(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Text(
      //                           data['description'],
      //                           style: const TextStyle(fontSize: 16),
      //                         ),
      //                         const SizedBox(height: 10),
      //                         if (data['location'] != null)
      //                           ElevatedButton(
      //                             onPressed: () {
      //                               launchUrl(Uri.parse(data['location']));
      //                             },
      //                             style: ElevatedButton.styleFrom(
      //                               primary: Theme.of(context).colorScheme.secondary,
      //                               onPrimary: Colors.white,
      //                             ),
      //                             child: const Text(
      //                               'View on Google Maps',
      //                               style: TextStyle(fontSize: 16),
      //                             ),
      //                           )
      //                         else
      //                           const Text('No location available'),
      //                       ],
      //                     ),
      //                   ),
      //                 ],
      //               ),
      //             );
      //         },
      //       ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddRecommendationPage()),
          );
          // Navigate to a new page to add a recommendation
        },
        child: const Icon(
          Icons.add,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}

class AddRecommendationPage extends StatefulWidget {
  @override
  _AddRecommendationPageState createState() => _AddRecommendationPageState();
}

class _AddRecommendationPageState extends State<AddRecommendationPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _rating = 0;
  double _latitude = 0;
  double _longitude = 0;
  Future<void> addRecommendation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    String googleMapsLink = 'https://maps.google.com/?q=$_latitude,$_longitude';

    await _firestore.collection('recommendations').add({
      'title': _title,
      'description': _description,
      'rating': _rating,
      'location': googleMapsLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Recommendation'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Name of place',
                    fillColor: Theme.of(context).scaffoldBackgroundColor),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required value';
                  }
                  return null; // means validation passed
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                decoration: InputDecoration(
                    labelText: 'Describe what you liked',
                    fillColor: Theme.of(context).scaffoldBackgroundColor),
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required value';
                  }
                  return null; // means validation passed
                },
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkTheme ? Dcream : Lpurple1,
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    bottomLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0, top: 5),
                        child: Text("Rate the place",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: isDarkTheme ? Colors.white : Lpurple1,
                          fontSize: 20,
                        ),),
                      ),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          _rating = rating;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addRecommendation();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AddReportPage extends StatefulWidget {
  @override
  _AddReportPageState createState() => _AddReportPageState();
}

class _AddReportPageState extends State<AddReportPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  String _description = '';
  double _rating = 0;
  double _latitude = 0;
  double _longitude = 0;

  Future<void> addReport() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _latitude = position.latitude;
    _longitude = position.longitude;
    String googleMapsLink = 'https://maps.google.com/?q=$_latitude,$_longitude';

    await _firestore.collection('reports').add({
      'title': _title,
      'description': _description,
      'rating': _rating,
      'location': googleMapsLink,
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Report'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration:  InputDecoration(labelText: 'Name of the place', fillColor: Theme.of(context).scaffoldBackgroundColor),
                onSaved: (value) => _title = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required value';
                  }
                  return null; // means validation passed
                },
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                decoration:  InputDecoration(labelText: 'Describe what was wrong',
                    fillColor: Theme.of(context).scaffoldBackgroundColor),
                onSaved: (value) => _description = value!,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the required value';
                  }
                  return null; // means validation passed
                },
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                height: 90,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isDarkTheme ? Dcream : Lpurple1,
                    width: 2.0,
                  ),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(32.0),
                    bottomLeft: Radius.circular(32.0),
                    topRight: Radius.circular(32.0),
                    bottomRight: Radius.circular(32.0),
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 4.0, top: 5),
                      child: Text("Rate the place",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                          color: isDarkTheme ? Colors.white : Lpurple1,
                          fontSize: 20,
                        ),),
                    ),
                    RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        _rating = rating;
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 45,
              ),
              ElevatedButton(
                child: const Text('Submit'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    addReport();
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
