
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shop_app/Core/app_const/const.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/resources/strings_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Core/widgets/drawer.dart';
import '../Cat/cat_products_view.dart';
import '../Search/search_view.dart';
import '../products/product_details_view.dart';
import 'package:get/get.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

 class _HomeViewState extends State<HomeView> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 100,
          elevation: 0.5,
          backgroundColor: ColorsManager.primary2,
          title:const Custom_Text(
            color: ColorsManager.black,fontWeight: FontWeight.w500,
            text: StringManger.AppName,alignment:Alignment.center,fontSize: 27,),
          iconTheme:const IconThemeData(color:ColorsManager.primary,size:30),
          actions:  [
            const SizedBox(width: 20,),
            InkWell(child: const Icon(Icons.search),
              onTap:(){
                Get.to(SearchView());
              },
            ),
            const SizedBox(width: 20,),
          ],
        ),
        drawer: MainDrawer(),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ProductWidget(),
        )

    );

  }
}

Widget ProductWidget() {
  return
    SizedBox(
      height: 22222,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 4,
                        childAspectRatio: 0.62),
                    //physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot posts = snapshot.data!.docs[index];
                      if (snapshot.data == null) {
                        return const CircularProgressIndicator();
                      }
                      return InkWell(
                        child: Hero(
                          tag: 'img$index',
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border:Border.all(color:ColorsManager.primary),
                                  borderRadius: BorderRadius.circular(10),
                                  color: ColorsManager.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                 // physics: const NeverScrollableScrollPhysics(),
                                  children: <Widget>[
                                    SizedBox(
                                      height: 120,
                                      //MediaQuery.of(context).size.height,
                                      width: MediaQuery.of(context).size.width,
                                      child: Image.network(
                                        posts['image'],
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width,
                                        height: 143,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          gradient: const LinearGradient(
                                              colors: [
                                               // Colors.grey[300]!,
                                                Colors.white,
                                                Colors.white,
                                                Colors.white
                                              ]
                                          ),

                                        ),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(3.0),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.only(left:8.0,right:3),
                                                        child: Wrap(
                                                          children: [
                                                            SizedBox(
                                                               width:120,
                                                              child: Custom_Text(
                                                                text: posts['name'],
                                                                fontSize: 17,
                                                                textAlign:TextAlign.center,
                                                                alignment:Alignment.topRight,
                                                                color: ColorsManager.black,
                                                                fontWeight:FontWeight.w800,
                                                                //  alignment: Alignment.topLeft,
                                                              ),
                                                            ),
                                                          ],

                                                        ),
                                                      ),
                                                      const SizedBox(height: 5,),

                                                      // Center(
                                                      //             child: RatingBar.builder(
                                                      //               itemSize: 14,
                                                      //               initialRating:
                                                      //               double.parse(posts['rate'].toString()),
                                                      //               minRating: 1,
                                                      //               direction: Axis.horizontal,
                                                      //               allowHalfRating: true,
                                                      //               itemCount: 5,
                                                      //               ignoreGestures: true,
                                                      //               itemPadding: const EdgeInsets.symmetric(
                                                      //                   horizontal: 1.0),
                                                      //               itemBuilder: (context, _) => const Icon(
                                                      //                 Icons.star,
                                                      //                 color: Colors.amber,
                                                      //               ),
                                                      //               unratedColor: Colors.grey,
                                                      //               onRatingUpdate: (rating) {
                                                      //                 print(rating);
                                                      //               },
                                                      //             ),
                                                      //           ),
                                                      const SizedBox(height: 3,),
                                                      Custom_Text(
                                                        text:
                                                        "${posts['price']}",
                                                        fontSize: 15,
                                                        color: ColorsManager.black,
                                                        fontWeight: FontWeight.w500,
                                                        alignment: Alignment.center,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                // SizedBox(width: 3,),


                                              ],
                                            ),
                           CustomButton(text: 'عرض المنتج'
                               , onPressed:(){

                             Get.to(ProductDetailsView(posts: posts
                                 ,  tag: 'img$index'));

                               }, color1: ColorsManager.primary
                               , color2: ColorsManager.white)
                                          ],
                                        ),
                                      ),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        onTap: () {
                          Get.to(
                              ProductDetailsView
                                (posts: posts,
                                  tag: 'img$index'));
                        },
                      );
                    });
            }
          }),
    );
}

Widget CatWidget() {
  return SizedBox(
    height: 140,
    child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('categories').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot posts = snapshot.data!.docs[index];
                    if (snapshot.data == null) {
                      return const CircularProgressIndicator();
                    }
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: ColorsManager.primary2),
                          //  color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: 100,
                              //height: 2,
                              child: Custom_Text(
                                text: posts['name'],
                                fontSize: 16,
                                alignment: Alignment.center,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        Get.to(CatProductsView(
                          cat: posts['name'],
                        ));
                      },
                    );
                  });
          }
        }),
  );
}
