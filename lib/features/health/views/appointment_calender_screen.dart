import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackathon_proj/models/prescription_model.dart';
import 'package:hackathon_proj/theme/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:provider/provider.dart' as provider;
import '../../../core/common/loader.dart';
import '../../../core/utils/notification_service.dart';
import '../../../models/appointment_model.dart';
import '../../../theme/theme_provider.dart';
import '../../auth/controller/auth_controller.dart';

class AppointmentCalendarScreen extends ConsumerStatefulWidget {
  const AppointmentCalendarScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AppointmentCalendarScreen> createState() =>
      _AppointmentCalendarScreenState();
}

class _AppointmentCalendarScreenState
    extends ConsumerState<AppointmentCalendarScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDate;

  Map<String, List> mySelectedEvents = {};

  final titleController = TextEditingController();
  final descpController = TextEditingController();
  List<AppointmentModel> firestoreEvents = []; // Declare it here

  Future<void> addEventToFirestore(AppointmentModel event) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(event.id)
          .set(event.toMap());
    } catch (e) {
      print('Error adding Appointment : $e');
    }
  }

  Future<void> deleteEventFromFirestore(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(id)
          .delete();
    } catch (e) {
      print('Error removing Appointment : $e');
    }
  }

  Stream<List<AppointmentModel>> getEventsFromFirestore() {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('userId', isEqualTo: ref.read(userProvider)!.id)
        .snapshots()
        .map(
      (QuerySnapshot querySnapshot) {
        return querySnapshot.docs.map(
          (QueryDocumentSnapshot doc) {
            return AppointmentModel.fromMap(doc.data() as Map<String, dynamic>);
          },
        ).toList();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _selectedDate = _focusedDay;
  }

  List _listOfDayEvents(DateTime dateTime, List<AppointmentModel> events) {
    final selectedDateEvents = events
        .where((event) =>
            DateFormat('yyyy-MM-dd').format(event.timestamp.toDate()) ==
            DateFormat('yyyy-MM-dd').format(dateTime))
        .toList();

    return selectedDateEvents;
  }

  _showAddEventDialog() async {
    TimeOfDay? selectedTime;

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Add New Event',
          textAlign: TextAlign.center,
        ),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descpController,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                selectedTime = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
              },
              child: const Text('Select Time'),
            ),
          ],
        ),
        actions: [
          Container(
            decoration: BoxDecoration(
              // Color of the circle
              color: Colors.red,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ), // Makes the container circular
              // Optional: Adding a border around the circle
              border: Border.all(
                color: Colors.red,
                // Color of the border
                width: 2.0, // Thickness of the border
              ),
            ),
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                style: TextStyle(
                  color:
                  Colors.black,
                  fontWeight: FontWeight.bold
              ),),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              // Color of the circle
              color: Colors.green,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ), // Makes the container circular
              // Optional: Adding a border around the circle
              border: Border.all(
                color: Colors.green, // Color of the border
                width: 2.0, // Thickness of the border
              ),
            ),
            child: TextButton(
              child: const Text('Add Appointment',
              style: TextStyle(
                color:
                  Colors.black,
                  fontWeight: FontWeight.bold
              ),),
              onPressed: () {
                if (titleController.text.isEmpty &&
                    descpController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Required title and description'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                  return;
                } else {
                  setState(() {
                    final DateTime selectedDateTime = DateTime(
                      _selectedDate!.year,
                      _selectedDate!.month,
                      _selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute,
                    );
                    final appointmentId = Uuid().v1();
                    AppointmentModel newEvent = AppointmentModel(
                      userId: ref.read(userProvider)!.id,
                      title: titleController.text,
                      desc: descpController.text,
                      timestamp: Timestamp.fromDate(selectedDateTime),
                      id: appointmentId,
                    );

                    // Add the event to Firestore
                    addEventToFirestore(newEvent);
                    NotificationService().scheduleNotification(
                        title: titleController.text,
                        body: descpController.text,
                        scheduledNotificationDateTime: selectedDateTime);
                    if (mySelectedEvents[DateFormat('yyyy-MM-dd')
                            .format(selectedDateTime)] !=
                        null) {
                      mySelectedEvents[
                              DateFormat('yyyy-MM-dd').format(selectedDateTime)]
                          ?.add({
                        "eventTitle": titleController.text,
                        "eventDescp": descpController.text,
                        "time": selectedTime!.format(context),
                      });
                    } else {
                      mySelectedEvents[
                          DateFormat('yyyy-MM-dd').format(selectedDateTime)] = [
                        {
                          "eventTitle": titleController.text,
                          "eventDescp": descpController.text,
                          "time": selectedTime!.format(context),
                        }
                      ];
                    }
                  });

                  print(
                      "New Event for backend developer ${json.encode(mySelectedEvents)}");
                  titleController.clear();
                  descpController.clear();
                  Navigator.pop(context);
                }
              },
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = provider.Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    final user = ref.watch(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Appointments Calendar',
          style: Theme.of(context).textTheme.displayLarge!.copyWith(
                fontSize: 24,
                color: isDarkTheme ? Colors.white : Lcream,
              ),
        ),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2022),
            lastDay: DateTime.now().add(Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                var dayEvents = _listOfDayEvents(day, firestoreEvents);
                if (dayEvents.isNotEmpty) {
                  // This is a day with events
                  return Container(
                    margin: const EdgeInsets.all(4.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red, // Background color for days with events
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      day.day.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                } else {
                  // This is a regular day without events
                  return null; // Return null to use the default day builder
                }
              },
            ),
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDate, selectedDay)) {
                setState(() {
                  _selectedDate = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
            },

            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },


      calendarStyle: CalendarStyle(
        // Highlight today's date with a red border
        markerDecoration: BoxDecoration(
          color: Dcream, // Pink color for event dots
          shape: BoxShape.circle,

        ),

        todayDecoration: BoxDecoration(
          color: Colors.green,// Use transparent to show the default color or set a custom color
          border: Border.all(color:
          Colors.green, width: 2),
          shape: BoxShape.circle,
        ),),
            eventLoader: (dateTime) =>
                _listOfDayEvents(dateTime, firestoreEvents),
          ),

          Expanded(
            child: StreamBuilder<List<AppointmentModel>>(
              stream: getEventsFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Loader();
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  firestoreEvents = snapshot.data!;
                  List<AppointmentModel> selectedDateEvents = firestoreEvents
                      .where((event) =>
                          DateFormat('yyyy-MM-dd')
                              .format(event.timestamp.toDate()) ==
                          DateFormat('yyyy-MM-dd').format(_selectedDate!))
                      .toList();
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: selectedDateEvents.length,
                    itemBuilder: (context, index) {
                      final firestoreEvent = selectedDateEvents[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(
                          color: isDarkTheme ? Dcream : Lpurple1,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Event Title: ${firestoreEvent.title}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: isDarkTheme
                                              ? Colors.black
                                              : Lcream),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Description: ${firestoreEvent.desc}',
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isDarkTheme
                                              ? Colors.black
                                              : Lcream),
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Time: ${DateFormat('hh:mm a, MMM dd, yyyy').format(firestoreEvent.timestamp.toDate())}',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: isDarkTheme
                                              ? Colors.black
                                              : Lcream),
                                    ),
                                  ],
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: isDarkTheme
                                        ? Dbrown3
                                        : Lpurple2, // Color of the circle
                                    shape: BoxShape
                                        .circle, // Makes the container circular
                                    // Optional: Adding a border around the circle
                                    border: Border.all(
                                      color: isDarkTheme
                                          ? Colors.white
                                          : Lcream, // Color of the border
                                      width: 2.0, // Thickness of the border
                                    ),
                                  ),
                                  child: IconButton(
                                    onPressed: () => deleteEventFromFirestore(
                                        firestoreEvent.id),
                                    icon: Icon(Icons.delete,
                                        color: isDarkTheme
                                            ? Colors.white
                                            : Lcream),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: isDarkTheme ? Dcream : Theme.of(context).primaryColor,
        onPressed: () => _showAddEventDialog(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        label: const Text('Add Event',
            style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w500)),
      ),
    );
  }
}
