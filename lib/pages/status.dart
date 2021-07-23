import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:band_names/services/socket-service.dart';

class StatusPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Service status: ${socketService.serverStatus}")
          ],
        )
     ),
     floatingActionButton: FloatingActionButton(
       child: Icon(Icons.plus_one_sharp),
       onPressed: (){

         socketService.emit("emitir-mensaje", { 
           "nombre": "Flutter" , 
           "mensaje": "mensaje desde flutter"});
         
       },
     ),
   );
  }
}