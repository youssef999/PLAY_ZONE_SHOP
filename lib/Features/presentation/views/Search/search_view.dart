import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Features/presentation/views/Home/main_home.dart';

import '../products/product_details_view.dart';


class SearchView extends StatefulWidget {


  @override
  _PostsScreenState createState() => _PostsScreenState();
}

class _PostsScreenState extends State<SearchView> {

  GlobalKey<ScaffoldState> scaffoldState = GlobalKey();

  TextEditingController controller=TextEditingController();
  String searchData='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          toolbarHeight: 50,
          backgroundColor:ColorsManager.primary,
          leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
            onTap:(){
              Get.offAll(const MainHome());
            },
          ),
        ),
        body: ListView(children:  [
          const SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration:BoxDecoration(
                border:Border.all(color:ColorsManager.primary)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    hintText: 'ابحث هنا',
                    border:InputBorder.none,
                    icon:Icon(Icons.search,size:21,color:ColorsManager.primary,)
                  ),
                  onChanged:(value){
                    setState(() {
                      searchData=value;
                    });
                  },
                ),
              ),
            )
          ),
          const SizedBox(
            height: 20,
          ),
          SearchWidget()

        ]));
  }


  Widget SearchWidget() {
     return SizedBox(
       height: 190000,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('products')
              .where('name', isGreaterThanOrEqualTo: searchData)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: Text('Loading'));
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Text('Loading...');
              default:
                      return   GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 2,
                            mainAxisSpacing: 4,
                              childAspectRatio:0.62
                          ),
                          physics: const NeverScrollableScrollPhysics(),
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

                                                            Center(
                                                              child: RatingBar.builder(
                                                                itemSize: 14,
                                                                initialRating:
                                                                double.parse(posts['rate'].toString()),
                                                                minRating: 1,
                                                                direction: Axis.horizontal,
                                                                allowHalfRating: true,
                                                                itemCount: 5,
                                                                ignoreGestures: true,
                                                                itemPadding: const EdgeInsets.symmetric(
                                                                    horizontal: 1.0),
                                                                itemBuilder: (context, _) => const Icon(
                                                                  Icons.star,
                                                                  color: Colors.amber,
                                                                ),
                                                                unratedColor: Colors.grey,
                                                                onRatingUpdate: (rating) {
                                                                  print(rating);
                                                                },
                                                              ),
                                                            ),
                                                            const SizedBox(height: 3,),
                                                            Custom_Text(
                                                              text:
                                                              "${posts['price']}"+' '+posts['currency'],
                                                              fontSize: 16,
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

}