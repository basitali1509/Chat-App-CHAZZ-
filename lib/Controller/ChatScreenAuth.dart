import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class ChatScreenAuth {
  String messageTime(Map<String, dynamic> map) {
    var dt =
        DateTime.fromMicrosecondsSinceEpoch(int.parse(map['time'].toString()));
    String diff = '';
    diff = DateFormat('jm').format(dt).toString();

    return diff;
  }
}

class ShowImage extends StatelessWidget {
  final String imageUrl;

  const ShowImage({required this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Colors.black,
        child: Image.network(imageUrl),
      ),
    );
  }
}
