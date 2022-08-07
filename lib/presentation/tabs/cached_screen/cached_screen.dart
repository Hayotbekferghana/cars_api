import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:task_project/db/cached_company.dart';
import 'package:task_project/db/local_db.dart';
import 'package:task_project/presentation/tabs/about_screen/about_screen.dart';

import 'package:task_project/service/api_provider.dart';
import 'package:task_project/utils/icons.dart';

import '../../../utils/utility_functions.dart';

class CachedScreen extends StatefulWidget {
  const CachedScreen({Key? key}) : super(key: key);

  @override
  State<CachedScreen> createState() => _CachedScreenState();
}

class _CachedScreenState extends State<CachedScreen> {
  late List<CachedCompany> cachedCompanies;

  Future<List<CachedCompany>> init() async {
    return await LocalDatabase.getAllCachedCompanies();
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
          "Favourites",
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
            child: FutureBuilder<List<CachedCompany>>(
                future: init(),
                builder: (BuildContext ctx,
                    AsyncSnapshot<List<CachedCompany>> snap) {
                  if (snap.hasError) {
                    return Center(
                      child: Text(snap.error.toString()),
                    );
                  } else if (snap.hasData) {
                    var item = snap.data!;
                    if (item.isNotEmpty) {
                      return GridView.count(
                          physics: const BouncingScrollPhysics(),
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          crossAxisCount: 2,
                          childAspectRatio: 0.8,
                          children: List.generate(
                            item.length,
                            (index) => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Stack(children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (ctx) {
                                      return SingleItem(
                                          productId: item[index].id,
                                          repository: ApiProvider(),
                                          isHome: false);
                                    }));
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(10),
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Expanded(
                                            child: Image.network(
                                          item[index].logo,
                                          width: 140,
                                        )),
                                        Expanded(
                                            child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(item[index].carModel),
                                            Text(item[index]
                                                .establishedYear
                                                .toString())
                                          ],
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 10,
                                  right: 10,
                                  child: IconButton(
                                    onPressed: () {
                                      LocalDatabase.deleteCachedCompanyById(item[index].id);
                                      UtilityFunctions.getMyToast(
                                          message:
                                              "Successfully deleted ${item[index].carModel} from your favourites list");
                                      setState(() {});
                                    },
                                    icon: const Icon(Icons.delete,color: Colors.red,),
                                  ),
                                ),
                              ]),
                            ),
                          ));
                    } else {
                      return Center(
                        child: Lottie.asset(MyIcons.emptyLottie),
                      );
                    }
                  } else {
                    return Shimmer(
                      duration: const Duration(seconds: 3),
                      //Default value
                      interval: const Duration(seconds: 5),
                      //Default value: Duration(seconds: 0)
                      color: Colors.white,
                      //Default value
                      enabled: true,
                      //Default value
                      direction: const ShimmerDirection.fromLTRB(),
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          10,
                          (index) => Container(
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                }),
          ),
        ],
      ),
    );
  }
}
