import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hello_world/lobby.dart';
import 'package:hello_world/stateOrder.dart';
import 'register.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context){
    return MaterialApp(
        theme: ThemeData(fontFamily: 'TaipeiSansTCBeta'),
        home: Scaffold(
          appBar: AppBar(
            title: Text('測試登入註冊功能'),
            centerTitle: true,
          ),
          body: BodyArea(),
        ));
  }
}

class BodyArea extends StatelessWidget{
  Widget build(BuildContext context){
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.only(top: 60),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                onSurface: Colors.transparent,
                shadowColor: Colors.transparent,
              ),
              child: Row(mainAxisAlignment:MainAxisAlignment.center,children: [Image.asset("assets/images/cry.png"),],),
              onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => StateOrder()));},
            )
        ),
        LoginArea(),
      ],
    );
  }
}

class LoginArea extends StatefulWidget{
  @override
  State<LoginArea> createState() => _LoginAreaState();
}

class _LoginAreaState extends State<LoginArea> {
  final loginAccount = TextEditingController();
  final loginPassword = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    loginAccount.dispose();
    loginPassword.dispose();
    super.dispose();
  }

  Widget build(BuildContext context){
    return Form(
      key: _formKey,
        child: Container(
          alignment: AlignmentDirectional.bottomEnd,
          child: Container(
              alignment: AlignmentDirectional.center,
              constraints: BoxConstraints(maxHeight: 330),
              margin: EdgeInsets.only(top: 0),
              decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(80.0), topRight: Radius.circular(80.0)
                  )
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 320),
                          margin: EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            controller: loginAccount,
                            decoration: InputDecoration(filled: true,
                                prefixIcon: Icon(Icons.account_circle),
                                fillColor: Colors.blue.shade200,
                                labelText: '電子信箱',
                                labelStyle: TextStyle(color: Colors.black),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 2.0
                                  ),
                                )),
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "請輸入電子信箱";
                              }else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                                return "非電子信箱格式";
                              }
                              return null;
                            },
                          )
                      )
                  ),
                  Container(
                      child: Container(
                          constraints: BoxConstraints(maxWidth: 320),
                          margin: EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            controller: loginPassword,
                            decoration: InputDecoration(filled: true,
                                prefixIcon: Icon(Icons.password),
                                fillColor: Colors.blue.shade200,
                                labelText: '密碼',
                                labelStyle: TextStyle(color: Colors.black),
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide.none,
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: BorderSide(
                                      color: Colors.white,
                                      width: 2.0
                                  ),
                                )),
                            obscureText: true,
                            style: TextStyle(fontSize: 20, color: Colors.white),
                            validator: (value){
                              if(value == null || value.isEmpty){
                                return "請輸入密碼";
                              }
                              return null;
                            },
                          )
                      )
                  ),
                  Container(
                      child: Container(
                        height: 40,
                        width: double.infinity,
                        margin: EdgeInsets.only(left: 100, right: 100),
                        child: ElevatedButton(
                          onPressed: () async {
                            if(_formKey.currentState!.validate()){
                              _login();
                            }else{
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Lobby()));
                            }
                          },
                          child: Text("登入", style: TextStyle(fontSize: 16, color: Colors.black),),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue.shade200,
                          ),
                        ),
                      )
                  ),
                  Container(
                    child: RegisterButton(),
                  )
                ],
              )
          ),
        ));
  }
  void _login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: loginAccount.text,
          password: loginPassword.text
      );
      if(await _haveUserData()){
        Fluttertoast.showToast(msg: "成功登入！", toastLength: Toast.LENGTH_SHORT);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Lobby()));
      }else{
        _createUserData();
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "該電子信箱尚未註冊！", toastLength: Toast.LENGTH_SHORT);
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "密碼錯誤！", toastLength: Toast.LENGTH_SHORT);
      }
    }
  }

  Future<bool> _haveUserData() async {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    bool exist = false;
    final docRef = db.collection("Users").doc(uid);
    await docRef.get().then(
          (DocumentSnapshot doc) {
        final data = doc.data() as Map<String, dynamic>;
        if(data != null){
          exist = true;
        }
      },
      onError: (e) => print("Error getting document: $e"),
    );
    return exist;
  }

  void _createUserData() async {

  }
}

class RegisterButton extends StatelessWidget{
  Widget build(BuildContext context){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        TextButton(onPressed: (){
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));
        },
          child: Text("註冊帳號",
          style: TextStyle(fontSize: 15, color: Colors.black),
          )
        ),
        TextButton(onPressed: ()=>print("d"),
            child: Text("忘記密碼",
              style: TextStyle(fontSize: 15, color: Colors.black),
            )
        )
      ],
    );
  }
}

