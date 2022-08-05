import 'package:flutter/material.dart';
import 'package:task_project/model/company_item.dart';
import 'package:task_project/screens/about_screen.dart';
import 'package:task_project/screens/cached_screen.dart';
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
        title: const Text("Cars"),
        centerTitle: true,
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (ctx){
              return CachedScreen();
            }));
          }, icon: Icon(Icons.favorite_rounded))
        ],
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
                    return GridView.count(
                        physics: const BouncingScrollPhysics(),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        children: List.generate(
                          item.length,
                          (index) => GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                                return SingleItem(productId: item[index].id, repository: apiProvider, isHome: true,);
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
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(

                                      child: Image.network(item[index].logo)),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(item[index].carModel),
                                      Text(item[index].establishedYear.toString())
                                    ],
                                  ))
                                ],
                              ),
                            ),
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
