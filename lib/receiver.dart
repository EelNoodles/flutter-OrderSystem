import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/bill.dart';

class receiver extends StatelessWidget {
  late List<Map> dessertMap;
  late List<Map> comboMap;
  Widget build(BuildContext context){
    dynamic obj  = ModalRoute.of(context)?.settings.arguments;
    dessertMap = obj["dessert"];
    comboMap = obj["combo"];
    return MaterialApp(
        routes: <String, WidgetBuilder>{'/bill': (_) => bill()},
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
                  Text('建立傳情清單', style: TextStyle(fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.grey.shade700!)),
                  Text('建立傳情清單', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                ],
              )
          ),
          body: receiverList(DessertMap: dessertMap, ComboMap: comboMap,),
        ));
  }
}

class receiverList extends StatefulWidget{
  final List<Map> DessertMap;
  final List<Map> ComboMap;
  const receiverList({Key? key, required this.DessertMap, required this.ComboMap}) : super(key:key);

  @override
  State<receiverList> createState() => _receiverListState();
}

class _receiverListState extends State<receiverList> {
  Map<String, String> receiverMap = {};
  List<Map> receiverList = [];
  final TextEditingController conGrade = new TextEditingController();
  final TextEditingController conName = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Form(
          key: _formKey,
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 20, left: 30, right: 30),
                    child: TextFormField(
                      controller: conGrade,
                      decoration: InputDecoration(filled: true,
                          prefixIcon: const Icon(Icons.school),
                          fillColor: const Color.fromARGB(255, 196, 212, 251),
                          labelText: '請輸入傳情人系級',
                          labelStyle: const TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0
                            ),
                          )),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "請輸入系級";
                        }
                        return null;
                      },
                    )
                ),
                Container(
                    margin: const EdgeInsets.only(bottom: 15, left: 30, right: 30),
                    child: TextFormField(
                      controller: conName,
                      decoration: InputDecoration(filled: true,
                          prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),
                          fillColor: const Color.fromARGB(255, 196, 212, 251),
                          labelText: '請輸入傳情人姓名',
                          labelStyle: const TextStyle(color: Colors.black),
                          floatingLabelBehavior: FloatingLabelBehavior.auto,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: const BorderSide(
                                color: Colors.white,
                                width: 2.0
                            ),
                          )),
                      style: const TextStyle(fontSize: 20, color: Colors.white),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "請輸入姓名";
                        }
                        return null;
                      },
                    )
                ),
              ],
            )
        ),
        Container(
            child: Container(
              height: 40,
              width: double.infinity,
              margin: EdgeInsets.only(left: 100, right: 100, bottom: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    receiverMap = {"Name": conName.text, "Grade": conGrade.text};
                    receiverList.add(receiverMap);
                    conGrade.clear();
                    conName.clear();
                    setState(() {});
                  }
                  print(receiverList);
                },
                child: Text("加入", style: TextStyle(fontSize: 16, color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  primary: Color.fromARGB(255, 196, 212, 251),
                ),
              ),
            )
        ),
        Expanded(
            child: ListView.builder(
                itemCount: receiverList.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  return ListTile(
                    title: Text("${receiverList[index]["Name"]} ／ ${receiverList[index]["Grade"]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                    leading: Icon(Icons.person),
                    trailing: InkWell(
                      onTap: (){
                        receiverList.removeAt(index);
                        setState(() {});
                      },
                      child: Icon(Icons.delete, color: Colors.red,),
                    ),
                  );
                }
            )
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
                  if(receiverList.isEmpty){
                    Fluttertoast.showToast(msg: "傳情人數至少1人！", toastLength: Toast.LENGTH_SHORT);
                  }else{
                    Navigator.of(context).pushNamed('/bill', arguments: {
                      "dessert": widget.DessertMap,
                      "combo": widget.ComboMap,
                      "receiver": receiverList
                    });
                  }
                },
                child: const Text("前往結帳",style: TextStyle(
                    fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold
                ),),
              ),
            )
        )
      ],
    );
  }
}