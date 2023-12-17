import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "Get the best photographs",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  )),
                  const SizedBox(
                    width: 30,
                  ),
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
              const SizedBox(
                height: 20,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Text(
                    "T-Shirts Collections",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  )),
                  InkWell(
                      onTap: () {
                        setState(() {
                          current++;
                        });
                      },
                      child: const Icon(Icons.arrow_forward))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedSwitcher(duration: Duration(milliseconds: 500),child:
              isGrid == false
                  ? Container(
                      height: 370,
                      child: PageView.builder(
                          itemCount: shirtList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => DetailScreen(
                                          data: shirtList[current],
                                        )));
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                margin: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: Colors.white),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          shirtList[index].title,
                                          style: const TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 200,
                                      width: double.infinity,
                                      child: Image.asset(shirtList[0].imageUrl),
                                    ),
                                    const Gap(10),
                                    Container(
                                      height: 50,
                                      padding: const EdgeInsets.only(
                                          left: 20, right: 5),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.black87,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 10),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                color: Colors.white),
                                            child: Icon(Icons.shopping_cart,color: Colors.black,)
                                          )
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
                    height: 400,
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
                              Navigator.of(context)
                                  .push(MaterialPageRoute(
                                      builder: (context) => DetailScreen(
                                            data: shirtList[current],
                                          )));
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
                                          MainAxisAlignment.spaceBetween,
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
                                          padding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 15,
                                                  vertical: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      25),
                                              color: Colors.white),
                                          child:  Icon(Icons.shopping_cart,color: Colors.black,)
                                        )
                                      ],
                                    ),
                                  )
                                  // Rest of your content
                                ],
                              ),
                            ),
                          );
                        }),
                  ),),
              const SizedBox(
                height: 20,
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const MyCartScreen()));
                },
                child: Container(
                  height: 60,
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
