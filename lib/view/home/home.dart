import 'package:flame/components.dart';
import 'package:flame/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vimigo/constant.dart';
import 'package:flutter_vimigo/view/details/details.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../db/database_helper.dart';

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
  int? isStored; // sharedPreference purpose
  bool _isLoading = true;
  bool _isDescending = false;

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
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      displayData = data;

      _isLoading = false;
    });
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
  void _generateContacts() async {
    // data generation
    for (var i = 0; i < _initialData.length; i++) {
      await DatabaseHelper.createItem(_initialData[i]['user'],
          _initialData[i]['phone'], _initialData[i]['checkIn']);
    }
    _refreshData();
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
  Future<void> addItem() async {
    await DatabaseHelper.createItem(
        _userController.text, _phoneController.text, createDate);

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
    final data = await DatabaseHelper.getItems();

    if (query.isNotEmpty) {
      var dummyList = [];
      for (var i = 0; i < data.length; i++) {
        if (data[i]['user'].toLowerCase().contains(query.toLowerCase())) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VIMIGO CONTACTS'),
        centerTitle: true,
        backgroundColor: kPrimaryColor,
        actions: [
          IconButton(
              onPressed: () {
                // sort Ascending/Descending
                setState(() {
                  _isDescending = !_isDescending;
                });
              },
              icon: const Icon(Icons.sort))
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
                    child: displayData.isEmpty
                        ? const Center(child: Text("No Contact Found"))
                        // generate listview based on data
                        : ListView.builder(
                            itemCount: displayData.length,
                            itemBuilder: (context, index) {
                              final sortedItems = _isDescending
                                  ? displayData.reversed.toList()
                                  : displayData;

                              final sortedData = sortedItems;

                              return Card(
                                color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                elevation: 1,
                                child: ListTile(
                                  title: Text(sortedData[index]['user']),
                                  subtitle: Text(sortedData[index]['phone']),
                                  trailing: Text(_convertDate(
                                      sortedData[index]['checkIn'])),
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: ((context) => DetailsPage(
                                                userValue: sortedData[index]
                                                    ['user'],
                                                phoneValue: sortedData[index]
                                                    ['phone'],
                                                checkInValue: _convertDate(
                                                    sortedData[index]
                                                        ['checkIn'])))));
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
                    onPressed: () => showMyForm(),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.height * 0.12,
                  child: SpriteAnimationWidget.asset(
                    path: 'animation.png',
                    data: SpriteAnimationData.sequenced(
                      amount: 35,
                      amountPerRow: 12,
                      stepTime: 0.1,
                      textureSize: Vector2(170, 171),
                    ),
                    playing: true,
                    anchor: Anchor.center,
                  ),
                ),
              )
            ]),
    );
  }
}
