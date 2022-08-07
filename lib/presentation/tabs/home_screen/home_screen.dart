import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:task_project/model/company_item.dart';
import 'package:task_project/presentation/tabs/about_screen/about_screen.dart';
import 'package:task_project/service/api_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ApiProvider apiProvider = ApiProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GradientText(
          "Companies",
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
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(201))),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CompanyItem>>(
                future: apiProvider.getCompaniesList(),
                builder:
                    (BuildContext ctx, AsyncSnapshot<List<CompanyItem>> snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(snap.error.toString()),
                    );
                  } else if (snap.hasData) {
                    var item = snap.data!;
                    return ListView(
                        physics: const BouncingScrollPhysics(),
                        children: List.generate(
                          item.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (ctx) {
                                return SingleItem(
                                  productId: item[index].id,
                                  repository: apiProvider,
                                  isHome: true,
                                );
                              }));
                            },
                            child: Container(
                              width: double.infinity,
                              height: 100,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 5),
                              padding: const EdgeInsets.all(10),
                              // height: 170,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: const [
                                    BoxShadow(
                                        offset: Offset(1, 3),
                                        color: Colors.grey,
                                        blurRadius: 5,
                                        blurStyle: BlurStyle.outer)
                                  ]),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Image.network(item[index].logo)),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          item[index].carModel,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 20),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            const Text(
                                              "Since: ",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              item[index]
                                                  .establishedYear
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  } else {
                    return Shimmer(
                      duration:const Duration(seconds: 3), //Default value
                      interval: const Duration(seconds: 5), //Default value: Duration(seconds: 0)
                      color: Colors.white, //Default value
                      enabled: true, //Default value
                      direction: const ShimmerDirection.fromLTRB(),
                      child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: List.generate(
                            50,
                                (index) => Container(
                                  width: double.infinity,
                                  height: 100,
                                  margin: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 5),
                                  padding: const EdgeInsets.all(10),
                                  // height: 170,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(16),
                                      boxShadow: const [
                                        BoxShadow(
                                            offset: Offset(1, 3),
                                            color: Colors.grey,
                                            blurRadius: 5,
                                            blurStyle: BlurStyle.outer)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Container(decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(5)))),
                                      Expanded(
                                        flex: 3,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(width: 50,height: 10,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(16))),
                                            Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(width: 50,height: 10,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(16))),
                                                Container(width: 50,height: 10,decoration: BoxDecoration(color: Colors.grey.withOpacity(0.5),borderRadius: BorderRadius.circular(16))),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          )),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
