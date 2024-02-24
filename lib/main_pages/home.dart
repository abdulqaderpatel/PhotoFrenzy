import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_emoji/flutter_emoji.dart';
import 'package:flutter_reaction_button/flutter_reaction_button.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:photofrenzy/Emotions/choose_emotion.dart';
import 'package:photofrenzy/competition/individual_competition.dart';
import 'package:photofrenzy/controllers/user_controller.dart';
import 'package:photofrenzy/global/firebase_tables.dart';
import 'package:photofrenzy/global/show_message.dart';
import 'package:photofrenzy/individual_chat.dart';
import 'package:photofrenzy/models/user.dart' as user;
import 'package:photofrenzy/user_posts/comments.dart';
import '../global/constants.dart';
import '../global/theme_mode.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var isLoading = false;
  var items = [];

  List<Map<String, dynamic>> posts = [];
  UserController userController = Get.put(UserController());

  var parser = EmojiParser();

  var a = EmojiParser().get("coffee");

  var reactions = [
    Reaction<String>(
      value: 'happy',
      icon: Text(
        Emoji("happy", "😊").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'sad',
      icon: Text(
        Emoji("sad", "😔").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'fear',
      icon: Text(
        Emoji("fear", "😨").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'anger',
      icon: Text(
        Emoji("anger", "😠").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'disgust',
      icon: Text(
        Emoji("disgust", "🤢").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
    Reaction<String>(
      value: 'surprise',
      icon: Text(
        Emoji("surprise", "😲").code,
        style: const TextStyle(fontSize: 22),
      ),
    ),
  ];

  var emojis = [
    Emoji("happy", "😊"),
    Emoji("sad", "😔"),
    Emoji("fear", "😨"),
    Emoji("anger", "😠"),
    Emoji("disgust", "🤢"),
    Emoji("surprise", "😲")
  ];


  List<String> list = <String>["Competitions", "Your Feed", "Popular"];
  String dropdownValue = "Competitions";

  void getData() async {
    //for the competitions
    userController.chattingUsers.clear();
    setState(() {
      isLoading = true;
    });
    items = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
    firestore.collection('Competitions');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      items.add(data);
    }

    collectionReference = firestore
        .collection('Users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("Chats");
    querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      userController.chattingUsers.add(user.User(
          id: data["id"],
          name: data["name"],
          username: data["username"],
          imageurl: data["imageurl"]));
    }

    //for the user post feed
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id",
        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Map<String, dynamic>> temp = [];
    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      posts = temp;
    });
  }


  void loadData() async {
    items = [];
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference collectionReference =
    firestore.collection('Competitions');
    QuerySnapshot querySnapshot = await collectionReference.get();

    for (QueryDocumentSnapshot doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      setState(() {
        items.add(data);
      });
    }
  }

  void getYourFeedData() async {
    var data = await FirebaseTable()
        .postsTable
        .where("creator_id",
        isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Map<String, dynamic>> temp = [];
    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      posts = temp;
    });
  }

  void getPopularData() async {

    var data = await FirebaseTable()
        .postsTable
    .orderBy(
        "likes", descending: true)
        .get();

    List<Map<String, dynamic>> temp = [];
    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      posts = temp;
    });
  }


  var userData = [];

  void getCurrentUserData() async {
    var data = await FirebaseTable()
        .usersTable
        .where("id",
        isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    List<Map<String, dynamic>> temp = [];
    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    userData = temp;

    setState(() {
      isLoading = false;
    });
  }


  Map<String, dynamic>? paymentIntent;

  void makePayment(int index) async {
    try {
      paymentIntent = await createPaymentIntent(index);


      var gpay = const PaymentSheetGooglePay(
          merchantCountryCode: "IND", currencyCode: "IND", testEnv: true);
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
            billingDetails: const BillingDetails(
                address: Address(
                    country: "IN",
                    city: "",
                    line1: "",
                    line2: "",
                    postalCode: "",
                    state: "")),
            paymentIntentClientSecret: paymentIntent!["client_secret"],
            style: ThemeMode.dark,
            merchantDisplayName: "PhotoFrenzy",
            googlePay: gpay
        ),
      );

      displayPaymentSheet(index);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  void displayPaymentSheet(int index) async {
    try {
      await Stripe.instance.presentPaymentSheet();

      await FirebaseFirestore
          .instance
          .collection(
          "Competitions")
          .doc(items[index]
      [
      "id"])
          .update({
        "participants":
        FieldValue
            .arrayUnion([
          FirebaseAuth
              .instance
              .currentUser!
              .uid
        ])
      });
      loadData();

      const serviceId = 'service_mvh1mfq';
      const templateId = 'template_1h0pxtb';
      const userid = "D7BfmJv7IK0otiGd6";

      final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
      await http.post(url,
          headers: {
            'origin': 'http://localhost',
            'Content-Type': 'application/json'
          },
          body: jsonEncode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userid,
            "template_params": {
              "name": FirebaseAuth.instance.currentUser!.displayName,
              "to_email": FirebaseAuth.instance.currentUser!.email,
              "event": items[index]["name"]
            }
          }));
    } catch (e) {
      if (context.mounted) {
        //showErrorDialog(context, e.toString());
      }
    }
  }

  createPaymentIntent(int index) async {
    try {
      Map<String, dynamic> body = {
        "amount": (items[index]["prize_money"] * 100).toString(),
        "currency": "inr"
      };
      http.Response response = await http.post(
          Uri.parse("https://api.stripe.com/v1/payment_intents"),
          body: body,
          headers: {
            "Authorization":
            "Bearer sk_test_51NjJbkSDqOoAu1Yvou3QlHodXEQKoN5nrvK6WP8t2kAdyzKAE2Jmd6umSMZuvh6WjhUvyO8VZpbJo1zFJSyaMvpP00rKeK3kPR",
            "Content-Type": "application/x-www-form-urlencoded"
          });
      return json.decode(response.body);
    } catch (e) {
      if (context.mounted) {
        showErrorDialog(context, e.toString());
      }
    }
  }

  @override
  void initState() {
    getData();
    getCurrentUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: dropdownValue == "Competitions" ? Center(
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme
                  .of(context)
                  .cardColor
              ,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: Get.width * 0.4,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: isDark(context) ? Colors.white : Colors.black,
                  ),
                  elevation: 16,
                  style: TextStyle(
                      color: isDark(context) ? Colors.white : Colors.black),
                  onChanged: (String? value) {
                    setState(() {
                      dropdownValue = value!;
                    });
                    if (value == "Your Feed") {
                      getYourFeedData();
                    }
                    if (value == "Popular") {
                      getPopularData();
                    }
                  },
                  items:
                  list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
        ) : Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          InkWell(onTap: () {
            Get.to(ChooseEmotion(posts: posts,));
          },
              child: Icon(Icons.emoji_emotions,
                color: isDark(context) ? Colors.white : Colors.black,)),
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Theme
                  .of(context)
                  .colorScheme
                  .background,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              width: Get.width * 0.4,
              decoration: BoxDecoration(
                  color: Theme
                      .of(context)
                      .cardColor,
                  borderRadius: BorderRadius.circular(10)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(
                    Icons.arrow_downward,
                    color: isDark(context) ? Colors.white : Colors.black,
                  ),
                  elevation: 16,
                  style: TextStyle(
                      color: isDark(context) ? Colors.white : Colors.black),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  items:
                  list.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ),
          ), Container()
        ],),
      ),
      endDrawer: Drawer(

        child: Column(
          children: <Widget>[
            SizedBox(
              width: Get.width,
              child: const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Your Chats',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
            Expanded(
              child: Obx(
                    () =>
                    ListView.builder(
                        itemCount: userController.chattingUsers.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                    return IndividualChatScreen(
                                        combinedId: userController
                                            .chattingUsers[index].id,
                                        receiverInfo: {
                                          "profile_picture": userController
                                              .chattingUsers[index].imageurl,
                                          "id": userController
                                              .chattingUsers[index].id,
                                          "name": userController
                                              .chattingUsers[index].name,
                                          "username": userController
                                              .chattingUsers[index].username,
                                        });
                                  }));
                            },
                            child: ListTile(
                              leading: userController
                                  .chattingUsers[index].imageurl !=
                                  ""
                                  ? CircleAvatar(
                                backgroundImage: NetworkImage(
                                    userController
                                        .chattingUsers[index].imageurl),
                              )
                                  : const CircleAvatar(
                                backgroundImage: AssetImage(
                                    "assets/images/profile_picture.png"),
                              ),
                              title: Text(
                                userController.chattingUsers[index].name,
                                style: TextStyle(
                                    color: isDark(context)
                                        ? Colors.white
                                        : Colors.black,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600),
                              ),
                              subtitle: Text(
                                "@${userController.chattingUsers[index]
                                    .username}",
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        }),
              ),
            ),
          ],
        ),
      ),
      body: dropdownValue == "Competitions"
          ? SafeArea(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height * 0.85,
                child: PageView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            height: Get.height * 0.9,
                            decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xfffc466b),
                                    Color(0xff3f5efb)
                                  ],
                                  stops: [0.25, 0.75],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                )),
                          ),
                          Column(
                            mainAxisAlignment:
                            MainAxisAlignment.center,
                            crossAxisAlignment:
                            CrossAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    margin:
                                    const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      // gradient: const LinearGradient(
                                      //     colors: [
                                      //       Color(0xff09203F),
                                      //       Color(0xff537895)
                                      //     ]),
                                      borderRadius:
                                      BorderRadius.circular(
                                        20,
                                      ),
                                    ),
                                    child: Column(
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: Get.height *
                                                  0.275,
                                              width: Get.width,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                      20)),
                                              child: ClipRRect(
                                                  borderRadius: const BorderRadius
                                                      .only(
                                                      topRight: Radius
                                                          .circular(
                                                          20),
                                                      topLeft: Radius
                                                          .circular(
                                                          20)),
                                                  child:
                                                  Image.network(
                                                    items[index]
                                                    ["image"],
                                                    fit: BoxFit
                                                        .cover,
                                                  )),
                                            ),
                                            Positioned(
                                              top: Get.height *
                                                  0.025,
                                              right:
                                              Get.width * 0.076,
                                              child: Container(
                                                height: 60,
                                                width: 60,
                                                decoration:
                                                BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  color: const Color(
                                                      0xff65696E)
                                                      .withOpacity(
                                                      0.4),
                                                ),
                                                child: Center(
                                                  child: Column(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .center,
                                                    children: [
                                                      Text(
                                                        DateFormat(
                                                            "d")
                                                            .format(
                                                          DateTime
                                                              .parse(
                                                            items[index]
                                                            [
                                                            "start_time"],
                                                          ),
                                                        ),
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight.w600),
                                                      ),
                                                      Text(
                                                        DateFormat(
                                                            "MMMM")
                                                            .format(
                                                          DateTime
                                                              .parse(
                                                            items[index]
                                                            [
                                                            "start_time"],
                                                          ),
                                                        ),
                                                        maxLines: 1,
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: const TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w600,
                                                            fontSize:
                                                            10),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets
                                              .symmetric(
                                              vertical: 20,
                                              horizontal: 10),
                                          child: Column(
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .center,
                                                children: [
                                                  Text(
                                                      items[index]
                                                      ["name"],
                                                      style: TextStyle(
                                                          fontSize:
                                                          23,
                                                          fontWeight:
                                                          FontWeight
                                                              .w600,
                                                          color: isDark(
                                                              context)
                                                              ? Colors
                                                              .white
                                                              : Colors
                                                              .black)),
                                                ],
                                              ),
                                              Text(
                                                "Theme: ${items[index]["type"]}",
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight
                                                        .w400,
                                                    color: Colors
                                                        .grey),
                                              ),
                                              const Gap(10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .monetization_on_sharp),
                                                      Gap(3),
                                                      Text(
                                                          "Entry Fee",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                    ],
                                                  ),
                                                  Text(
                                                    "\$${items[index]["entry_fee"]}",
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  ),
                                                ],
                                              ),
                                              const Gap(10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .timer),
                                                      Gap(3),
                                                      Text(
                                                          "Starting Time",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                        "hh:mm a")
                                                        .format(
                                                      DateTime
                                                          .parse(
                                                        items[index]
                                                        [
                                                        "start_time"],
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  ),
                                                ],
                                              ),
                                              const Gap(10),
                                              Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  const Row(
                                                    children: [
                                                      Icon(Icons
                                                          .timer_outlined),
                                                      Gap(3),
                                                      Text(
                                                          "Ending Time",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .white,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w600)),
                                                    ],
                                                  ),
                                                  Text(
                                                    DateFormat(
                                                        "hh:mm a")
                                                        .format(
                                                      DateTime
                                                          .parse(
                                                        items[index]
                                                        [
                                                        "end_time"],
                                                      ),
                                                    ),
                                                    style: const TextStyle(
                                                        color: Colors
                                                            .white,
                                                        fontWeight:
                                                        FontWeight
                                                            .w700),
                                                  ),
                                                ],
                                              ),
                                              const Gap(10),
                                              const Center(
                                                child: Text(
                                                  "Prize Money",
                                                  style: TextStyle(
                                                      color: Colors
                                                          .white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                      FontWeight
                                                          .w600),
                                                ),
                                              ),
                                              const Gap(3),
                                              Container(
                                                padding:
                                                const EdgeInsets
                                                    .all(5),
                                                decoration: BoxDecoration(
                                                    color: Colors
                                                        .white,
                                                    borderRadius:
                                                    BorderRadius
                                                        .circular(
                                                        15)),
                                                width: 200,
                                                child: Center(
                                                  child: Text(
                                                    "\$${items[index]["prize_money"]}"
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontSize:
                                                        24,
                                                        color: Colors
                                                            .black,
                                                        fontWeight:
                                                        FontWeight
                                                            .w800),
                                                  ),
                                                ),
                                              ),
                                              const Gap(10),
                                              items[index][
                                              "participants"]
                                                  .contains(FirebaseAuth
                                                  .instance
                                                  .currentUser!
                                                  .uid)
                                                  ? ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    foregroundColor:
                                                    Colors
                                                        .white,
                                                    backgroundColor: Colors
                                                        .green,
                                                    minimumSize:
                                                    Size(
                                                        Get.width,
                                                        40),

                                                    textStyle: const TextStyle(
                                                        fontSize:
                                                        15,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                    // Background color
                                                  ),
                                                  onPressed:
                                                      () {
                                                    Navigator
                                                        .push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder:
                                                              (context) {
                                                            return IndividualCompetitionsScreen(
                                                              competitionDetails: {
                                                                "id":
                                                                items[index]["id"],
                                                                "name":
                                                                items[index]["name"],
                                                                "image":
                                                                items[index]["image"],
                                                                "entry_price":
                                                                items[index]["entry_price"],
                                                                "prize_money":
                                                                items[index]["prize_money"],
                                                                "start_time":
                                                                items[index]["start_time"],
                                                                "end_time":
                                                                items[index]["end_time"],
                                                                "type":
                                                                items[index]["type"],
                                                                "description":
                                                                items[index]["description"]
                                                              },
                                                            );
                                                          }),
                                                    );
                                                  },
                                                  child: const Text(
                                                      "View Details"))
                                                  : ElevatedButton(
                                                  style: ElevatedButton
                                                      .styleFrom(
                                                    foregroundColor: Colors
                                                        .white,
                                                    backgroundColor: Colors
                                                        .amber,
                                                    minimumSize:
                                                    Size(
                                                        Get.width,
                                                        40),

                                                    textStyle: const TextStyle(
                                                        fontSize:
                                                        15,
                                                        fontWeight:
                                                        FontWeight.w600),
                                                    // Background color
                                                  ),
                                                  onPressed:
                                                      () {
                                                    makePayment(index);
                                                  },
                                                  child: const Text(
                                                      "Compete")),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: Get.height * 0.03,
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      );
                    }),
              ),
            ],
          ),
        ),
      )
          : dropdownValue == "Your Feed" ? SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(reverse: true,
            itemCount: posts.length,
            itemBuilder: (context, index) {
              DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(posts[index]["post_id"]));

              // Get current DateTime
              DateTime now = DateTime.now();

              String formattedTime = '';

              // Check if the date is today
              if (dateTime.year == now.year &&
                  dateTime.month == now.month &&
                  dateTime.day == now.day) {
                formattedTime = 'Today';
              } else {
                // Format the date
                formattedTime =
                    DateFormat('MMM d').format(dateTime);
              }

              // Format time (e.g., 3pm)
              formattedTime +=
              ', ${DateFormat.jm().format(dateTime)}';

              return userData[0]["following"].contains(
                  posts[index]["creator_id"]) ? Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Gap(10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: 0.8),
                              borderRadius:
                              BorderRadius.circular(80)),
                          child: posts[index]
                          ["creator_profile_picture"] ==
                              ""
                              ? const CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              "assets/images/profile_picture.png",
                            ),
                          )
                              : CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              posts[index]
                              ["creator_profile_picture"],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.04,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    posts[index]["creator_name"],
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "@${posts[index]["creator_username"]}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(formattedTime)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(left: Get.width * 0.17),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(posts[index]["text"],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight:
                                        FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          posts[index]["type"] == "image"
                              ? Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    10)),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10),
                              child: Image.network(
                                posts[index]["imageurl"],
                                // Replace with the path to your image
                                fit: BoxFit
                                    .fill, // Use BoxFit.fill to force the image to fill the container
                              ),
                            ),
                          )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (!posts[index]["likers"]
                                      .contains(FirebaseAuth
                                      .instance
                                      .currentUser!
                                      .uid)) {
                                    setState(() {
                                      posts[index]
                                      ["likes"]++;
                                      posts[index]
                                      ["likers"]
                                          .add(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(posts[index]
                                    ["post_id"])
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          1),
                                      "likers": FieldValue
                                          .arrayUnion([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  } else {
                                    setState(() {
                                      posts[index]
                                      ["likes"]--;
                                      posts[index]
                                      ["likers"]
                                          .remove(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(posts[index]
                                    ["post_id"])
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          -1),
                                      "likers": FieldValue
                                          .arrayRemove([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  }
                                },
                                child: SizedBox(
                                  height: 33,
                                  child:
                                  ReactionButton<String>(
                                    toggle: false,
                                    direction:
                                    ReactionsBoxAlignment
                                        .rtl,
                                    onReactionChanged:
                                        (Reaction<String>?
                                    reaction) async {
                                      if (!posts[index]
                                      ["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        setState(() {
                                          posts[
                                          index]
                                          ["likers"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                          posts[
                                          index]
                                          ["likes"]++;
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[
                                        index]
                                        ["post_id"])
                                            .update({
                                          "likers": FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                          "likes": FieldValue
                                              .increment(1)
                                        });
                                      }

                                      var userReaction =
                                          "none";
                                      userReaction = posts[
                                      index]
                                      ["happy"]
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)
                                          ? "happy"
                                          : posts[
                                      index]
                                      ["sad"]
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)
                                          ? "sad"
                                          : posts[
                                      index]
                                      ["fear"]
                                          .contains(FirebaseAuth.instance
                                          .currentUser!.uid)
                                          ? "fear"
                                          : posts[
                                      index]
                                      ["anger"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "anger"
                                          : posts[
                                      index]
                                      ["disgust"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "disgust"
                                          : posts[
                                      index]
                                      ["surprise"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "surprise"
                                          : "none";
                                      if (userReaction ==
                                          "none") {
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[
                                        index]
                                        ["post_id"])
                                            .update({
                                          "${reaction!.value}":
                                          FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                        });
                                      } else {
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[index]
                                        ["post_id"])
                                            .update({
                                          "${reaction!.value}":
                                          FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                          userReaction:
                                          FieldValue
                                              .arrayRemove([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ])
                                        });
                                      }
                                      if (!posts[index]
                                      ["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        if (reaction.value ==
                                            "happy") {
                                          posts[
                                          index]
                                          ["happy"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "sad") {
                                          posts[
                                          index]
                                          ["sad"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "fear") {
                                          posts[
                                          index]
                                          ["fear"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "disgust") {
                                          posts[
                                          index]
                                          ["disgust"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "anger") {
                                          posts[
                                          index]
                                          ["anger"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "surprise") {
                                          posts[
                                          index]
                                          ["surprise"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        }
                                      } else {
                                        userReaction ==
                                            "happy"
                                            ? posts[
                                        index]
                                        ["happy"]
                                            .remove(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            : userReaction ==
                                            "sad"
                                            ? posts
                                        [index]
                                        ["sad"]
                                            .remove(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            : userReaction ==
                                            "disgust"
                                            ? posts[
                                        index]
                                        ["disgust"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid)
                                            : userReaction == "anger"
                                            ? posts[index]["anger"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid)
                                            : userReaction == "fear"
                                            ? posts[index]["fear"].remove(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            : posts[index]["surprise"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid);
                                        if (reaction.value ==
                                            "happy") {
                                          posts[index]["happy"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "sad") {
                                          posts[
                                          index]
                                          ["sad"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "fear") {
                                          posts[
                                          index]
                                          ["fear"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "disgust") {
                                          posts[index]["disgust"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "anger") {
                                          posts[
                                          index]
                                          ["anger"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "surprise") {
                                          posts[
                                          index]
                                          ["surprise"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        }
                                      }
                                    },
                                    reactions: reactions,
                                    placeholder: Reaction<
                                        String>(
                                        value: null,
                                        icon: !posts[index]
                                        ["likers"]
                                            .contains(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            ? const Icon(Icons
                                            .thumb_up)
                                            : posts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[0].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["sad"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[1].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["fear"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[2].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["anger"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[3].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[4].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : Text(emojis[5].code,
                                            style: const TextStyle(
                                                fontSize: 22))),
                                    boxColor: Colors.black
                                        .withOpacity(0.5),
                                    boxRadius: 10,
                                    itemsSpacing: 0,
                                    itemSize:
                                    const Size(35, 35),
                                  ),
                                ),

                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder:
                                        (BuildContext context) {
                                      return AlertDialog(
                                        title: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Reactions',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              )
                                            ]),
                                        content: Container(
                                          margin:
                                          const EdgeInsets.all(
                                              10),
                                          width: Get.width,
                                          child: Column(
                                              mainAxisSize: MainAxisSize
                                                  .min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[0].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["happy"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[1].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["sad"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[2].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["fear"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[3].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["anger"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[4].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["disgust"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[5].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["surprise"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                              ]


                                          ),
                                        ),
                                        actions: <Widget>[
                                          Center(
                                            child: TextButton(
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors
                                                        .red,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(posts[index]["likes"]
                                    .toString()),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CommentsScreen(
                                            postId: posts[index]
                                            ["post_id"],
                                            description: posts[index]
                                            ["text"],
                                          );
                                        },
                                      ),);
                                  },
                                  child: const Icon(
                                      Icons.chat_bubble_outline)),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                posts[index]["comments"].toString(),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(onTap: () {
                                posts[index]["type"] ==
                                    "text"
                                    ? shareText(context,
                                    posts[index]["text"])
                                    : shareImage(context,
                                    posts[index]["text"],
                                    posts[index]["imageurl"]);
                              }, child: const Icon(Icons.replay_outlined)),

                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              ) : Container();
            },),
        ),) : SafeArea(
        child: Container(
          margin: const EdgeInsets.all(10),
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              DateTime dateTime =
              DateTime.fromMillisecondsSinceEpoch(
                  int.parse(posts[index]["post_id"]));

              // Get current DateTime
              DateTime now = DateTime.now();

              String formattedTime = '';

              // Check if the date is today
              if (dateTime.year == now.year &&
                  dateTime.month == now.month &&
                  dateTime.day == now.day) {
                formattedTime = 'Today';
              } else {
                // Format the date
                formattedTime =
                    DateFormat('MMM d').format(dateTime);
              }

              // Format time (e.g., 3pm)
              formattedTime +=
              ', ${DateFormat.jm().format(dateTime)}';

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    const Gap(10),
                    Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.grey, width: 0.8),
                              borderRadius:
                              BorderRadius.circular(80)),
                          child: posts[index]
                          ["creator_profile_picture"] ==
                              ""
                              ? const CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            backgroundImage: AssetImage(
                              "assets/images/profile_picture.png",
                            ),
                          )
                              : CircleAvatar(
                            radius: 23,
                            backgroundColor: Colors.white,
                            backgroundImage: NetworkImage(
                              posts[index]
                              ["creator_profile_picture"],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: Get.width * 0.04,
                        ),
                        Flexible(
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    posts[index]["creator_name"],
                                    style: TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.w800,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black),
                                  ),
                                  Text(
                                    "@${posts[index]["creator_username"]}",
                                    style: const TextStyle(
                                        fontSize: 17,
                                        color: Colors.grey),
                                  ),
                                ],
                              ),
                              Text(formattedTime)
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: Get.height * 0.01,
                    ),
                    Container(
                      margin:
                      EdgeInsets.only(left: Get.width * 0.17),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Flexible(
                                child: Text(posts[index]["text"],
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: isDark(context)
                                            ? Colors.white
                                            : Colors.black,
                                        fontWeight:
                                        FontWeight.w500)),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          posts[index]["type"] == "image"
                              ? Container(
                            width: Get.width,
                            decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(
                                    10)),
                            child: ClipRRect(
                              borderRadius:
                              BorderRadius.circular(10),
                              child: Image.network(
                                posts[index]["imageurl"],
                                // Replace with the path to your image
                                fit: BoxFit
                                    .fill, // Use BoxFit.fill to force the image to fill the container
                              ),
                            ),
                          )
                              : Container(),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (!posts[index]["likers"]
                                      .contains(FirebaseAuth
                                      .instance
                                      .currentUser!
                                      .uid)) {
                                    setState(() {
                                      posts[index]
                                      ["likes"]++;
                                      posts[index]
                                      ["likers"]
                                          .add(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(posts[index]
                                    ["post_id"])
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          1),
                                      "likers": FieldValue
                                          .arrayUnion([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  } else {
                                    setState(() {
                                      posts[index]
                                      ["likes"]--;
                                      posts[index]
                                      ["likers"]
                                          .remove(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid);
                                    });
                                    await FirebaseTable()
                                        .postsTable
                                        .doc(posts[index]
                                    ["post_id"])
                                        .update({
                                      "likes":
                                      FieldValue.increment(
                                          -1),
                                      "likers": FieldValue
                                          .arrayRemove([
                                        FirebaseAuth.instance
                                            .currentUser!.uid
                                      ])
                                    });
                                  }
                                },
                                child: SizedBox(
                                  height: 33,
                                  child:
                                  ReactionButton<String>(
                                    toggle: false,
                                    direction:
                                    ReactionsBoxAlignment
                                        .rtl,
                                    onReactionChanged:
                                        (Reaction<String>?
                                    reaction) async {
                                      if (!posts[index]
                                      ["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        setState(() {
                                          posts[
                                          index]
                                          ["likers"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                          posts[
                                          index]
                                          ["likes"]++;
                                        });
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[
                                        index]
                                        ["post_id"])
                                            .update({
                                          "likers": FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                          "likes": FieldValue
                                              .increment(1)
                                        });
                                      }

                                      var userReaction =
                                          "none";
                                      userReaction = posts[
                                      index]
                                      ["happy"]
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)
                                          ? "happy"
                                          : posts[
                                      index]
                                      ["sad"]
                                          .contains(FirebaseAuth
                                          .instance
                                          .currentUser!
                                          .uid)
                                          ? "sad"
                                          : posts[
                                      index]
                                      ["fear"]
                                          .contains(FirebaseAuth.instance
                                          .currentUser!.uid)
                                          ? "fear"
                                          : posts[
                                      index]
                                      ["anger"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "anger"
                                          : posts[
                                      index]
                                      ["disgust"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "disgust"
                                          : posts[
                                      index]
                                      ["surprise"].contains(
                                          FirebaseAuth.instance
                                              .currentUser!.uid)
                                          ? "surprise"
                                          : "none";
                                      if (userReaction ==
                                          "none") {
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[
                                        index]
                                        ["post_id"])
                                            .update({
                                          "${reaction!.value}":
                                          FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                        });
                                      } else {
                                        await FirebaseTable()
                                            .postsTable
                                            .doc(posts[index]
                                        ["post_id"])
                                            .update({
                                          "${reaction!.value}":
                                          FieldValue
                                              .arrayUnion([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ]),
                                          userReaction:
                                          FieldValue
                                              .arrayRemove([
                                            FirebaseAuth
                                                .instance
                                                .currentUser!
                                                .uid
                                          ])
                                        });
                                      }
                                      if (!posts[index]
                                      ["likers"]
                                          .contains(
                                          FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid)) {
                                        if (reaction.value ==
                                            "happy") {
                                          posts[
                                          index]
                                          ["happy"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "sad") {
                                          posts[
                                          index]
                                          ["sad"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "fear") {
                                          posts[
                                          index]
                                          ["fear"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "disgust") {
                                          posts[
                                          index]
                                          ["disgust"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "anger") {
                                          posts[
                                          index]
                                          ["anger"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "surprise") {
                                          posts[
                                          index]
                                          ["surprise"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        }
                                      } else {
                                        userReaction ==
                                            "happy"
                                            ? posts[
                                        index]
                                        ["happy"]
                                            .remove(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            : userReaction ==
                                            "sad"
                                            ? posts
                                        [index]
                                        ["sad"]
                                            .remove(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            : userReaction ==
                                            "disgust"
                                            ? posts[
                                        index]
                                        ["disgust"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid)
                                            : userReaction == "anger"
                                            ? posts[index]["anger"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid)
                                            : userReaction == "fear"
                                            ? posts[index]["fear"].remove(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            : posts[index]["surprise"]
                                            .remove(FirebaseAuth.instance
                                            .currentUser!.uid);
                                        if (reaction.value ==
                                            "happy") {
                                          posts[index]["happy"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "sad") {
                                          posts[
                                          index]
                                          ["sad"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "fear") {
                                          posts[
                                          index]
                                          ["fear"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "disgust") {
                                          posts[index]["disgust"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "anger") {
                                          posts[
                                          index]
                                          ["anger"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        } else if (reaction
                                            .value ==
                                            "surprise") {
                                          posts[
                                          index]
                                          ["surprise"]
                                              .add(FirebaseAuth
                                              .instance
                                              .currentUser!
                                              .uid);
                                        }
                                      }
                                    },
                                    reactions: reactions,
                                    placeholder: Reaction<
                                        String>(
                                        value: null,
                                        icon: !posts[index]
                                        ["likers"]
                                            .contains(FirebaseAuth
                                            .instance
                                            .currentUser!
                                            .uid)
                                            ? const Icon(Icons
                                            .thumb_up)
                                            : posts[
                                        index]
                                        ["happy"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[0].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["sad"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[1].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["fear"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[2].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["anger"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[3].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : posts[index]["disgust"]
                                            .contains(
                                            FirebaseAuth.instance
                                                .currentUser!.uid)
                                            ? Text(emojis[4].code,
                                            style: const TextStyle(
                                                fontSize: 22))
                                            : Text(emojis[5].code,
                                            style: const TextStyle(
                                                fontSize: 22))),
                                    boxColor: Colors.black
                                        .withOpacity(0.5),
                                    boxRadius: 10,
                                    itemsSpacing: 0,
                                    itemSize:
                                    const Size(35, 35),
                                  ),
                                ),

                              ),
                              const SizedBox(
                                width: 3,
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog<void>(
                                    context: context,
                                    barrierDismissible: false,
                                    // user must tap button!
                                    builder:
                                        (BuildContext context) {
                                      return AlertDialog(
                                        title: const Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment
                                                .center,
                                            children: [
                                              Text(
                                                'Reactions',
                                                style: TextStyle(
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              )
                                            ]),
                                        content: Container(
                                          margin:
                                          const EdgeInsets.all(
                                              10),
                                          width: Get.width,
                                          child: Column(
                                              mainAxisSize: MainAxisSize
                                                  .min,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[0].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["happy"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[1].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["sad"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[2].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["fear"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[3].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["anger"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[4].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["disgust"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Text(
                                                      emojis[5].code,
                                                      style: const TextStyle(
                                                          fontSize: 22),
                                                    ),
                                                    Text(
                                                        posts[index]["surprise"]
                                                            .length
                                                            .toString())
                                                  ],
                                                ),
                                              ]


                                          ),
                                        ),
                                        actions: <Widget>[
                                          Center(
                                            child: TextButton(
                                              child: const Text(
                                                'Ok',
                                                style: TextStyle(
                                                    color: Colors
                                                        .red,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600),
                                              ),
                                              onPressed: () {
                                                Navigator.of(
                                                    context)
                                                    .pop();
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: Text(posts[index]["likes"]
                                    .toString()),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return CommentsScreen(
                                            postId: posts[index]
                                            ["post_id"],
                                            description: posts[index]
                                            ["text"],
                                          );
                                        },
                                      ),);
                                  },
                                  child: const Icon(
                                      Icons.chat_bubble_outline)),
                              const SizedBox(
                                width: 3,
                              ),
                              Text(
                                posts[index]["comments"].toString(),
                              ),
                              SizedBox(
                                width: Get.width * 0.1,
                              ),
                              InkWell(onTap: () {
                                posts[index]["type"] ==
                                    "text"
                                    ? shareText(context,
                                    posts[index]["text"])
                                    : shareImage(context,
                                    posts[index]["text"],
                                    posts[index]["imageurl"]);
                              }, child: const Icon(Icons.replay_outlined)),

                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      color: Colors.grey,
                    ),
                  ],
                ),
              );
            },),
        ),),);
  }
}
