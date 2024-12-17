import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common.dart';
import '../register/register_page.dart';
import '../translate/translate_page.dart';

void main() {
  runApp(Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<StatefulWidget> createState() {
    return LoginState();
  }
}

class LoginState extends State<Login> {
  TextEditingController edtEmail = TextEditingController();
  TextEditingController edtPassword = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  void setEmailPassword(String email, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    prefs.setString("password", password);
  }

  void getEmailPassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    edtEmail.text = prefs.getString("email")!;
    edtPassword.text = prefs.getString("password")!;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getEmailPassword();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: null,
      ),
      body: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "PHẦN MỀM DỊCH TIẾNG DÂN TỘC",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.orange),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Column(
                        children: [
                          const Text(
                            "Đăng nhập",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextField(
                            controller: edtEmail,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: 'Email',
                                hintStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          TextField(
                            obscureText: true,
                            controller: edtPassword,
                            style: const TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                fillColor: Colors.grey.shade100,
                                filled: true,
                                hintText: "Mật khẩu",
                                hintStyle: const TextStyle(fontSize: 18),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                                onPressed: () {
                                  login();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                child: const Text(
                                  'Đăng nhập',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                )),
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange)),
                              onPressed: () {
                                navToRegister();
                              },
                              child: const Text(
                                "Đăng ký tài khoản",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.white),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }


  void navToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Register()),
    );
  }

  Future<void> login() async {
    String email = edtEmail.text.trim(); // Loại bỏ khoảng trắng
    String password = edtPassword.text.trim();

    // Kiểm tra trường nhập
    if (email.isEmpty || password.isEmpty) {
      Common.showAlertDialog(
          context, "Thông báo", "Vui lòng nhập đầy đủ email và mật khẩu.");
      return;
    }

    try {
      final snapshot = await dbRef.child("users").get();

      // Biến để xác định email và password có hợp lệ hay không
      bool isValidUser = false;

      for (DataSnapshot dataSnapshot in snapshot.children) {
        String dbEmail = dataSnapshot.child("email").value.toString();
        String dbPassword = dataSnapshot.child("password").value.toString();

        if (dbEmail == email && dbPassword == password) {
          isValidUser = true;
          // Điều hướng sang trang mới nếu hợp lệ
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Translate()),
          );
          break; // Thoát vòng lặp
        }
      }

      // Nếu không tìm thấy email và mật khẩu hợp lệ
      if (!isValidUser) {
        Common.showAlertDialog(
            context, "Thông báo", "Email hoặc mật khẩu không đúng.");
      }
    } catch (e) {
      print("Lỗi kiểm tra dữ liệu: $e");
      Common.showAlertDialog(
          context, "Lỗi", "Có lỗi xảy ra khi kiểm tra dữ liệu.");
    }
  }
}
