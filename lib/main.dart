import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CloudFireStore(),
    );
  }
}

class GetData {
  reviews() {
    return FirebaseFirestore.instance.collection("users").get();
  }
}

class SetData {
  setReview(String firstName, String lastName) {
    print("First Name : $firstName - Last Name : $lastName");
    return FirebaseFirestore.instance.collection("users").doc().set(
      {
        "firstName": firstName,
        "lastName": lastName,
      },
    );
  }
}

class CloudFireStore extends StatefulWidget {
  const CloudFireStore({Key? key}) : super(key: key);

  @override
  _CloudFireStoreState createState() => _CloudFireStoreState();
}

class _CloudFireStoreState extends State<CloudFireStore> {
  bool reviewFlag = false;
  List<Map> reviews = [];
  bool flag = false;
  var users;
  @override
  void initState() {
    super.initState();
    SetData().setReview("yatri", "dave");
    GetData().reviews().then((QuerySnapshot snapShot) {
      if (snapShot.docs.isNotEmpty) {
        reviewFlag = true;
        snapShot.docs.forEach((QueryDocumentSnapshot element) {
          reviews.add(element.data() as Map);
        });
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Reviews",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            "Letest Reviews",
            style: TextStyle(
              color: Colors.black,
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 45,
          ),
          reviewFlag
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: reviews.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          reviews[index]["firstName"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          reviews[index]["lastName"],
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    );
                  })
              : SizedBox(),
          flag
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      users["firstName"] ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      users["lastName"] ?? "",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
                    ),
                  ],
                )
              : SizedBox(),
        ],
      ),
    );
  }
}
