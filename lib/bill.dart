import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/lobby.dart';
import 'package:hello_world/receiver.dart';
class bill extends StatelessWidget {
  late List<Map> dessertMap;
  late List<Map> comboMap;
  late List<Map> receiverList;
  Widget build(BuildContext context){
    dynamic obj  = ModalRoute.of(context)?.settings.arguments;
    dessertMap = obj["dessert"];
    comboMap = obj["combo"];
    receiverList = obj["receiver"];
    List<Map> finalList = List<Map>.from(dessertMap)..addAll(comboMap);
    return MaterialApp(
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
                  Text('結帳頁面', style: TextStyle(fontWeight: FontWeight.bold,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 3
                        ..color = Colors.grey.shade700!)),
                  Text('結帳頁面', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),)
                ],
              )
          ),
          body: billArea(FinalMap: finalList, ReceiverList: receiverList,),
        ));
  }
}

class billArea extends StatefulWidget{
  final List<Map> FinalMap;
  final List<Map> ReceiverList;
  const billArea({Key? key, required this.FinalMap, required this.ReceiverList}) : super(key: key);

  @override
  State<billArea> createState() => _billAreaState();
}

class _billAreaState extends State<billArea> {
  final TextEditingController conGrade = new TextEditingController();
  final TextEditingController conName = new TextEditingController();
  final TextEditingController conMail = new TextEditingController();
  final TextEditingController _conCheck = new TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final db = FirebaseFirestore.instance;

  @override
  void dispose(){
    conMail.dispose();
    conName.dispose();
    conGrade.dispose();
    _conCheck.dispose();
    super.dispose();
  }

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

  Future<String> getPrice(List<Map> finalMap) async {
    int temp = 0;
    for (var element in finalMap) {
      Map data = {};
      await db.collection("MainDessert").doc(element["id"]).get().then((DocumentSnapshot doc){
        data = doc.data() as Map<String, dynamic>;
      }).onError((error, stackTrace) => null);
      if(data == null || data.isEmpty){
        await db.collection("Combo").doc(element["id"]).get().then((DocumentSnapshot doc){
          data = doc.data() as Map<String, dynamic>;
        }).onError((error, stackTrace) => null);
      }
      temp += int.parse(data["Price"].toString()) * int.parse(element["amount"]);
    }

    int total = temp*widget.ReceiverList.length;

    return total.toString();
  }

  Widget build(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              const Divider(
                color: Colors.grey,
                thickness: 3,
              ),
              Container(
                margin: const EdgeInsets.only(left: 20),
                child: const Text("訂購人資料", style: TextStyle(color: Colors.grey,backgroundColor: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(18),
          margin: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: const BorderRadius.all(Radius.circular(20))
          ),
          child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    constraints: const BoxConstraints(
                      maxHeight: 80,
                      maxWidth: 310
                    ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        controller: conGrade,
                        decoration: InputDecoration(filled: true,
                            prefixIcon: const Icon(Icons.school),
                            fillColor: const Color.fromARGB(255, 196, 212, 251),
                            labelText: '請輸入訂購人系級',
                            labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
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
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "請輸入系級";
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                      constraints: const BoxConstraints(
                          maxHeight: 80,
                          maxWidth: 310
                      ),
                      margin: const EdgeInsets.only(bottom: 15),
                      child: TextFormField(
                        controller: conName,
                        decoration: InputDecoration(filled: true,
                            prefixIcon: const Icon(Icons.drive_file_rename_outline_rounded),
                            fillColor: const Color.fromARGB(255, 196, 212, 251),
                            labelText: '請輸入訂購人姓名',
                            labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
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
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "請輸入姓名";
                          }
                          return null;
                        },
                      )
                  ),
                  Container(
                    constraints: const BoxConstraints(
                        maxHeight: 80,
                        maxWidth: 310
                    ),
                    child: TextFormField(
                      controller: conMail,
                      decoration: InputDecoration(filled: true,
                          prefixIcon: const Icon(Icons.mail),
                          fillColor: const Color.fromARGB(255, 196, 212, 251),
                          labelText: '請輸入訂購人電子郵件',
                          labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
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
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "請輸入電子信箱";
                        }else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                          return "非電子信箱格式";
                        }
                        return null;
                      },
                    ),
                  )
                ],
              )
          ),
        ),
        Stack(
          children: [
            const Divider(
              color: Colors.grey,
              thickness: 3,
            ),
            Container(
              margin: const EdgeInsets.only(left: 20),
              child: const Text("訂購商品資料", style: TextStyle(color: Colors.grey,backgroundColor: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
        Expanded(
            child: ListView.builder(
                itemCount: widget.FinalMap.length,
                itemBuilder: (BuildContext ctxt, int index) {
                  Map value = widget.FinalMap[index];
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
                })
        ),
        Container(
          margin: const EdgeInsets.only(right: 20, bottom: 10),
          alignment: AlignmentDirectional.centerEnd,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(shape: const StadiumBorder(), backgroundColor: const Color.fromARGB(
                255, 112, 127, 235),),
            child: const Text("查看傳情名單"),
            onPressed: (){
              showReceiverList(context);
            },
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
                onPressed: () {
                  if(_formKey.currentState!.validate()){
                    showDialog(
                        context: context,
                        builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        title: const Text("清輸入收款人學號"),
                        content: TextField(
                          controller: _conCheck,
                          decoration: const InputDecoration(
                            hintText: "請輸入收款人學號",
                            prefixText: "S",
                            suffixIcon: Icon(Icons.verified_user)
                          ),
                          keyboardType: TextInputType.number,
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                              onPressed: (){
                                if(_conCheck.text.length == 8){
                                  Navigator.pop(context, "S" + _conCheck.text);
                                  loadingDialog(context);
                                }else{
                                  Fluttertoast.showToast(msg: "學號錯誤！", toastLength: Toast.LENGTH_SHORT);
                                }
                              },
                              child: const Text("收款"))
                        ],
                      );
                    }).then((value){
                      if(value != null){
                        Map<String, dynamic> info = {"Grade": conGrade.text, "Name": conName.text, "Mail": conMail.text};
                        final data = <String, dynamic>{
                          "customer": info,
                          "receiver": widget.ReceiverList,
                          "purchaseList": widget.FinalMap,
                          "time": DateTime.now().millisecondsSinceEpoch.toString(),
                        };
                        db.collection("Orders").doc().set(data).then((value) {
                          Fluttertoast.showToast(msg: "成功訂購！", toastLength: Toast.LENGTH_SHORT);
                        }).whenComplete((){
                          Navigator.of(context, rootNavigator: true).pop();
                          finalCheckDialog(context, info);
                        });
                      }
                    });
                  }
                },
                child: FutureBuilder(
                  future: getPrice(widget.FinalMap),
                  builder: (context, snapshot){
                    return snapshot.connectionState != ConnectionState.done ? const Text("Loading...") : Text("結帳（NTD. ${snapshot.data.toString()} 元）",style: const TextStyle(
                        fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold
                    ),);
                  },
                )
              ),
            )
        )
      ],
    );
  }

  void showReceiverList(BuildContext context) {
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
            const Text("傳情名單", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
            Expanded(
              child: ListView.builder(
                itemCount: widget.ReceiverList.length,
                itemBuilder: (BuildContext ctxt, int index){
                  return ListTile(
                    title: Text("${widget.ReceiverList[index]["Name"]} ／ ${widget.ReceiverList[index]["Grade"]}"),
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

  void finalCheckDialog(BuildContext context, Map data){
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15)),
            ),
            backgroundColor: Colors.white,
            content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text("訂購完成", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("感謝 ${data["Name"]} 的訂購！", style: TextStyle(color: Colors.redAccent,fontSize: 15),),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("請記得向櫃台人員索取明細表，感謝。", style: TextStyle(color: Colors.black,fontSize: 15),),
                  )
                ],
              ),
            actions: <Widget>[
              ElevatedButton(
                  onPressed: (){
                    Navigator.of(context, rootNavigator: true).pop();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Lobby()));
                  },
                  child: Text("確認"))
            ],
          );
        });
  }
}
