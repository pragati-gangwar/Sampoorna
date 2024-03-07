import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hackathon_proj/features/SOS/primaryButton.dart';
import 'package:hackathon_proj/features/SOS/sos_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'package:sqflite/sqflite.dart';


import '../../constant.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_provider.dart';
import 'contact_model.dart';
import 'db_services.dart';

class AddContactsPage extends StatefulWidget {
  const AddContactsPage({super.key});

  @override
  State<AddContactsPage> createState() => _AddContactsPageState();
}

class _AddContactsPageState extends State<AddContactsPage> {
  DatabaseHelper databasehelper = DatabaseHelper();


  List<TContact>? contactList;
  int count = 0;

  void showList() {
    Future<Database> dbFuture = databasehelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<TContact>> contactListFuture =
      databasehelper.getContactList();
      contactListFuture.then((value) {
        setState(() {
          this.contactList = value;
          this.count = value.length;
        });
      });
    });
  }

  void deleteContact(TContact contact,bool isDarkTheme ) async {
    int result = await databasehelper.deleteContact(contact.id);
    if (result != 0) {
      Fluttertoast.showToast(msg: "contact removed succesfully",
      backgroundColor: isDarkTheme ? Dcream : Lpurple1,);
      showList();
    }
  }
  Position? _curentPosition;
  String? _curentAddress;
  LocationPermission? permission;
  _getPermission() async => await [Permission.sms].request();
  _isPermissionGranted() async => await Permission.sms.status.isGranted;

  _sendSms(String phoneNumber, String message, {int? simSlot}) async {
    SmsStatus result = await BackgroundSms.sendMessage(
        phoneNumber: phoneNumber, message: message, simSlot: 1);
    if (result == SmsStatus.sent) {
      print("Sent");
      Fluttertoast.showToast(msg: "send");
    } else {
      Fluttertoast.showToast(msg: "failed");
    }
  }
  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  _getCurrentLocation() async {
    final hasPermission = await _handleLocationPermission();
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      Fluttertoast.showToast(msg: "Location permissions are  denind");
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.requestPermission();
        Fluttertoast.showToast(
            msg: "Location permissions are permanently denind");
      }
    }
    Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        _curentPosition = position;
        print(_curentPosition!.latitude);
        _getAddressFromLatLon();
      });
    }).catchError((e) {
      Fluttertoast.showToast(msg: e.toString());
    });
  }

  _getAddressFromLatLon() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _curentPosition!.latitude, _curentPosition!.longitude);

      Placemark place = placemarks[0];
      setState(() {
        _curentAddress =
        "${place.locality},${place.subLocality},${place.street},${place.postalCode},${place.country}";
      });
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  getAndSendSms(int index, String m) async {
    String messageBody =
        "https://maps.google.com/?daddr=${_curentPosition!.latitude},${_curentPosition!.longitude}";
    if (await _isPermissionGranted()) {

        _sendSms("${contactList![index].number}", "$m $messageBody");
      }
     else {

      Fluttertoast.showToast(msg: "something wrong");
    }
  }
  String _templateMessage = "I am in trouble. Please help me. My location: ";
  var _counterText ="";
  void showMessageEditDialog(TContact contact, int index) {
    String message = _templateMessage; // Initialize message with template

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('SOS Message'),
          content: TextField(
            maxLength: 500,
            maxLines: 8,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
            onChanged: (value) {
               // Update message as user types
              setState(() {
                message = value;
                // _counterText =(500 - value.length).toString();
              });
            },
            controller: TextEditingController(text: _templateMessage), // Prefill with template message
            decoration: InputDecoration(
              // counterText: "Remaining: $_counterText",
              hintText: 'Enter your message',
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Colors.red,
              textColor: Colors.white,
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              child: Text('Send'),
              onPressed: () {
                getAndSendSms(index, message); // Pass updated message
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      showList();
    });
    _getPermission();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (contactList == null) {
      contactList = [];
    }
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDarkTheme = themeProvider.isDark;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body:
        Container(
            padding: EdgeInsets.all(18),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8, left: 20.0, right: 20),
                  child: PrimaryButton(
                      title: "Add Trusted Contacts",
                      onPressed: () async {
                        bool result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ContactsPage(),
                            ));
                        if (result == true) {
                          showList();
                        }
                      }),
                ),
                Expanded(
                  child: ListView.builder(
                    // shrinkWrap: true,
                    itemCount: count,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          showMessageEditDialog(contactList![index],index);
                        },
                        child: Card(
                          color: isDarkTheme ? Dcream : Ldisablef,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text(contactList![index].name,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: isDarkTheme ? Dbrown1 : Dbrown2,
                                fontSize: 21,
                                fontWeight: FontWeight.w600,
                              ),),
                              trailing: Container(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () async {
                                          await FlutterPhoneDirectCaller.callNumber(
                                              contactList![index].number);
                                        },
                                        icon: Icon(
                                          Icons.call,
                                          color: Colors.green.shade700,
                                          size: 32,
                                        )),
                                    IconButton(
                                        onPressed: () {
                                          deleteContact(contactList![index],isDarkTheme);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red.shade600,
                        
                                          size: 32,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            )),
      ),
    );
  }

}