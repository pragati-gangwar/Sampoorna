import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/constants/firebase_constants.dart';
import 'package:hackathon_proj/features/community/controller/community_controller.dart';
import 'package:hackathon_proj/features/community/views/community_screen.dart';
import 'package:hackathon_proj/models/community_model.dart';
import 'package:hackathon_proj/routes/route_utils.dart';

import '../../../core/utils/snackbar.dart';
import '../../auth/controller/auth_controller.dart';

class SearchCommunityScreen extends ConsumerStatefulWidget {
  const SearchCommunityScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<SearchCommunityScreen> createState() => _SearchCommunityScreenState();
}

class _SearchCommunityScreenState extends ConsumerState<SearchCommunityScreen> {
  String searchInput = '';

  void navigateToCommunity(BuildContext context, String id) {
    Navigation.navigateCommunity(context, id);
  }

  void leaveCommunity(Community community) {
    ref
        .read(communityControllerProvider.notifier)
        .joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    print(searchInput);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: Container(
          height: 50,
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white, // Border color
              width: 1.0, // Border width
            ),
            borderRadius: BorderRadius.circular(25), // Border radius
          ),
          child: CupertinoSearchTextField(
            style: TextStyle(color: Colors.white),
            prefixIcon: Icon(Icons.search, color: Colors.white), // Adjust as necessary
            suffixIcon: Icon(Icons.clear, color: Colors.white),
            autofocus: true,
            onChanged: ((value) {
              setState(() {
                searchInput = value.toLowerCase();
              });
            }),
          ),
        ),
      ),
      body: searchInput != ''
          ? StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('communities')
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Material(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Colors.yellow,
                      ),
                    ),
                  );
                }
                print("docsssssssssssss ${snapshot.data!.docs}");
                snapshot.data!.docs.forEach((e) {
                  print("Document name: ${e['name'.toLowerCase()]}");
                  print("Search input: $searchInput");
                });

                final List result = snapshot.data!.docs
                    .where(
                      (e) => e['name'.toLowerCase()]
                          .toLowerCase()
                          .startsWith(searchInput.toLowerCase()),
                    )
                    .map((e) =>
                        Community.fromMap(e.data() as Map<String, dynamic>))
                    .toList();

                print("result: $result");

                return SizedBox(
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: result.length,
                      itemBuilder: (context, index) {
                        final Community community = result[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(community.groupIcon),
                          ),
                          title: Text('${community.name}'),
                          onTap: () {
                            community.members.contains(user.id)
                                ? navigateToCommunity(context, community.id)
                                : errorSnackBar(
                                    context: context,
                                    message: ' Join Community First!',
                                    title: 'Warning');
                          },
                          trailing: Container(
                            width: 80,
                            height: 32,
                            child: ElevatedButton(
                              onPressed: () {
                                community.admin != user.id
                                    ? leaveCommunity(community)
                                    : null;
                              },
                              child: Text(
                                community.admin == user.id
                                    ? 'Admin'
                                    : community.members.contains(user.id)
                                        ? 'Leave'
                                        : 'Join',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        );
                      }),
                );
              },
            )
          : const Center(
              child: Text(
                'Start typing to search for anything..',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
