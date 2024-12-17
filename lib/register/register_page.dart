import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../common.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<StatefulWidget> createState() {
    return RegisterState();
  }
}

class RegisterState extends State<Register> {
  TextEditingController edtEmail = TextEditingController();
  TextEditingController edtPassword = TextEditingController();
  final DatabaseReference dbRef = FirebaseDatabase.instance.ref();

  void writeData(String email, String password) {
    dbRef.child("users").push().set({
      "email": email,
      "password": password,
    }).then((_) {
      Common.showAlertDialog(context, "Thông báo", "Đăng ký thành công");
    }).catchError((error) {
      Common.showAlertDialog(context, "Thông báo", "Đăng ký thất bại");
    });
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
                            "Đăng ký tài khoản",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          const SizedBox(
                            height: 10,
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
                            height: 15,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                                onPressed: () {
                                  register();
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange),
                                child: const Text(
                                  'Đăng ký',
                                  style: TextStyle(
                                      fontSize: 25, color: Colors.white),
                                )),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange)),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Trở lại",
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

  void register() {
    String email = edtEmail.text;
    String password = edtPassword.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      if (email.contains("@")) {
        writeData(email, password);
      } else {
        Common.showAlertDialog(context, "Thông báo", "Email không hợp lệ");
      }
    } else {
      Common.showAlertDialog(
          context, "Thông báo", "Các thông tin không được bỏ trống");
    }
  }
}
