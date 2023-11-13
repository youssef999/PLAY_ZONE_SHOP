import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:shop_app/Core/app_const/const.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Features/presentation/views/auth/login_view.dart';

class FavProductsView extends StatelessWidget {
  const FavProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 3,
        backgroundColor: ColorsManager.primary,
      ),
      body: ListView(
        children: [
          FavWidget(),
        ],
      ),
    );
  }
}

Widget FavWidget() {
  final box = GetStorage();
  String email = box.read('email') ?? 'x';


  if (email == 'x') {
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 350,
          child: Image.asset('assets/images/fav3.png'),
        ),
        const SizedBox(
          height: 20,
        ),
        const Custom_Text(
            text: 'قم بتسجيل الدخول',
            fontSize: 30,
            color: ColorsManager.primary,
            alignment: Alignment.center),
        const SizedBox(
          height: 20,
        ),
        CustomButton(
            text: 'تسجيل دخول',
            onPressed: () {
              Get.to(const LoginView());
            },
            color1: ColorsManager.primary,
            color2: ColorsManager.primary2)
      ],
    );
  } else {
    return SizedBox(
      height: 120990,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('fav')
              .where('user_email', isEqualTo: email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.data!.docs.isEmpty) {
                  return Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Image.asset('assets/images/fav3.png'),
                      const SizedBox(
                        height: 10,
                      ),
                      const Custom_Text(
                        text: 'لا توجد منتجات في المفضلة الان',
                        fontSize: 27,
                        alignment: Alignment.center,
                        color: ColorsManager.primary,
                      )
                    ],
                  );
                }
                return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot posts = snapshot.data!.docs[index];
                      //String currency=posts['currency'];
                      if (snapshot.data == null) {

                        return const CircularProgressIndicator();
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 120,
                              child: Image.asset('assets/images/fav.jpg'),
                            )
                          ],
                        );
                      }
                      return InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: ColorsManager.primary),
                            child: Row(
                              children: <Widget>[
                                SizedBox(
                                  height: 150,
                                  width: 200,
                                  child: Image.network(
                                    posts['image'],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                const SizedBox(
                                  width: 9,
                                ),
                                Column(
                                  children: [
                                    Custom_Text(
                                      text: posts['name'],
                                      fontSize: 14,
                                      alignment: Alignment.center,
                                      fontWeight: FontWeight.bold,
                                      color: ColorsManager.primary2,
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    // RatingBar.builder(
                                    //   itemSize: 14,
                                    //   initialRating: double.parse(
                                    //       posts['rate'].toString()),
                                    //   minRating: 1,
                                    //   direction: Axis.horizontal,
                                    //   allowHalfRating: true,
                                    //   itemCount: 5,
                                    //   ignoreGestures: true,
                                    //   itemPadding: const EdgeInsets.symmetric(
                                    //       horizontal: 1.0),
                                    //   itemBuilder: (context, _) => const Icon(
                                    //     Icons.star,
                                    //     color: Colors.amber,
                                    //   ),
                                    //   unratedColor: Colors.grey,
                                    //   onRatingUpdate: (rating) {
                                    //
                                    //   },
                                    // ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Custom_Text(
                                      text:
                                          "${posts['price']}" + "  ",
                                              //+ currency,
                                      fontSize: 15,
                                      alignment: Alignment.center,
                                      color: ColorsManager.primary2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                InkWell(
                                  child: const Icon(
                                    Icons.favorite,
                                    size: 24,
                                    color: Colors.black,
                                  ),
                                  onTap: () {
                                    DeleteFromFav(posts: posts);
                                  },
                                )
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          // Get.to (ProductDetailsView(
                          //   posts: posts,
                          //   tag: 'x'
                          // ));
                        },
                      );
                    });
            }
          }),
    );
  }
}

DeleteFromFav({required DocumentSnapshot posts}) async {
  final CollectionReference _updates =
      FirebaseFirestore.instance.collection('fav');
  await _updates
      .where('productid', isEqualTo: posts['productid'])
      .get()
      .then((snapshot) {
    snapshot.docs.last.reference.delete().then((value) {
      print("Deleted");
    });
  });
}
