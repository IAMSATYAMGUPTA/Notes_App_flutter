import 'dart:math';

import 'package:beautiful_notes_appf/db_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'notesModal.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var titleControler = TextEditingController();
  var desControler = TextEditingController();

  String? uTitle;
  String? uDesc;

  DBHelper? dbHelper = DBHelper();
  late Future<List<NotesModel>> notesList;

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  var date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.indigo.shade500,
        child: Column(
          children: [
            SizedBox(height: 48,),
            Text("Notes App", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 22),),
            SizedBox(height: 10,),
            FutureBuilder(future: notesList,builder: (context,AsyncSnapshot<List<NotesModel>>  snapshot) {

              // open choice alert dialog to check user activity
              if(snapshot.hasData){
                return ListView.builder(reverse: true,shrinkWrap: true,itemCount: snapshot.data?.length,itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      showDialog(context: context,
                        builder: (context) =>
                            choiceAlertdialog(index: index,choicesnapshot: snapshot),
                      );
                    },
                    child: Card(
                      margin: EdgeInsets.only(left: 15,right: 15,bottom: 20),
                      color: Colors.indigo.shade900,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15,right: 8,top: 14,bottom: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(snapshot.data![index].title,style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.w500),maxLines: 1),
                            SizedBox(height: 11,),
                            Text(snapshot.data![index].description,style: TextStyle(color: Colors.white70,fontSize: 14),maxLines: 4,),
                            SizedBox(height: 11,),
                            Text(snapshot.data![index].dateTime,style: TextStyle(color: Colors.white38),maxLines: 1,),
                          ],
                        ),
                      ),
                    ),
                  );
                },);
              }
              else{
                return Container();
              }
            },),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        onPressed: () {
          showDialog(context: context,
            builder: (context) => simpleAlertDialog(context),);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget simpleAlertDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.indigoAccent,

      // set shape alert dialog
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),

      // set title
      title: Center(child: Text("Create New Note",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),

      // declare to textfeild title and description
      content: Container(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              RoundTextField(controller: titleControler,maxLine: 1,hintText: "Title"),
              SizedBox(height: 10,),
              RoundTextField(controller: desControler, maxLine: 10,hintText: "Description ...")
            ],
          ),
        ),
      ),

      // declare two button save and exit
      actions: [

        // data added button
        ElevatedButton(
          onPressed: (){
            dbHelper!.insert(
              NotesModel(
                  title: titleControler.text.toString(),
                  description: desControler.text.toString(),
                  dateTime: (DateFormat.yMd().add_jm().format(date)).toString()
              )
            ).then((value) => {
              // if succesful data added
              Fluttertoast.showToast(
              msg: "New note created Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black45,
              textColor: Colors.white,
              fontSize: 16.0
              ),
              setState(() {
                titleControler.clear();
                desControler.clear();
                notesList = dbHelper!.getNotesList();
              }),
            }).onError((error, stackTrace) => {print(error.toString())}
            );
            Navigator.of(context).pop();
          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
          child: bChild(bTitle: "Save",icon: Icons.save),
        ),

        // alertDialog close button
        ElevatedButton(onPressed: (){Navigator.of(context).pop();  },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
          child: bChild(bTitle: "Exit",icon: Icons.exit_to_app),
        ),
        SizedBox(width: 10,),
      ],
    );
  }

  Widget updateAlertDialog(BuildContext context,String title1,String description,int? uId) {
    return AlertDialog(

      // set alertDialog Background
      backgroundColor: Colors.indigoAccent,

      // set Title
      title: Center(child: Text("Create New Note",style: TextStyle(color: Colors.white,fontSize: 18,fontWeight: FontWeight.bold),)),

      // declare two textfeild
      content: Container(
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                onChanged: (value){
                  uTitle = value;
                },
                controller: TextEditingController(text: title1),
                style: TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo,
                  hintText: "Title",
                  hintStyle: TextStyle(color: Colors.white70,fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              TextField(
                onChanged: (value){
                  uDesc = value;
                },
                controller: TextEditingController(text: description),
                style: TextStyle(color: Colors.white),
                maxLines: 10,
                decoration: const InputDecoration(
                  filled: true,
                  fillColor: Colors.indigo,
                  hintText: "Description ...",
                  hintStyle: TextStyle(color: Colors.white70,fontSize: 18),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(width: 1),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // set alertDialog shape
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))
      ),

      actions: [
        ElevatedButton(
          onPressed: (){
            if(uTitle!=null && uDesc!=null){
              dbHelper!.update(
                  NotesModel(id:uId,description: uDesc.toString(), title: uTitle.toString()));

            }else if (uTitle!=null){
              dbHelper!.update(
                  NotesModel(id:uId,description: description, title: uTitle.toString()));
            }
            else if(uDesc!=null){
              dbHelper!.update(
                  NotesModel(id:uId,description: uDesc.toString(), title: title1));
            }
            setState(() {
              notesList = dbHelper!.getNotesList();
            });
            uTitle=null;
            uDesc=null;
            Navigator.of(context).pop();

          },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
          child: Container(
            width: 76,
            child: bChild(bTitle: "Update", icon: Icons.save)
          ),),
        ElevatedButton(onPressed: (){Navigator.of(context).pop();  },
          style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
          child: bChild(bTitle: "Close", icon: Icons.exit_to_app)),
        SizedBox(width: 10,),
      ],
    );
  }

  Widget choiceAlertdialog({required int index,required AsyncSnapshot<List<NotesModel>>  choicesnapshot}){
    return AlertDialog(
      backgroundColor: Colors.indigoAccent,
      title: Center(child: Text("Choose Your Choice",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),)),
      actions: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
                  onPressed: (){
                    Navigator.of(context).pop();
                    showDialog(context: context,
                      builder: (context) =>
                          updateAlertDialog(context,choicesnapshot.data![index].title,choicesnapshot.data![index].description,choicesnapshot.data![index].id),
                    );
                  },
                  child: bChild(bTitle: "Update",
                      icon: Icons.browser_updated),),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
                  onPressed: (){
                    setState(() {
                      dbHelper!.delete(choicesnapshot.data![index].id!);
                      notesList = dbHelper!.getNotesList();
                      Navigator.of(context).pop();
                    });
                  },
                  child: bChild(bTitle: "Delete",
                      icon: Icons.delete),),
              ],),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade700),
              onPressed: (){Navigator.of(context).pop();},
              child: bChild(bTitle: "Close", icon: Icons.exit_to_app),
            ),

          ],
        ),
      ],
    );
  }

  Widget RoundTextField({required TextEditingController controller,required int maxLine,required String hintText}){
    return TextField(
      controller: controller,
      style: TextStyle(color: Colors.white),
      // keyboardType: TextInputType.multiline,
      maxLines: maxLine,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.indigo,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70,fontSize: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          borderSide: BorderSide(width: 1),
        ),
      ),
    );
  }

  Widget bChild({required String bTitle,required IconData icon}){
    return Container(
      width: 75,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon,color: Colors.white70,size: 20,),
          Text(bTitle,style: TextStyle(color: Colors.white70,fontSize: 16),),
        ],
      ),
    );
  }

}
