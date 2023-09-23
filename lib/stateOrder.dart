import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/combo.dart';

class StateOrder extends StatelessWidget {
  Widget build(BuildContext context){
    return MaterialApp(
        routes: <String, WidgetBuilder>{'/combo': (_) => combo()},
        theme: ThemeData(fontFamily: 'TaipeiSansTCBeta'),
        home: Scaffold(
          appBar: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: ()=>Navigator.of(context).pop(),
              ),
              flexibleSpace: Image(
                image: AssetImage('assets/images/post.PNG'),
                fit: BoxFit.cover,
              ),
              title: Stack(
                children: [
                  Text('訂單統計', style: TextStyle(fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.grey.shade700!)),
                  Text('訂單統計', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                ],
              )
          ),
          body: StateArea(),
        ));
  }
}

class StateArea extends StatefulWidget{
  @override
  State<StateArea> createState() => _StateAreaState();
}

class _StateAreaState extends State<StateArea> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map> getProductData(String id) async {
    Map result = {};
    Map data = {};
    await db.collection("MainDessert").doc(id).get().then((DocumentSnapshot doc){
      data = doc.data() as Map<String, dynamic>;
      result["type"] = "Dessert";
      result["data"] = data;
    }).onError((error, stackTrace) => null);
    if(result["data"] == null){
      await db.collection("Combo").doc(id).get().then((DocumentSnapshot doc){
        data = doc.data() as Map<String, dynamic>;
        result["type"] = "Combo";
        result["data"] = data;
      }).onError((error, stackTrace) => null);
    }
    return result;
  }
  
  Widget build(BuildContext context){
    return StreamBuilder<QuerySnapshot>(
      stream: db.collection("Orders").orderBy("time", descending: true).snapshots(),
      builder: (context, snapshots){
        if(snapshots.hasData){
          return ListView.builder(
              itemCount: snapshots.data!.docs.length,
              itemBuilder: (BuildContext ctxt, int index) {
                DocumentSnapshot e = snapshots.data!.docs[index];
                int timestamp = int.parse(e["time"]);
                String date = DateTime.fromMillisecondsSinceEpoch(timestamp).toString();
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)
                  ),
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: EdgeInsets.all(15),
                          constraints: const BoxConstraints(
                            minHeight: 140,
                            minWidth: 80
                          ),
                          decoration: const BoxDecoration(
                            color: Color.fromRGBO(112, 127, 238, 1.0),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(date.substring(0, 4), style: TextStyle(fontSize: 18, color: Colors.white),),
                              Text(date.substring(5, 10), style: TextStyle(fontSize: 18, color: Colors.white),),
                              Text(date.substring(10, 16), style: TextStyle(fontSize: 28, color: Colors.amberAccent, fontWeight: FontWeight.bold),)
                            ],
                          )
                        ),
                        Container(
                            padding: EdgeInsets.all(15),
                            constraints: const BoxConstraints(
                                minHeight: 140,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text("${e["customer"]["Grade"].toString()} ", style: TextStyle(fontSize: 18),),
                                    Container(
                                      width: 100,
                                      child: Text("（${e["customer"]["Mail"].toString()}）", overflow: TextOverflow.fade, softWrap: false,style: TextStyle(fontSize: 12),),
                                    )
                                  ],),
                                Text("${e["customer"]["Name"].toString()} ", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                                Container(
                                  constraints: const BoxConstraints(
                                    maxHeight: 30
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: Colors.grey),
                                    child: const Text("查看傳情名單"),
                                    onPressed: (){
                                      showReceiverList(context, e["receiver"], e["customer"]["Name"].toString());
                                    },
                                  ),
                                ),
                              ],
                            )
                        ),
                        Container(
                            constraints: const BoxConstraints(
                              minHeight: 140,
                              maxWidth: 60
                            ),
                            decoration:const BoxDecoration(
                              color: Color.fromARGB(255, 207, 210, 253),
                              borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: (){
                                      showBuyingList(ctxt, e["purchaseList"], e["customer"]["Name"].toString());
                                    },
                                    icon: Icon(Icons.view_list, color: Colors.blue,)
                                ),
                                // IconButton(
                                //     onPressed: (){
                                //       loadingDialog(context);
                                //       db.collection("Orders").doc(e.id).delete().whenComplete((){
                                //         Fluttertoast.showToast(msg: "成功刪除！", toastLength: Toast.LENGTH_SHORT);
                                //         Navigator.of(context, rootNavigator: true).pop();
                                //       });
                                //     },
                                //     icon: Icon(Icons.delete, color: Colors.redAccent,)
                                // )
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                );
              });
        }else{
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  void showReceiverList(BuildContext context, List ReceiverList, String Name) {
    AlertDialog dialog = AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: SizedBox(
            width: 200,
            height: 300,
            child: Column(
              children: [
                Text("${Name}的傳情名單", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Expanded(
                  child: ListView.builder(
                      itemCount: ReceiverList.length,
                      itemBuilder: (BuildContext ctxt, int index){
                        return ListTile(
                          title: Text("${ReceiverList[index]["Name"]} ／ ${ReceiverList[index]["Grade"]}"),
                        );
                      }),
                )
              ],
            )
        )
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

  void loadingDialog(BuildContext context){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return const Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
  }

  void showBuyingList(BuildContext context, List FinalMap, String Name) {
    AlertDialog dialog = AlertDialog(
        backgroundColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        content: SizedBox(
            width: 200,
            height: 300,
            child: Column(
              children: [
                Text("${Name}的購買名單", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                Expanded(
                  child: ListView.builder(
                      itemCount: FinalMap.length,
                      itemBuilder: (BuildContext ctxt, int index) {
                        Map value = FinalMap[index];
                        return FutureBuilder(
                            future: getProductData(value["id"]),
                            builder: (context, snapshot){
                              return snapshot.connectionState != ConnectionState.done
                                  ? const Center(child: Text("Loading..."),) :
                              ListTile(
                                leading: Icon(snapshot.data!["type"] == "Dessert"? Icons.numbers : null),
                                title: Text(snapshot.data!["type"] == "Dessert"? snapshot.data!["data"]["dessertName"] :
                                "     ${snapshot.data?["data"]["drinkName"]}", style: TextStyle(
                                    fontSize: snapshot.data!["type"] == "Dessert"? 16:14,
                                    color: snapshot.data!["type"] == "Dessert"? Colors.black:Colors.grey.shade800
                                ),),
                                trailing: Text("x ${value["amount"]}"),
                              );
                            });
                      }),
                )
              ],
            )
        )
    );

    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) => dialog,
    );
  }

}