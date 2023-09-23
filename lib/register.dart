import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class Register extends StatefulWidget {
  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> with SingleTickerProviderStateMixin {
  late TabController _controller;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: choices.length, vsync: this);
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData(fontFamily: 'TaipeiSansTCBeta'),
        home: DefaultTabController(
          length: choices.length,
          child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                color: Colors.white,
                onPressed: ()=>Navigator.of(context).pop(),
              ),
              title: Text("註冊使用者帳號"),
              titleTextStyle: TextStyle(fontSize: 20),
              centerTitle: true,
              bottom: TabBar(
                controller: _controller,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: Colors.white,
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.grey,
                tabs: choices.map((Choice choice){
                  return Tab(
                    text: choice.title,
                    icon: Icon(choice.icon),
                  );
                }).toList(),
              ),
            ),
            body: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                constraints: const BoxConstraints(maxWidth: 360, maxHeight: 400),
                decoration: const BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: TabBarView(
                  controller: _controller,
                  children: [
                    TextArea(_controller, _selectedIndex),
                    InfoArea(_controller, _selectedIndex),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class Choice{
  const Choice({required this.title, required this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = <Choice>[
  Choice(title: '帳號與密碼', icon: Icons.mail),
  Choice(title: '使用者資料', icon: Icons.info_outline),
  Choice(title: '註冊完成', icon: Icons.check),
];

class TextArea extends StatefulWidget{
  final TabController controller;
  int selectedIndex;
  TextArea(this.controller, this.selectedIndex);
  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  final Con_myAccount = TextEditingController();
  final Con_myPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    Con_myAccount.dispose();
    Con_myPassword.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: Con_myAccount,
                  decoration: InputDecoration(filled: true,
                      prefixIcon: const Icon(Icons.mail),
                      fillColor: Colors.blue.shade200,
                      labelText: '請輸入電子信箱',
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
                      return "請輸入電子信箱";
                    }else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                      return "非電子信箱格式";
                    }
                    return null;
                  },
                )
            ),
            Container(
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: Con_myPassword,
                  decoration: InputDecoration(filled: true,
                      prefixIcon: const Icon(Icons.password),
                      fillColor: Colors.blue.shade200,
                      labelText: '請輸入密碼',
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
                  obscureText: true,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "請輸入密碼";
                    }
                    return null;
                  },
                )
            ),
            Container(
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  decoration: InputDecoration(filled: true,
                      prefixIcon: const Icon(Icons.password),
                      fillColor: Colors.blue.shade200,
                      labelText: '請再次輸入密碼',
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
                  obscureText: true,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  validator: (value){
                    if(value == null || value.isEmpty) {
                      return "請再次輸入密碼";
                    }else if(value != Con_myPassword.text){
                      return "與上方密碼不相同";
                    }
                    return null;
                  },
                )
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 70, right: 70),
              child: ElevatedButton(
                onPressed: () async {
                  if(_formKey.currentState!.validate()){
                    _register();
                  }
                },
                child: const Text("下一步", style: TextStyle(fontSize: 16, color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade200,
                ),
              ),
            )
          ],
        )
    );
  }
  void _register() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: Con_myAccount.text,
        password: Con_myPassword.text,
      );
      Fluttertoast.showToast(msg: "註冊成功！", toastLength: Toast.LENGTH_SHORT);
      widget.controller.animateTo(widget.selectedIndex += 1);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "密碼保護度不足！", toastLength: Toast.LENGTH_SHORT);
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "該電子信箱已經註冊！", toastLength: Toast.LENGTH_SHORT);
      }
    } catch (e) {
      print(e);
    }
  }
}

class InfoArea extends StatefulWidget{
  final TabController controller;
  int selectedIndex;
  InfoArea(this.controller, this.selectedIndex);
  @override
  State<InfoArea> createState() => _InfoAreaState();
}

class _InfoAreaState extends State<InfoArea> {
  final Con_myName = TextEditingController();
  final Con_myStuId = TextEditingController();
  final GlobalKey<FormState> _formInfoKey = GlobalKey<FormState>();

  @override
  void dispose() {
    Con_myName.dispose();
    Con_myStuId.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return Form(
        key: _formInfoKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: Con_myName,
                  decoration: InputDecoration(filled: true,
                      prefixIcon: const Icon(Icons.mail),
                      fillColor: Colors.blue.shade200,
                      labelText: '請輸入使用者名稱',
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
                      return "請輸入使用者名稱";
                    }
                    return null;
                  },
                )
            ),
            Container(
                constraints: const BoxConstraints(maxWidth: 320),
                margin: const EdgeInsets.only(bottom: 15),
                child: TextFormField(
                  controller: Con_myStuId,
                  decoration: InputDecoration(filled: true,
                      prefixIcon: const Icon(Icons.password),
                      fillColor: Colors.blue.shade200,
                      labelText: '請輸入學號',
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
                  obscureText: true,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  validator: (value){
                    if(value == null || value.isEmpty){
                      return "請輸入學號";
                    }
                    return null;
                  },
                )
            ),
            Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 70, right: 70),
              child: ElevatedButton(
                onPressed: () async {
                  if(_formInfoKey.currentState!.validate()){
                    _putUserData();
                  }
                },
                child: const Text("下一步", style: TextStyle(fontSize: 16, color: Colors.black),),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue.shade200,
                ),
              ),
            )
          ],
        )
    );
  }
  void _putUserData() async{
    FirebaseFirestore db = FirebaseFirestore.instance;
    FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        final data = <String, dynamic>{
          "userName": Con_myName.text,
          "StuId": Con_myStuId.text,
        };
        db.collection("Users").doc(uid).set(data).then((value) {
          Fluttertoast.showToast(msg: "成功更新使用者資料！", toastLength: Toast.LENGTH_SHORT);
          widget.controller.animateTo(widget.selectedIndex += 1);
        });
      }
    });


  }
}