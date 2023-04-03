import 'dart:io';
import 'package:chat_app/Utilities/Reusable%20Components/message_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatelessWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  final bool isLogin;

  ChatScreen(
      {required this.isLogin, required this.chatRoomId, required this.userMap});

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FocusNode messageFocus = FocusNode();

  File? imageFile;

  Future getImage() async {
    ImagePicker _picker = ImagePicker();

    await _picker.pickImage(source: ImageSource.gallery).then((xFile) {
      if (xFile != null) {
        imageFile = File(xFile.path);
        uploadImage();
      }
    });
  }

  Future uploadImage() async {
    String fileName = const Uuid().v1();
    int status = 1;

    await _firestore
        .collection('chatroom')
        .doc(chatRoomId)
        .collection('chats')
        .doc(fileName)
        .set({
      "sendby": _auth.currentUser!.displayName,
      "message": "",
      "type": "img",
      "time": DateTime.now().microsecondsSinceEpoch,
    });

    var ref =
        FirebaseStorage.instance.ref().child('images').child("$fileName.jpg");

    var uploadTask = await ref.putFile(imageFile!).catchError((error) async {
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .delete();

      status = 0;
    });

    if (status == 1) {
      String imageUrl = await uploadTask.ref.getDownloadURL();

      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .doc(fileName)
          .update({"message": imageUrl});

      print(imageUrl);
    }
  }

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": DateTime.now().microsecondsSinceEpoch,
      };

      _message.clear();
      await _firestore
          .collection('chatroom')
          .doc(chatRoomId)
          .collection('chats')
          .add(messages);
    } else {
      print("Enter Some Text");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF050A30).withOpacity(1),
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: StreamBuilder<DocumentSnapshot>(
          stream:
              _firestore.collection("users").doc(userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return ListTile(
                title: Center(
                  child: Text(
                    userMap['name'],
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                subtitle: snapshot.data!['status'] == 'Online' && isLogin
                    ? const Center(
                        child: Text(
                          'Online',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      )
                    : const Center(
                        child: Text(
                        'Offline',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      )),
                trailing: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    const CircleAvatar(
                      child: Icon(
                        Icons.person,
                        color: Colors.black87,
                        size: 22,
                      ),
                      radius: 18,
                      backgroundColor: Colors.white,
                    ),
                    snapshot.data!['status'] == 'Online' && isLogin
                        ? const Icon(
                            Icons.circle,
                            color: Colors.green,
                            size: 13,
                          )
                        : const Text(''),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 24,
          ),
          alignment: Alignment.bottomRight,
        ),
      ),
      //resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            const Color(0xFF050A30).withOpacity(1),
            const Color(0xFF050A30).withOpacity(1),
            Colors.black,
          ], begin: Alignment.topCenter, end: Alignment.center),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 18,
              ),
              Container(
                height: size.height / 1.33,
                width: size.width,
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('chatroom')
                      .doc(chatRoomId)
                      .collection('chats')
                      .orderBy("time", descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic>? map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>?;
                          return messages(size, map!, context);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                height: size.height / 10,
                width: size.width,
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35),
                  child: Container(
                    height: size.height / 12,
                    width: size.width / 1.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)),
                          height: size.height / 17,
                          width: size.width / 1.4,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: TextField(
                              focusNode: messageFocus,
                              controller: _message,
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () => getImage(),
                                  icon: const Icon(
                                    Icons.photo,
                                    color: Colors.black,
                                    size: 28,
                                  ),
                                ),
                                border: InputBorder.none,
                                hintText: "Send Message",
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        IconButton(
                            icon: const Icon(
                              Icons.send_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                            }),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
