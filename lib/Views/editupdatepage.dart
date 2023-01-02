
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class CreatEditpage extends StatefulWidget {
   const CreatEditpage({Key? key}) : super(key: key);

  @override
  State<CreatEditpage> createState() => _CreatEditpageState();
}

class _CreatEditpageState extends State<CreatEditpage> {
  String? emailid;
  getpref()async{
    SharedPreferences prefrence = await SharedPreferences.getInstance();
    setState(() {
      emailid= prefrence.getString('email');
      String? passwordd = prefrence.getString('password');
    });

  }
  // fetchtext(){
  //   setState(() {
  //     title.text=widget.title;
  //     content.text=widget.content;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getpref();
    // fetchtext();
    super.initState();
  }

  TextEditingController title= TextEditingController();
  TextEditingController content = TextEditingController();
  adddata()async{
    await FirebaseFirestore.instance.collection('notes').add({'title':title.text,'content':content.text,'email':emailid.toString(),'date':DateTime.now()});
  }
  updatedata()async{
    await FirebaseFirestore.instance.collection('notes').doc().update({'title':title.text,'content':content.text});

  }
  deletedata()async{
    // var collection = FirebaseFirestore.instance.collection("notes");
    // var snapshots = await collection.get();
    // for(var doc in snapshots.docs)
    // {
    //   await doc.reference.delete();
    // }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(236,227,182,1),
      body: 
      SingleChildScrollView(
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(left: 20,right: 20,top: 20),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          Padding(
                            padding: const EdgeInsets.only(top:15,bottom: 15),
                            child: Text('Write your memos'),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height/20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topLeft:Radius.elliptical(20, 15) ,topRight: Radius.elliptical(15, 20),)
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: TextField(
                          controller: title,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title"
                          ),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15,top: 5),
                    child: Container(
                      height: MediaQuery.of(context).size.height/2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(bottomLeft: Radius.elliptical(20, 15),bottomRight: Radius.elliptical(15,20)),
                      ),
                      child:
                      Padding(
                        padding: const EdgeInsets.only(left: 15,right: 15),
                        child: TextField(
                          controller: content,
                          maxLines: 55,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Content',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30,right: 30,top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap:(){
                            setState(() {
                              deletedata();
                              Navigator.pop(context);
                            });
                          },
                            child: Icon(Icons.delete_forever_outlined,size: 42,)),
                        InkWell(onTap: (){
                          setState(() {
                            adddata();
                            Navigator.pop(context);
                          });
                        },
                            child: Icon(Icons.save_as_outlined,size: 42,))
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
