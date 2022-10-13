import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_vimigo/constant.dart';
import 'package:flutter_vimigo/model/contact_model.dart';
import 'package:flutter_vimigo/screens/details/details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../../db/database_helper.dart';
import 'dart:core';

// initial data as stated in Assessment question page 2
const List<Map<String?, String?>> _initialData = [
  {
    "user": "Chan Saw Lin",
    "phone": "0152131113",
    "checkIn": "2020-06-30 16:10:05"
  },
  {
    "user": "Lee Saw Loy",
    "phone": "0161231346",
    "checkIn": "2020-07-11 15:39:59"
  },
  {
    "user": "Khaw Tong Lin",
    "phone": "0158398109",
    "checkIn": "2020-08-19 11:10:18"
  },
  {
    "user": "Lim Kok Lin",
    "phone": "0168279101",
    "checkIn": "2020-08-19 11:11:35"
  },
  {
    "user": "Low Jun Wei",
    "phone": "0112731912",
    "checkIn": "2020-08-15 13:00:05"
  },
  {
    "user": "Yong Weng Kai",
    "phone": "0172332743",
    "checkIn": "2020-07-31 18:10:11"
  },
  {
    "user": "Jayden Lee",
    "phone": "0191236439",
    "checkIn": "2020-08-22 08:10:38"
  },
  {
    "user": "Kong Kah Yan",
    "phone": "0111931233",
    "checkIn": "2020-07-11 12:00:00"
  },
  {
    "user": "Jasmine Lau",
    "phone": "0162879190",
    "checkIn": "2020-08-01 12:10:05"
  },
  {
    "user": "Chen Saw Ling",
    "phone": "016783239",
    "checkIn": "2020-08-23 11:59:05"
  }
];

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  List<dynamic> displayData = []; //final data that will be displayed
  List<dynamic> displayDataByDate = []; //final data by date
  int? isStored; // sharedPreference purpose
  bool _isLoading = true;
  bool _isAscending = true;
  bool _isByDate = false;

  final TextEditingController searchText = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String createDate = DateFormat('yyyy-MM-dd hh:mm:ss')
      .format(DateTime.now()); // DateTime format

  @override
  void initState() {
    super.initState();
    _initializeData(); // Load the data when the app starts
  }

  // This function is used to fetch all data from the database
  /* void _refreshData() async {
    final data = await DatabaseHelper.getContact();
    setState(() {
      displayData = data;

      _isLoading = false;
    });
  } */

  _refreshDataByDate() async {
    displayDataByDate = await DatabaseHelper.instance.getContactByDate();
    return displayDataByDate;
  }

  void _refreshData() async {
    setState(() => _isLoading = true);
    displayData = await DatabaseHelper.instance.getContact();
    displayDataByDate = await DatabaseHelper.instance.getContactByDate();
    setState(() => _isLoading = false);
  }

  // This function is used to initiate the predefined dataset
  void _initializeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isStored = prefs.getInt('storedData');

    if (isStored != 1) {
      _generateContacts();
      _storeDataInfo();
    } else {
      _refreshData();
    }
  }

  // Save the SharedPreferenced whether the initial dataset have been initialized
  void _storeDataInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setInt('storedData', 1);
  }

  // To generate all predefined contacts data from the given dataset
  /* void _generateContacts() async {
    // data generation
    for (var i = 0; i < _initialData.length; i++) {
      await DatabaseHelper.createContact(_initialData[i]['user'],
          _initialData[i]['phone'], _initialData[i]['checkIn']);
    }
    _refreshData();
  } */

  void _generateContacts() async {
    // data generation
    for (var i = 0; i < _initialData.length; i++) {
      final contact = Contact(
          user: _initialData[i]['user'],
          phone: _initialData[i]['phone'],
          checkIn: _initialData[i]['checkIn']);

      await DatabaseHelper.instance.createContact(contact);
    }
    _refreshData();
  }

  // Texfield validation
  String? formValidator(String? value) {
    if (value!.isEmpty) return 'Field is Required';
    return null;
  }

  // Convert DateTime to desired format (d MMM y hh:mm a)
  _convertDate(dateTime) {
    DateTime convertTime = DateTime.parse(dateTime);
    String formattedDate = DateFormat('d MMM y hh:mm a').format(convertTime);

    return formattedDate;
  }

  // Add a new user to the database
  /* Future<void> addItem() async {
    await DatabaseHelper.createContact(
        _userController.text, _phoneController.text, createDate);

    showToast();
    _refreshData();
  } */

  Future addItem() async {
    final contact = Contact(
        user: _userController.text,
        phone: _phoneController.text,
        checkIn: createDate);

    await DatabaseHelper.instance.createContact(contact);

    showToast();
    _refreshData();
  }

  // Toast message when a new user created
  void showToast() => Fluttertoast.showToast(
        msg: "User added!",
        fontSize: 16.0,
        backgroundColor: kToastColor,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
      );

  // database filtering for Search feature
  void filterSearch(String query) async {
    final data = await DatabaseHelper.instance.getContact();
    final dataByDate = await DatabaseHelper.instance.getContactByDate();

    if (_isByDate == true) {
      if (query.isNotEmpty) {
        var dummyList = [];
        for (var i = 0; i < dataByDate.length; i++) {
          if (dataByDate[i]
              .user
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            dummyList.add(dataByDate[i]);
          }
        }
        setState(
          () {
            displayData = dummyList;
          },
        );
      } else {
        setState(
          () {
            _refreshData();
          },
        );
      }
    } else {
      if (query.isNotEmpty) {
        var dummyList = [];
        for (var i = 0; i < data.length; i++) {
          if (data[i]
              .user
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase())) {
            dummyList.add(data[i]);
          }
        }
        setState(
          () {
            displayData = dummyList;
          },
        );
      } else {
        setState(
          () {
            _refreshData();
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMIGO CONTACTS'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        leading: IconButton(
            onPressed: (() {
              _isAscending = !_isAscending;
            }),
            icon: SvgPicture.asset(
              'assets/icons/sort-alt.svg',
              color: Colors.white,
            )),
        actions: [
          IconButton(
              onPressed: () {
                // sort Ascending/Descending
                setState(() {
                  /* _refreshDataByDate(); */
                  _isByDate = !_isByDate;
                });
              },
              icon: SvgPicture.asset(
                'assets/icons/sort-numeric-down.svg',
                color: Colors.white,
              ))
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(children: [
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    // search bar
                    child: TextField(
                      controller: searchText,
                      onChanged: (value) {
                        setState(() {
                          filterSearch(value);
                        });
                      },
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search contact...',
                        prefixIcon: Icon(
                          Icons.search,
                          color: Colors.blueAccent,
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black26)),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    // if no data = display 'No Contact Found'
                    child: displayData.isEmpty
                        ? const Center(child: Text("No Contact Found"))
                        // generate listview based on data
                        : ListView.builder(
                            itemCount: displayData.length,
                            itemBuilder: (context, index) {
                              // sort data ascending or descending
                              final sortedItems = _isAscending
                                  ? displayDataByDate
                                  : displayData;

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                elevation: 1,
                                child: ListTile(
                                  title: Text(sortedItems[index].user),
                                  subtitle: Text(sortedItems[index].phone),
                                  trailing: Text(
                                      _convertDate(sortedItems[index].checkIn)),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) => DetailsPage(
                                                userValue:
                                                    sortedItems[index].user,
                                                phoneValue:
                                                    sortedItems[index].phone,
                                                checkInValue: _convertDate(
                                                    sortedItems[index]
                                                        .checkIn)))));
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: FloatingActionButton(
                    backgroundColor: kButtonColor,
                    child: const Icon(Icons.add),
                    onPressed: () => showMyForm(), //show bottomModalSheet
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.height * 0.12,
                  // Animation based on given spritesheet
                  child: SpriteAnimationWidget.asset(
                    path: 'animation.png', //given spritesheet
                    data: SpriteAnimationData.sequenced(
                      amount: 35, // total of sprites in the spritesheet
                      amountPerRow: 12, // total of sprites in a row
                      stepTime: 0.1, // steptime 0.1s
                      textureSize: Vector2(
                          170, 171), // size of every sprite (170px*171px)
                    ),
                    playing: true,
                    anchor: Anchor.center,
                  ),
                ),
              )
            ]),
    );
  }

  // This function will be triggered when the floating button is pressed
  void showMyForm() async {
    _userController.text = '';
    _phoneController.text = '';

    //ModalBottomSheet for adding new user
    showModalBottomSheet(
        context: context,
        elevation: 5,
        isDismissible: true,
        isScrollControlled: true,
        builder: (_) => Container(
            padding: EdgeInsets.only(
              top: 15,
              left: 15,
              right: 15,
              // prevent the keyboard from covering the text fields
              bottom: MediaQuery.of(context).viewInsets.bottom + 120,
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormField(
                    validator: formValidator,
                    controller: _userController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(hintText: 'Name'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: formValidator,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(hintText: 'Phone'),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor),
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            await addItem();

                            // Clear the text fields
                            setState(() {
                              _userController.clear();
                              _phoneController.clear();
                            });

                            // Close the bottom sheet
                            // ignore: use_build_context_synchronously
                            Navigator.pop(context);
                          }
                          // Save new data
                        },
                        child: const Text('Add New User'),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
