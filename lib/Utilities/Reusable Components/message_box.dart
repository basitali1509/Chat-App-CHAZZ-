import 'package:chat_app/Controller/ChatScreenAuth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
  return Column(
    children: [
      map['type'] == "text"
          ? Container(
              //padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              width: size.width,
              alignment: map['sendby'] == _auth.currentUser!.displayName
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                    decoration: BoxDecoration(
                      gradient: map['sendby'] == _auth.currentUser!.displayName
                          ? const LinearGradient(
                              colors: [
                                  Colors.blue,
                                  Colors.blueAccent,
                                ],
                              begin: Alignment.topCenter,
                              end: Alignment.topRight)
                          : const LinearGradient(
                              colors: [
                                  Colors.green,
                                  Colors.lightGreen
                                ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomRight),
                      borderRadius:
                          map['sendby'] == _auth.currentUser!.displayName
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(1),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(15),
                                  bottomLeft: Radius.circular(1),
                                  bottomRight: Radius.circular(25)),
                    ),
                    child: Column(
                      children: [
                        Text(
                          map['message'].replaceAllMapped(
                            RegExp('(.{1,37})(?:\\s+|\$)'),
                            (match) => '${match.group(1)}\n',
                          ),
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${ChatScreenAuth().messageTime(map)}',
                          style: TextStyle(
                              fontSize: 10,
                              color: Colors.black.withOpacity(.8)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )
          : Container(
              height: size.height / 2.5,
              width: size.width,
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              alignment: map['sendby'] == _auth.currentUser!.displayName
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ShowImage(
                      imageUrl: map['message'],
                    ),
                  ),
                ),
                child: Container(
                  height: size.height / 1,
                  width: size.width / 1,
                  decoration: BoxDecoration(border: Border.all()),
                  alignment: map['message'] != "" ? null : Alignment.center,
                  child: map['message'] != ""
                      ? Image.network(
                          map['message'],
                          fit: BoxFit.fill,
                        )
                      : const CircularProgressIndicator(),
                ),
              ),
            ),
    ],
  );
}
