import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:photofrenzy/Market/add_item.dart';
import 'package:photofrenzy/global/firebase_tables.dart';

import '../Market/details.dart';
import '../models/shirt_data.dart';
import '../utilities/show_up_animation.dart';

List<String> optionList = ["ALL", "T-Shirt", "Jacket", "Shoes", "Pants"];
var current = 0;

class MarketPlaceScreen extends StatefulWidget {
  const MarketPlaceScreen({super.key});

  @override
  State<MarketPlaceScreen> createState() => _MarketPlaceScreenState();
}

class _MarketPlaceScreenState extends State<MarketPlaceScreen> {
  var isGrid = false;

  var isLoading = false;
  var items = [];

  getData() async {
    setState(() {
      isLoading = true;
    });
    List<Map<String, dynamic>> temp = [];
    var data = await FirebaseTable().productsTable.get();

    for (var element in data.docs) {
      setState(() {
        temp.add(element.data());
      });
    }

    setState(() {
      items = temp;
    });

    setState(() {
      isLoading = false;
    });

    print(items);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marketplace"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const AddItemScreen();
                }));
              },
              icon: const Icon(Icons.add))
        ],
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 80,
                        width: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(35),
                          border: Border.all(),
                        ),
                        child: isGrid
                            ? InkWell(
                                onTap: () {
                                  setState(() {
                                    isGrid = false;
                                  });
                                },
                                child: const Icon(Icons.grid_view))
                            : InkWell(
                                onTap: () {
                                  setState(() {
                                    isGrid = true;
                                  });
                                },
                                child: const Icon(Icons.list)),
                      ),
                    ],
                  ),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 1000),
                    child: isGrid == false
                        ? Container(
                            height: 350,
                            child: PageView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                    data: shirtList[current],
                                                    details: items[index],
                                                  )));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(5),
                                      margin: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.white),
                                      child: Column(
                                        children: [
                                          Row(mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                items[index]["title"],
                                                style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),

                                            ],
                                          ),
                                          const SizedBox(height: 10,),
                                          SizedBox(
                                            height: 200,
                                            width: double.infinity,
                                            child: Image.network(
                                                items[index]["imageurl"]),
                                          ),
                                          const Gap(10),
                                          Container(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 5),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$${items[index]["price"]}",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Colors.white),
                                                    child: const Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.black,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          )
                        : Container(
                            height: 450,
                            child: GridView.builder(
                                itemCount: shirtList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 20,
                                        mainAxisExtent: 250),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  DetailScreen(
                                                      data: shirtList[current],
                                                      details: items[index])));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15),
                                      margin: EdgeInsets.all(isGrid ? 10 : 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            shirtList[index].title,
                                            style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          SizedBox(
                                            height: 100,
                                            width: double.infinity,
                                            child: Image.asset(
                                              shirtList[index].imageUrl,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Container(
                                            height: 50,
                                            padding: const EdgeInsets.only(
                                                left: 20, right: 5),
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.black87,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "\$ 150",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge
                                                      ?.copyWith(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 15,
                                                        vertical: 10),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(25),
                                                        color: Colors.white),
                                                    child: const Icon(
                                                      Icons.shopping_cart,
                                                      color: Colors.black,
                                                    ))
                                              ],
                                            ),
                                          )
                                          // Rest of your content
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
    );
  }
}
