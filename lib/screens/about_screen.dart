import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:task_project/db/cached_company.dart';
import 'package:task_project/db/local_db.dart';
import 'package:task_project/model/company_item.dart';
import 'package:task_project/service/api_provider.dart';
import 'package:task_project/utils/utility_functions.dart';

class SingleItem extends StatefulWidget {
  const SingleItem(
      {Key? key, required this.productId, required this.repository, required this.isHome})
      : super(key: key);
  final bool isHome;
  final int productId;
  final ApiProvider repository;

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {

  late CompanyItem product;

  Future<CompanyItem> init() async {
    product =
    await widget.repository.getSingleCompany(companyId: widget.productId);
    setState(() {});
    return product;
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery
              .of(context)
              .size
              .height,
          child: FutureBuilder<CompanyItem>(
              future: init(),
              builder:
                  (BuildContext context, AsyncSnapshot<CompanyItem> snapshot) {
                if (snapshot.hasData) {
                  var product = snapshot.data!;
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        bottom: PreferredSize(
                          preferredSize: const Size.fromHeight(20),
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(40),
                                topRight: Radius.circular(40),
                              ),
                              color: Colors.white,
                            ),
                            child: const SizedBox(height: 20),
                          ),
                        ),
                        expandedHeight: 400,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                            product.logo,
                            width: double.maxFinite,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                                child: Text(
                                  product.carModel,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 25),
                                )),
                            const SizedBox(height: 10),
                            ExpansionTile(
                                title: const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 20),
                                  child: Text("Description",
                                      style: TextStyle(fontSize: 25)),
                                ),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Text(
                                      product.description,
                                      style: const TextStyle(fontSize: 15),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                ]),
                            const SizedBox(
                              height: 50,
                            ),
                            CarouselSlider(
                                items: List.generate(
                                  product.carPics.length,
                                      (index) =>
                                      SizedBox(
                                        child: Image.network(
                                          product.carPics[index],
                                        ),
                                      ),
                                ),
                                options: CarouselOptions(
                                  enlargeCenterPage: true,
                                  scrollDirection: Axis.horizontal,
                                )),
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 30),
                              child: (widget.isHome)? Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "\$${product.averagePrice}",
                                    style: const TextStyle(
                                        fontSize: 30, color: Colors.black),
                                  ),
                                  ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.black,
                                          onPrimary: Colors.white,
                                          minimumSize: const Size(150, 70),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(30))),
                                      onPressed: () async {
                                        await LocalDatabase.insertCachedTodo(
                                            CachedCompany(
                                                isFavorite: 1,
                                                id: product.id,
                                                averagePrice: product.averagePrice,
                                                carModel: product.carModel,
                                                establishedYear: product.establishedYear,
                                                logo: product.logo));
                                        UtilityFunctions.getMyToast(message: "Successfully added to Storage");
                                      },
                                      child: const Text(
                                        "Add to Storage",
                                        style: TextStyle(fontSize: 20),
                                      )),
                                ],
                              ): SizedBox()
                            )
                          ],
                        ),
                      )
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(snapshot.data.toString()),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
        ),
      ),
    );
  }
}
