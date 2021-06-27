import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bans = [
    Band(id: '1', name: 'Chayane', votes: 20),
    Band(id: '2', name: 'luis Fonsi', votes: 30),
    Band(id: '3', name: 'Axel', votes: 25),
    Band(id: '4', name: 'Sin Bandera', votes: 50),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Bandas", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      body: ListView.builder(
        itemCount: bans.length,
        itemBuilder: (BuildContext context, int index) => _bandTile(bans[index])        
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: EdgeInsets.only(left: 20.0),
        color: Colors.red,
        child: Align(
          alignment:Alignment.centerLeft,
          child: Icon(Icons.restore_from_trash_sharp, color: Colors.white,)
          //Text("Eliminando Band",style: TextStyle(color: Colors.white),),
        ),
      ),
      child: ListTile(
            leading: CircleAvatar(
              child: Text(band.name.substring(0,2)),
              backgroundColor: Colors.blue[100],
            ),
            title: Text(band.name),
            trailing: Text(band.votes.toString(), style: TextStyle(fontSize: 18.0),),
            onTap: (){
              print('seleccion: ${band.name}');
            },
          ),
    );
  }
  final textController = new TextEditingController();
  addNewBand(){
    if (Platform.isAndroid){
        showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: Text("add new band"),
            content: TextField(
              controller: textController,
            ),
            actions: [
              MaterialButton(
                
                child: Text("add"),
                elevation: 5,
                onPressed: ()  => addBandToList(textController.text)
              )
            ],
          );
        }
      );
    }else{
      showCupertinoDialog(
        context: context, 
        builder: (context){
          return CupertinoAlertDialog(
            title: Text("add new band"),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text("add"),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: Text("dismiss"),
                onPressed: () => Navigator.pop(context),
              )

            ],
          );
        }
      );
    }

    
  }

  addBandToList(String name) {

    if (name.length > 1){
      this.bans.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    

    Navigator.pop(context);

  }
}