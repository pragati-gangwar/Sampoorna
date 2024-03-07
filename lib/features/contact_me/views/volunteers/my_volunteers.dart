import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hackathon_proj/features/contact_me/controller/contect_me_controller.dart';
import 'package:hackathon_proj/features/health/controller/health_controlller.dart';
import 'package:hackathon_proj/routes/route_utils.dart';
import 'package:hackathon_proj/theme/font_provider.dart';
import 'package:intl/intl.dart';

import '../../../../core/common/error_text.dart';
import '../../../../core/common/loader.dart';
import '../../../auth/controller/auth_controller.dart';

class MyVolunteersView extends ConsumerStatefulWidget {
  const MyVolunteersView({super.key});

  @override
  ConsumerState<MyVolunteersView> createState() => _MyVolunteersViewState();
}

class _MyVolunteersViewState extends ConsumerState<MyVolunteersView> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final fontsize = ref.watch(fontSizesProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Volunteers',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
            fontSize: fontsize.headingSize,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            ref.watch(userVolunteersProvider).when(
              data: (appointment) => Expanded(
                child: ListView.builder(
                  itemCount: appointment.length,
                  itemBuilder: (BuildContext context, int index) {
                    final document = appointment[index];
                    return ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        backgroundImage:
                        AssetImage('assets/images/volunteersL.png'),
                        radius: 24,
                      ),
                      title: Text(
                        document.reason,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall!
                            .copyWith(
                          fontSize: fontsize.subheadingSize + 2,
                        ),
                      ),
                      trailing: Text(
                        document.isAccepted ? "Accepted" : "Pending",
                        overflow: TextOverflow.ellipsis,
                        style:
                        Theme.of(context).textTheme.bodySmall!.copyWith(
                          fontSize: fontsize.fontSize,
                        ),
                      ),
                      subtitle: Text(
                        DateFormat('dd/MM/yyyy').format(
                          document.appointmentTime.toDate(),
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(fontSize: fontsize.fontSize - 4),
                      ),
                      onTap: () {},
                    );
                  },
                ),
              ),
              error: (error, stackTrace) {
                print(error);
                return ErrorText(
                  error: error.toString(),
                );
              },
              loading: () => const Loader(),
            ),
          ],
        ),
      ),
    );
  }
}