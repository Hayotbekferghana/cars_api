import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:task_project/db/cached_company.dart';
import 'package:task_project/db/local_db.dart';
import 'package:task_project/model/company_item.dart';
import 'package:task_project/service/api_provider.dart';
import 'package:task_project/utils/utility_functions.dart';

class SingleItem extends StatefulWidget {
  const SingleItem(
      {Key? key,
        required this.productId,
        required this.repository,
        required this.isHome})
      : super(key: key);
  final bool isHome;
  final int productId;
  final ApiProvider repository;

  @override
  State<SingleItem> createState() => _SingleItemState();
}

class _SingleItemState extends State<SingleItem> {
  late CompanyItem product;
  IconData icon = Icons.favorite_border;
  bool isFavourite = false;

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
      appBar: AppBar(
        title: GradientText(
          "Company Info",
          colors: const [
            Colors.grey,
            Colors.white,
            Colors.grey,
          ],
          gradientDirection: GradientDirection.ltr,
        ),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: FutureBuilder<CompanyItem>(
            future: init(),
            builder:
                (BuildContext context, AsyncSnapshot<CompanyItem> snapshot) {
              if (snapshot.hasData) {
                var product = snapshot.data!;
                return Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 90,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                                offset: Offset(1, 3),
                                color: Colors.grey,
                                blurRadius: 10,
                                blurStyle: BlurStyle.outer)
                          ]),
                      child: Image.network(
                        product.logo,
                        fit: BoxFit.contain,
                      ),
                    ),
                    SizedBox(
                      height: 450,
                      child: SingleChildScrollView(
                        physics:const BouncingScrollPhysics(),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
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
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              CarouselSlider(
                                  items: List.generate(
                                    product.carPics.length,
                                        (index) => SizedBox(
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(25),
                                        child: Image.network(
                                          fit: BoxFit.fill,
                                          product.carPics[index],
                                        ),
                                      ),
                                    ),
                                  ),
                                  options: CarouselOptions(
                                    enlargeCenterPage: true,
                                    scrollDirection: Axis.horizontal,
                                  )),
                              const SizedBox(
                                height: 50,
                              ),
                              (widget.isHome)
                                  ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "\$${product.averagePrice}",
                                      style: const TextStyle(
                                          fontSize: 30,
                                          color: Colors.black),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                          BorderRadius.circular(
                                              36)),
                                      padding: const EdgeInsets.all(5),
                                      child: IconButton(
                                        onPressed: () async {
                                          isFavourite = true;
                                          await LocalDatabase.insertCachedTodo(
                                              (CachedCompany(
                                                  isFavorite: 1,
                                                  id: product.id,
                                                  averagePrice: product
                                                      .averagePrice,
                                                  carModel:
                                                  product.carModel,
                                                  establishedYear: product
                                                      .establishedYear,
                                                  logo: product.logo)));
                                          if (isFavourite) {
                                            icon = Icons.favorite;
                                          }
                                          setState(() {});
                                          UtilityFunctions.getMyToast(
                                              message:
                                              "Successfully added to your favourites");
                                        },
                                        icon: Icon(
                                          icon,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                                  : const SizedBox(),
                            ]),
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
    );
  }
}
