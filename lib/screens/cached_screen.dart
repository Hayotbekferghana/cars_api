import 'package:flutter/material.dart';
import 'package:task_project/db/cached_company.dart';
import 'package:task_project/db/local_db.dart';
import 'package:task_project/model/company_item.dart';
import 'package:task_project/screens/about_screen.dart';
import 'package:task_project/service/api_provider.dart';

import '../utils/utility_functions.dart';

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
                    return GridView.count(
                        physics: const BouncingScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          item.length,
                          (index) => SizedBox(
                            width: MediaQuery.of(context).size.width*0.5,
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
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Expanded(
                                          child: Image.network(item[index].logo,width: 140,)),
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
                                    LocalDatabase.deleteCachedUser(
                                      CachedCompany(
                                        isFavorite: 1,
                                        id: item[index].id,
                                        averagePrice: item[index].averagePrice,
                                        carModel: item[index].carModel,
                                        establishedYear:
                                            item[index].establishedYear,
                                        logo: item[index].logo,
                                      ),
                                    );
                                    UtilityFunctions.getMyToast(message: "Successfully deleted ${item[index].carModel} from Storage");
                                    setState(() {});

                                  },
                                  icon: const Icon(Icons.favorite_border),
                                ),
                              ),
                            ]),
                          ),
                        ));
                  } else {
                    return GridView.count(
                      crossAxisCount: 2,
                      children: List.generate(
                        10,
                        (index) => Container(
                          margin: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
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
