import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/receiver.dart';

class combo extends StatelessWidget {
  late List<Map> getMap;
  Widget build(BuildContext context){
    dynamic obj  = ModalRoute.of(context)?.settings.arguments;
    getMap = obj;
    return MaterialApp(
        routes: <String, WidgetBuilder>{'/receiver': (_) => receiver()},
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
                  Text('選擇加購套餐數量', style: TextStyle(fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.grey.shade700!)),
                  Text('選擇加購套餐數量', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                ],
              )
          ),
          body: ComboProduct(DessertMap: getMap,),
        ));
  }
}

class ComboProduct extends StatefulWidget{
  final List<Map> DessertMap;
  const ComboProduct({Key? key, required this.DessertMap}) : super(key: key);

  @override
  State<ComboProduct> createState() => _ComboProductState();
}

class _ComboProductState extends State<ComboProduct> {
  final db = FirebaseFirestore.instance;

  Widget build(BuildContext context){
    return Stack(
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 65),
          child: StreamBuilder<QuerySnapshot>(
              stream: db.collection("Combo").snapshots(),
              builder: (context, snapshots){
                if(snapshots.hasData){
                  return ListView.builder(
                      itemCount: snapshots.data!.docs.length,
                      itemBuilder: (context, index){
                        DocumentSnapshot e = snapshots.data!.docs[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)
                          ),
                          margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade400,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15), // Image border
                                    child: Container(
                                      constraints: const BoxConstraints(
                                          maxHeight: 170,
                                          minWidth: double.infinity
                                      ),
                                      child: Image.network(e.get("drinkImage"), fit: BoxFit.cover),
                                    )
                                ),
                                Container(
                                  margin: const EdgeInsets.only(top: 120),
                                  constraints: const BoxConstraints(
                                    maxHeight: 70,
                                  ),
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(20),
                                        bottomLeft: Radius.circular(20)
                                    ),
                                    color: Color(0xFF4D455D),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 25, left: 20),
                                        alignment: AlignmentDirectional.topCenter,
                                        child: Text(e.get("drinkDescribe"), style:
                                        const TextStyle(fontSize: 16, color: Colors.white,),
                                        ),
                                      ),
                                      Container(
                                          alignment: AlignmentDirectional.center,
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(15),
                                                bottomRight: Radius.circular(15),
                                                topLeft: Radius.circular(15)
                                            ),
                                            color: Color(0xFF7DB9B6),
                                          ),
                                          constraints: const BoxConstraints(
                                              minHeight: 80,
                                              minWidth: 120
                                          ),
                                          child: _counterItem(count: repo.getCount(context, index),
                                              increment: (){
                                                repo.incrementCounter(context, index);
                                              },
                                              decrement: (){
                                                repo.decrementCounter(context, index);
                                              })
                                      )
                                    ],),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(top: 90),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE96479),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                                  ),
                                  child: Text(e.get("drinkName"), style:
                                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  margin: const EdgeInsets.only(top: 60),
                                  decoration: const BoxDecoration(
                                      color: Color(0xFFE96479),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(20), bottomRight: Radius.circular(20))
                                  ),
                                  child: Text("\$15", style:
                                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                                ),
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
              }
          ),
        ),
        Container(
            alignment: AlignmentDirectional.center,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color.fromRGBO(112, 127, 238, 1.0), Color.fromARGB(
                  255, 226, 227, 253)]),
            ),
            constraints: const BoxConstraints(
                maxHeight: 65
            ),
            child: SizedBox(
              width: double.infinity,
              height: 65,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  onSurface: Colors.transparent,
                  shadowColor: Colors.transparent,
                ),
                onPressed: () async {
                  int dessertTotal = 0;
                  int comboTotal = 0;
                  List<Map> amountList = [];
                  widget.DessertMap.forEach((element) {
                    dessertTotal += int.parse(element["amount"].toString());
                  });
                  final QuerySnapshot qSnap = await db.collection('Combo').get();
                  final int documents = qSnap.docs.length;
                  for(int i=0; i<documents; i++){
                    comboTotal += repo.getCount(context, i).toInt();
                  }
                  if(comboTotal > dessertTotal){
                    Fluttertoast.showToast(msg: "數量大於訂購數量！", toastLength: Toast.LENGTH_SHORT);
                  }else{
                    int index = 0;
                    await db.collection("Combo").get().then((querySnapshot) {
                      for (var docSnapshot in querySnapshot.docs) {
                        Map<String, String> _comboMap = {};
                        if(repo.getCount(context, index) != 0){
                          _comboMap["id"] = docSnapshot.id.toString();
                          _comboMap["amount"] = repo.getCount(context, index).toString();
                          amountList.add(_comboMap);
                        }
                        index ++;
                      }
                    });
                    Navigator.of(context).pushNamed('/receiver', arguments: {"dessert": widget.DessertMap, "combo": amountList});
                  }
                },
                child: const Text("確認餐點",style: TextStyle(
                    fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold
                ),),
              ),
            )
        )
      ],
    );
  }
}

class _counterItem extends StatefulWidget{
  final int count;
  final VoidCallback increment;
  final VoidCallback decrement;
  const _counterItem({Key? key, required this.count,
    required this.decrement,
    required this.increment}) : super(key: key);
  @override
  State<_counterItem> createState() => _counterItemState();
}

class _counterItemState extends State<_counterItem> {
  Widget build(BuildContext context){
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        textDirection: TextDirection.rtl,
        children: [
          _buildCounterBuilder(Icons.remove_circle_outline_rounded, widget.decrement, widget.count > 0),
          Text(widget.count.toString(), style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
          _buildCounterBuilder(Icons.add_circle_outline_rounded,widget.increment)
        ]);
  }

  InkWell _buildCounterBuilder(IconData iconData, VoidCallback voidCallback, [bool active=true]){
    return InkWell(
      onTap: !active ? null : voidCallback,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: Icon(iconData, color: Colors.white,),
      ),
    );
  }
}

CounterRepo repo = CounterRepo();
class CounterRepo{
  int getCount(context, index){
    return SharedAppData.getValue(context, "count-$index", () => 0);
  }
  incrementCounter(context, index){
    var count = getCount(context, index);
    SharedAppData.setValue(context, "count-$index", count +1);
  }
  decrementCounter(context, index){
    var count = getCount(context, index);
    SharedAppData.setValue(context, "count-$index", count -1);
  }
}