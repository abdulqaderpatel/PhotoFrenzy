import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:photofrenzy/controllers/user_controller.dart';

import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/models/user.dart' as user;

import 'components/chat/receiver_text.dart';
import 'components/chat/sender_text.dart';

class IndividualChatScreen extends StatefulWidget {
  final Map<dynamic, dynamic> receiverInfo;
  final String combinedId;

  const IndividualChatScreen(
      {required this.combinedId, required this.receiverInfo, key});

  @override
  State<IndividualChatScreen> createState() => _IndividualChatScreenState();
}

class _IndividualChatScreenState extends State<IndividualChatScreen> {
  var chatTable = FirebaseFirestore.instance.collection("Chats");
  final messageController = TextEditingController();
  var isLoading = false;

  void getData() async {
    setState(() {
      isLoading = true;
    });

    var chatTable = FirebaseFirestore.instance.collection("Chats");
    var firebaseData = await chatTable.doc(widget.combinedId).get();
    var chatTableData =
        await FirebaseTable().chatsTable.doc(widget.combinedId).get();

    if (!firebaseData.exists) {
      await chatTable
          .doc(widget.combinedId)
          .collection("Color")
          .doc(widget.combinedId)
          .set({
        "sender_chat_bubble": "#4075AF",
        "receiver_chat_bubble": "#2A3C4F",
        "sender_chat_text": "#FFEEEE",
        "receiver_chat_text": "#FFEEEE",
        "name_text": "#FFFFFF",
        "top_bar": "#2A3C4F",
        "bottom_bar": "#2A3C4F",
        "background": "#1F282E",
        "icon": "#505E78",
        "text_box": "#19222E",
        "input_text": "#FFFFFF"
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: isLoading
            ? const Center(child: CircularProgressIndicator(color: Colors.grey))
            : SafeArea(
                child: Column(
                  children: [
                    StreamBuilder<QuerySnapshot>(
                        stream: chatTable
                            .doc(widget.combinedId)
                            .collection("Color")
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Container> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = Container(
                                color: Color(int.parse(
                                    client["top_bar"].replaceAll("#", "0xFF"))),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () => Navigator.pop(context),
                                      child: const Icon(Icons.arrow_back),
                                    ),
                                    SizedBox(
                                      width: Get.width * 0.93,
                                      child: ListTile(
                                          leading: widget.receiverInfo[
                                                      "profile_picture"] !=
                                                  ""
                                              ? CircleAvatar(
                                                  backgroundImage: NetworkImage(
                                                      widget.receiverInfo[
                                                          "profile_picture"]),
                                                )
                                              : const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/images/profile_picture.png")),
                                          title: Text(
                                            widget.receiverInfo["name"],
                                            maxLines: 1,
                                            style: TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                color: Color(int.parse(
                                                    client["name_text"]
                                                        .replaceAll(
                                                            "#", "0xFF"))),
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          trailing: PopupMenuButton(
                                              color: Color(int.parse(
                                                  client["name_text"]
                                                      .replaceAll(
                                                          "#", "0xFF"))),
                                              icon: const Icon(Icons.menu),
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                      onTap: () {},
                                                      child: const Text(
                                                        "Edit profile",
                                                        style: TextStyle(
                                                            color: Colors.grey),
                                                      )),
                                                  PopupMenuItem(
                                                    onTap: () async {
                                                      await chatTable
                                                          .doc(
                                                              widget.combinedId)
                                                          .collection("Color")
                                                          .doc(
                                                              widget.combinedId)
                                                          .set({
                                                        "sender_chat_bubble":
                                                            "#4075AF",
                                                        "receiver_chat_bubble":
                                                            "#2A3C4F",
                                                        "sender_chat_text":
                                                            "#FFEEEE",
                                                        "receiver_chat_text":
                                                            "#FFEEEE",
                                                        "name_text": "#FFFFFF",
                                                        "top_bar": "#2A3C4F",
                                                        "bottom_bar": "#2A3C4F",
                                                        "background": "#1F282E",
                                                        "icon": "#505E78",
                                                        "text_box": "#19222E",
                                                        "input_text": "#FFFFFF"
                                                      });
                                                    },
                                                    child: Text(
                                                      "Dark theme",
                                                      style: TextStyle(
                                                          color: Color(
                                                            int.parse(client[
                                                                    "background"]
                                                                .replaceAll("#",
                                                                    "0xFF")),
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  ),
                                                  PopupMenuItem(
                                                    onTap: () async {
                                                      await chatTable
                                                          .doc(
                                                              widget.combinedId)
                                                          .collection("Color")
                                                          .doc(
                                                              widget.combinedId)
                                                          .set({
                                                        "sender_chat_bubble":
                                                            "#29CC55",
                                                        "receiver_chat_bubble":
                                                            "#C7C4CD",
                                                        "name_text": "#000000",
                                                        "sender_chat_text":
                                                            "#000000",
                                                        "receiver_chat_text":
                                                            "#FFFFFF",
                                                        "top_bar": "#C7C4CD",
                                                        "bottom_bar": "#C7C4CD",
                                                        "background": "#FFFFFF",
                                                        "icon": "#6D707E",
                                                        "text_box": "#FFFFFF",
                                                        "input_text": "#000000"
                                                      });
                                                    },
                                                    child: Text(
                                                      "Light theme",
                                                      style: TextStyle(
                                                          color: Color(
                                                            int.parse(client[
                                                                    "background"]
                                                                .replaceAll("#",
                                                                    "0xFF")),
                                                          ),
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ),
                                                  )
                                                ];
                                              })),
                                    ),
                                  ],
                                ),
                              );
                              clientWidgets.add(clientWidget);
                            }
                          }
                          return Column(
                            children: clientWidgets,
                          );
                        }),
                    Flexible(
                      flex: 1,
                      child: SingleChildScrollView(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: chatTable
                              .doc(widget.combinedId)
                              .collection("Color")
                              .snapshots(),
                          builder: (context, snapshot) {
                            List<Container> firstClientWidgets = [];
                            if (snapshot.hasData) {
                              final firstClients = snapshot.data?.docs;
                              for (var firstClient in firstClients!) {
                                final clientWidget = Container(
                                  constraints: BoxConstraints(
                                      minHeight: Get.height * 0.82,
                                      minWidth: Get.width),
                                  padding: EdgeInsets.only(
                                      top: 10,
                                      right: Get.width * 0.025,
                                      left: Get.width * 0.025),
                                  color: Color(int.parse(
                                      firstClient["background"]
                                          .replaceAll("#", "0xFF"))),
                                  child: StreamBuilder<QuerySnapshot>(
                                      stream: chatTable
                                          .doc(widget.combinedId)
                                          .collection("messages")
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        List<Row> clientWidgets = [];
                                        if (snapshot.hasData) {
                                          final clients = snapshot.data?.docs;
                                          for (var client in clients!) {
                                            final clientWidget = client[
                                                        "sender"] ==
                                                    FirebaseAuth.instance
                                                        .currentUser!.uid
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      SenderText(
                                                        time: client["time"],
                                                        message:
                                                            client["message"],
                                                        textColor: Color(int
                                                            .parse(firstClient[
                                                                    "sender_chat_text"]
                                                                .replaceAll("#",
                                                                    "0xFF"))),
                                                        bubbleColor: Color(int
                                                            .parse(firstClient[
                                                                    "sender_chat_bubble"]
                                                                .replaceAll("#",
                                                                    "0xFF"))),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      ReceiverText(
                                                        time: client["time"],
                                                        message:
                                                            client["message"],
                                                        textColor: Color(int
                                                            .parse(firstClient[
                                                                    "receiver_chat_text"]
                                                                .replaceAll("#",
                                                                    "0xFF"))),
                                                        bubbleColor: Color(int
                                                            .parse(firstClient[
                                                                    "receiver_chat_bubble"]
                                                                .replaceAll("#",
                                                                    "0xFF"))),
                                                      )
                                                    ],
                                                  );
                                            clientWidgets.add(clientWidget);
                                          }
                                        }
                                        return Column(
                                          children: clientWidgets,
                                        );
                                      }),
                                );
                                firstClientWidgets.add(clientWidget);
                              }
                            }
                            return Column(
                              children: firstClientWidgets,
                            );
                          },
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: chatTable
                            .doc(widget.combinedId)
                            .collection("Color")
                            .snapshots(),
                        builder: (context, snapshot) {
                          List<Container> clientWidgets = [];
                          if (snapshot.hasData) {
                            final clients = snapshot.data?.docs;
                            for (var client in clients!) {
                              final clientWidget = Container(
                                color: Color(int.parse(client["bottom_bar"]
                                    .replaceAll("#", "0xFF"))),
                                padding: const EdgeInsets.only(
                                    top: 10, left: 10, right: 10, bottom: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 32,
                                      color: Color(int.parse(client["icon"]
                                          .replaceAll("#", "0xFF"))),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    SizedBox(
                                      height: Get.height * 0.05,
                                      width: Get.width * 0.76,
                                      child: TextField(
                                        style: TextStyle(
                                          color: Color(
                                            int.parse(
                                              client["input_text"].replaceAll(
                                                "#",
                                                "0xFF",
                                              ),
                                            ),
                                          ),
                                        ),
                                        controller: messageController,
                                        decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.only(
                                              top: 5, left: 10),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(30.0),
                                          ),
                                          filled: true,
                                          hintStyle: const TextStyle(
                                              color: Colors.grey),
                                          hintText: "Type in your text",
                                          fillColor: Color(int.parse(
                                              client["text_box"]
                                                  .replaceAll("#", "0xFF"))),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (messageController.text.isNotEmpty) {

                                          var messageText=messageController.text;
                                          messageController.clear();
                                          var time = DateTime.now()
                                              .millisecondsSinceEpoch
                                              .toString();

                                          await chatTable
                                              .doc(widget.combinedId)
                                              .collection("messages")
                                              .doc(time)
                                              .set({
                                            "type": "text",
                                            "sender": FirebaseAuth
                                                .instance.currentUser!.uid,
                                            "receiver":
                                                widget.receiverInfo["id"],
                                            "time": time,
                                            "message": messageText
                                          });

                                          await FirebaseFirestore.instance
                                              .collection("Users")
                                              .doc(FirebaseAuth
                                                  .instance.currentUser!.uid)
                                              .collection("Chats")
                                              .doc(widget.combinedId)
                                              .set({
                                            "id": widget.combinedId,
                                            "name": widget.receiverInfo["name"],
                                            "username":
                                                widget.receiverInfo["username"],
                                            "imageurl": widget
                                                .receiverInfo["profile_picture"]
                                          });
                                          UserController userController =
                                              Get.put(UserController());

                                          var isAlreadyChat = false;
                                          for (int i = 0;
                                              i <
                                                  userController
                                                      .chattingUsers.length;
                                              i++) {

                                            if (!(userController
                                                    .chattingUsers[i].id ==
                                                widget.combinedId)) {
                                             isAlreadyChat=true;
                                            }
                                          }

                                          if(!isAlreadyChat)
                                            {
                                              userController.chattingUsers.add(
                                                  user.User(
                                                      id: widget.combinedId,
                                                      name: widget
                                                          .receiverInfo["name"],
                                                      username:
                                                      widget.receiverInfo[
                                                      "username"],
                                                      imageurl:
                                                      widget.receiverInfo[
                                                      "imageurl"]));
                                            }

                                          print(userController.chattingUsers[1].id);

                                          messageController.text = "";
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                        }
                                      },
                                      child: Icon(
                                        Icons.send,
                                        size: 32,
                                        color: Color(int.parse(client["icon"]
                                            .replaceAll("#", "0xFF"))),
                                      ),
                                    )
                                  ],
                                ),
                              );
                              clientWidgets.add(clientWidget);
                            }
                          }
                          return Column(
                            children: clientWidgets,
                          );
                        })
                  ],
                ),
              ));
  }
}
