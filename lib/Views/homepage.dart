import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:noteappwithfirebase/Views/editupdatepage.dart';
import 'package:noteappwithfirebase/Views/loginpage.dart';
import 'package:noteappwithfirebase/Views/updatecontent.dart';
import 'package:noteappwithfirebase/controler/controls.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:noteappwithfirebase/controler/controls.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  dynamic userdata;
  bool updater = false;
  bool marked = false;
  List<Map<String, dynamic>> datas = [];
  String? emailid;
  void getpref() async {
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    setState(() {
      emailid = prefrence.getString('email');
      String? passwordd = prefrence.getString('password');
    });
  }

  void deletedata() async {
    await FirebaseFirestore.instance.collection('notes').doc(docid).delete();
  }

  void deleteall() async {
    var collection = FirebaseFirestore.instance.collection("notes");
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
    editpage = false;
  }

  List<Map<dynamic, dynamic>> searcheditem = [];
  void searchdata(String value) {
    searcheditem.clear();
    notesList.forEach((element) {
      if (element['title'].toString().contains(value) ||
          element['content'].toString().contains(value)) {
        searcheditem.add({
          'title': element['title'].toString(),
          'content': element['content'].toString()
        });
        print(searcheditem);
        setState(() {});
      }
    });
  }

  TextEditingController searchnotes = TextEditingController();
  bool editpage = false;
  @override
  void initState() {
    // TODO: implement initState
    getpref();
    editpage = false;
    super.initState();
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> notesList = [];
  final GlobalKey<ScaffoldState> scafoldkey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // key: scafoldkey,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromRGBO(50, 50, 50, 1),
        child: Icon(Icons.add),
        onPressed: () {
          setState(() {});
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CreatEditpage(),
              ));
        },
      ),
      backgroundColor: Color.fromRGBO(236, 227, 182, 1),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              decoration:
                  BoxDecoration(color: Color.fromRGBO(236, 227, 182, 1)),
              accountName: Text('aa',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 22),
              ),
              accountEmail: Text(
                emailid.toString(),
                style: TextStyle(color: Colors.black),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return Homepage();
                  },
                ));
              },
              child: Container(
                child: ListTile(
                  leading: Text(
                    "Home",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () {
                setState(() {
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                    // the new route
                    MaterialPageRoute(
                      builder: (BuildContext context) => Loginpage(),
                    ),

                    // this function should return true when we're done removing routes
                    // but because we want to remove all other screens, we make it
                    // always return false
                    (Route route) => false,
                  );
                });
              },
              child: Container(
                child: ListTile(
                  leading: Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  trailing: Icon(Icons.logout),
                ),
              ),
            )
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: InkWell(
            //     onTap: (){
            //       scafoldkey.currentState?.openDrawer();
            //
            //     },
            //       child: Icon(Icons.menu,size: 32,)),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 25),
              child: Text(
                'Notes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: TextField(
                    controller: searchnotes,
                    onChanged: (value) {
                      searchdata(value);
                    },
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      icon: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Icon(
                          Icons.search_rounded,
                          color: Colors.grey,
                        ),
                      ),
                      hintText: 'Search Notes',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 25,
            ),
            editpage == true
                ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            deleteall();
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Color.fromRGBO(50, 50, 50, 1),
                              borderRadius: BorderRadius.circular(25)),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              'Delete All',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    )
                  ])
                : Container(),
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('notes').snapshots(),
                builder: (context, AsyncSnapshot snapshot) {
                  // print(snapshot.data!.docs[0].data()["title"]);
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasData) {
                    notesList.clear();
                    snapshot.data!.docs.forEach((e) {
                      if (e.data()['email'] == emailid) {
                        notesList.add(e);
                      }
                    });
                    return searchnotes.text.isEmpty
                        ? Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount:
                                    notesList.isNotEmpty ? notesList.length : 0,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        docid = notesList[index].id;
                                        editpage == true
                                            ? editpage = false
                                            : editpage = true;
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        docid = notesList[index].id;
                                        updater = true;
                                        editpage = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdatePage(
                                                title: notesList[index]
                                                    .data()['title'],
                                                content: notesList[index]
                                                    .data()['content']),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  notesList[index]
                                                      .data()['title']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              editpage == true
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          deletedata();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Icon(Icons
                                                            .delete_forever_outlined),
                                                      ))
                                                  : Container(),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 15),
                                            child: Text(
                                              notesList[index]
                                                  .data()['content'],
                                              overflow: TextOverflow.visible,
                                              maxLines: 5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, bottom: 15),
                              child: GridView.builder(
                                gridDelegate:
                                    SliverGridDelegateWithMaxCrossAxisExtent(
                                        maxCrossAxisExtent: 200,
                                        crossAxisSpacing: 20,
                                        mainAxisSpacing: 20),
                                itemCount: searcheditem.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onLongPress: () {
                                      setState(() {
                                        docid = notesList[index].id;
                                        editpage == true
                                            ? editpage = false
                                            : editpage = true;
                                      });
                                    },
                                    onTap: () {
                                      setState(() {
                                        docid = notesList[index].id;
                                        updater = true;
                                        editpage = false;
                                      });
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UpdatePage(
                                                title: notesList[index]
                                                    .data()['title'],
                                                content: notesList[index]
                                                    .data()['content']),
                                          ));
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Text(
                                                  searcheditem[index]['title']
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ),
                                              editpage == true
                                                  ? InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          deletedata();
                                                        });
                                                      },
                                                      child: Container(
                                                        child: Icon(Icons
                                                            .delete_forever_outlined),
                                                      ))
                                                  : Container(),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10, left: 15),
                                            child: Text(
                                              searcheditem[index]['content'],
                                              overflow: TextOverflow.visible,
                                              maxLines: 5,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                  } else {
                    return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                        ),
                        child: Text('Add memos'));
                  }
                })
          ],
        ),
      ),
    );
  }
}
