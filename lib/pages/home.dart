import 'dart:io';
import 'package:band_names/services/socket-service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:band_names/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

}
class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Chayane', votes: 0),
    Band(id: '2', name: 'luis Fonsi', votes: 0),
    Band(id: '3', name: 'Axel', votes: 0),
    Band(id: '4', name: 'Sin Bandera', votes: 0),
  ];

  @override
  void initState() {

    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', _handleActiveBand);
    super.initState();
  }

  _handleActiveBand( dynamic payload){
    this.bands = (payload as List)
      .map((band) => Band.fromMap(band))
      .toList();

    setState(() {});
  }
  
  @override
  void dispose() {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    final socketService = Provider.of<SocketService>(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Listado de Bandas", style: TextStyle(color: Colors.black87),),
        backgroundColor: Colors.white,
        elevation: 1,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: (socketService.serverStatus == ServerStatus.Online)
            ? Icon(Icons.check_circle,color: Colors.green[800])
            : Icon(Icons.dangerous, color: Colors.red)
          )
        ],
      ),
      body: Column(
        children: [
          
          _showGraph(),

          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (BuildContext context, int index) => _bandTile(bands[index])        
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        elevation: 1,
        onPressed: addNewBand,
      ),
    );
  }

  Widget _bandTile(Band band) {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( _ ) => socketServices.emit('delete-band',{'id':band.id}),
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
            onTap: () => socketServices.socket.emit('vote-band', {'id': band.id}),
          ),
    );
  }
  final textController = new TextEditingController();
  addNewBand(){
    if (Platform.isAndroid){
        showDialog(
        context: context,
        builder: (_) => AlertDialog(
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
          ),
      );
    }else{
      showCupertinoDialog(
        context: context, 
        builder: (_) => CupertinoAlertDialog(
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
          ),
      );
    } 
  }

  void addBandToList(String name) {

    if (name.length > 1){
      
      final socketService = Provider.of<SocketService>(context,listen: false);
      socketService.socket.emit('add-band', {'name': name});
      // this.bans.add(new Band(id: DateTime.now().toString(), name: name, votes: 0));
      // setState(() {});
    }
    

    Navigator.pop(context);

  }

  Widget _showGraph() {

    Map<String, double> dataMap = new Map();

    bands.forEach((band) { 
      dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
    });

    // Map<String, double> dataMap = {
    //   "Flutter": 5,
    //   "React": 3,
    //   "Xamarin": 2,
    //   "Ionic": 2,
    // };

    return Container(
      padding: EdgeInsets.only(top: 20),
      width: double.infinity,
      height: 200,
      child: PieChart(
        dataMap: dataMap,
        animationDuration: Duration(milliseconds: 800),
        
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2.2,
        showChartValuesInPercentage: true,
        showChartValues: true,
        showChartValuesOutside: false,
        showLegends: true,
        decimalPlaces: 0,
        chartType: ChartType.ring,
        legendPosition: LegendPosition.right,
        
        
        
        
        
        ),
    );

  }
}