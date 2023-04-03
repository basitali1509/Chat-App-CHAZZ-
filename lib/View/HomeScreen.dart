import 'package:chat_app/Controller/firebase_auth.dart';
import 'package:chat_app/View/ChatScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatus("Online");
    } else if (state == AppLifecycleState.inactive) {
      setStatus("Offline");
    } else {
      setStatus("Offline");
    }
  }

  Map<String, dynamic>? userMap;

  final auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final editController = TextEditingController();
  final searchController = TextEditingController();

  final databaseRef = FirebaseDatabase.instance.ref('Post');

  void setStatus(String status) async {
    await _firestore.collection('users').doc(auth.currentUser!.uid).update({
      "status": status,
    });
  }

  List<Map<String, dynamic>> _searchResults = [];
  List<Map<String, dynamic>> existingItems = [];
  List<Map<String, dynamic>> allResults = [];

  void onSearch() async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    await _firestore
        .collection('users')
        .where("email", isEqualTo: searchController.text)
        .get()
        .then((value) {
      if (value.docs.isNotEmpty) {
        setState(() {
          userMap = value.docs[0].data();
          bool alreadyInList = _searchResults
              .any((element) => element['email'] == userMap!['email']);

          if (!alreadyInList) {
            _searchResults.add(userMap!);
            allResults.add(userMap!);
          }
        });
      } else {
        setState(() {
          userMap = null;
        });
      }
    });
    if (_searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    } else {
      FocusScope.of(context).requestFocus(_searchFocusNode);
    }
    searchController.clear();
  }

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  static String getConversationID(String id, String id2) =>
      id2.hashCode <= id.hashCode ? '${id2}$id' : '${id}${id2}';

  bool isLogin = true;

  void handleSearch() {
    if (searchController.text.isNotEmpty) {
      String enteredEmail = searchController.text.trim();
      bool emailAlreadyExists =
          existingItems.any((element) => element['email'] == enteredEmail);

      if (!emailAlreadyExists) {
        setState(() {
          userMap = {'name': enteredEmail, 'email': enteredEmail};
          existingItems.add(userMap!);
          searchController.clear();
        });
      }
    }
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  final FocusNode _searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      const Color(0xFF050A30).withOpacity(1),
                      const Color(0xFF050A30).withOpacity(1),
                      Colors.black,
                    ], begin: Alignment.topCenter, end: Alignment.center),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Container(
                              color: Colors.transparent,
                              child: AppBar(
                                automaticallyImplyLeading: false,
                                elevation: 0,
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      logOut(context);
                                      isLogin = false;
                                    },
                                    icon: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ],
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                            Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: size.height * .01,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Row(
                                          //mainAxisAlignment: MainAxisAlignment.start,

                                          children: [
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Container(
                                              height: 50,
                                              width: 50,
                                              child: const Image(
                                                  color: Colors.white,
                                                  image: AssetImage(
                                                      'images/chat_icon_100.png')),
                                            ),
                                            const SizedBox(
                                              width: 35,
                                            ),
                                            const Center(
                                              child: Text(
                                                'CHAZZ',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 25),
                                      const Center(
                                        child: Text(
                                          'Chats',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                            fontSize: 22,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 30),
                                      Container(
                                        height: 45,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.white60
                                                    .withOpacity(.8),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(1, 2),
                                              )
                                            ],
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 20),
                                          child: TextFormField(
                                            focusNode: _searchFocusNode,
                                            cursorColor: Colors.black,
                                            controller: searchController,
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: 'Search',
                                              hintStyle: TextStyle(
                                                  color: Colors.black87
                                                      .withOpacity(.9)),
                                              focusedBorder:
                                                  const UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.black87),
                                              ),
                                              suffixIcon: GestureDetector(
                                                onTap: () {
                                                  onSearch();
                                                },
                                                child: const Icon(
                                                  Icons.search,
                                                  color: Colors.black87,
                                                ),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ])),
                          ],
                        ),
                      ),
                      searchController.text.isEmpty
                          ? Expanded(
                              child: ListView.builder(
                                itemCount: allResults.length,
                                itemBuilder: (context, index) {
                                  final result =
                                      allResults[allResults.length - index - 1];
                                  return Card(
                                    color: Colors.black,
                                    child: ListTile(
                                      onTap: () {
                                        String roomId = getConversationID(
                                            auth.currentUser!.displayName!,
                                            result['name']);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => ChatScreen(
                                              isLogin: isLogin,
                                              chatRoomId: roomId,
                                              userMap: result,
                                            ),
                                          ),
                                        );
                                      },
                                      leading: const CircleAvatar(
                                        radius: 25.0,
                                        backgroundColor: Colors.white,
                                        child: Icon(Icons.person_2_outlined,
                                            color: Colors.black),
                                      ),
                                      title: Text(
                                        result['name'] ?? '',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      subtitle: Text(
                                        result['email'].toString(),
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                      trailing: InkWell(
                                          onTap: () {
                                            setState(() {
                                              allResults.removeAt(
                                                  allResults.length -
                                                      index -
                                                      1);
                                            });
                                          },
                                          child: const Icon(Icons.delete,
                                              color: Colors.white)),
                                      tileColor: Colors.black,
                                      textColor: Colors.white,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0, vertical: 5.0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              flex: 2,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: searchController.text.isEmpty
                                    ? allResults.length
                                    : _searchResults.length,
                                itemBuilder: (context, index) {
                                  final item = searchController.text.isEmpty
                                      ? allResults[
                                          allResults.length - index - 1]
                                      : _searchResults[
                                          _searchResults.length - index - 1];

                                  return ListTile(
                                    onTap: () {
                                      String roomId = getConversationID(
                                          auth.currentUser!.displayName!,
                                          item['name']);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChatScreen(
                                            isLogin: isLogin,
                                            chatRoomId: roomId,
                                            userMap: item,
                                          ),
                                        ),
                                      );
                                    },
                                    leading: const Icon(Icons.account_box,
                                        color: Colors.black),
                                    title: Text(
                                      item['name'] ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    subtitle: Text(item['email'] ?? ''),
                                    trailing: InkWell(
                                        onTap: () {
                                          setState(() {
                                            allResults.removeAt(
                                                _searchResults.length -
                                                    index -
                                                    1);
                                            _searchResults.removeAt(
                                                _searchResults.length -
                                                    index -
                                                    1);
                                          });
                                        },
                                        child: const Icon(Icons.delete,
                                            color: Colors.black)),
                                  );
                                },
                              ),
                            ),
                      if (userMap != null &&
                          !existingItems.contains(userMap) &&
                          searchController.text.isEmpty)
                        ListTile(onTap: () {
                          String roomId = getConversationID(
                              auth.currentUser!.displayName!,
                              userMap != null ? userMap!['name'] : '');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreen(
                                isLogin: isLogin,
                                chatRoomId: roomId,
                                userMap: userMap!,
                              ),
                            ),
                          );
                          setState(() {
                            existingItems.add;
                          });
                          setState(() {
                            if (userMap != null) {
                              String userName = userMap!['name'];
                              String userEmail = userMap!['email'];
                              bool isExisting = false;
                              for (var i = 0; i < existingItems.length; i++) {
                                if (existingItems[i]['name'] == userName &&
                                    existingItems[i]['email'] == userEmail) {
                                  isExisting = true;
                                  break;
                                }
                              }
                              if (!isExisting) {
                                existingItems.add(userMap!);
                              }
                              userMap = null;
                            }
                          });
                        })
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
