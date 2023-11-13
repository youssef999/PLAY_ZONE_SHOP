import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:shop_app/Core/const/app_message.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Features/data/models/cart_model.dart';
import 'package:shop_app/Features/presentation/views/auth/login_view.dart';

import '../../../../Core/resources/color_manager.dart';
import '../../bloc/cart/cart_cubit.dart';
import '../../bloc/cart/cart_states.dart';
import 'product_video_view.dart';


class ProductDetailsView extends StatelessWidget {

  DocumentSnapshot posts;
  String tag;
  ProductDetailsView({Key? key,required this.posts,required this.tag}) : super(key: key);


  List data=[];

  @override
  Widget build(BuildContext context) {


 //   String currency=posts['currency'];



    return  BlocProvider(
        create: (BuildContext context)
        => CartCubit()..fetchDataFromFirestore(),
        child: BlocConsumer<CartCubit, CartStates>(
            listener: (context, state) {},
            builder: (context, state) {

              CartCubit cubit = CartCubit.get(context);
              return Scaffold(
                backgroundColor:Colors.grey[100],
                appBar: AppBar(
                  toolbarHeight: 50,
                  backgroundColor:ColorsManager.primary,
                  leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
                    onTap:(){
                      Get.back();
                    },

                  ),
                ),
                body:SingleChildScrollView(
                  child: Column(
                    children:  [

                     // CarsImages(posts['image']),
                      Container(
                        child:Image.network(posts['image'],
                        fit:BoxFit.contain,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(22),
                            color:ColorsManager.primary2,
                            shape: BoxShape.rectangle
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                SizedBox(
                                  width:184,
                                  child: Wrap(
                                      children:[
                                        Text(
                                            posts['name'].toString(),
                                            style: GoogleFonts.tajawal(
                                              color:ColorsManager.primary,fontSize: 21,fontWeight: FontWeight.bold,
                                              textBaseline: TextBaseline.alphabetic,
                                            )
                                        ),
                                      ]
                                  ),
                                ),

                                // Custom_Text(text: posts['name'],
                                //     color:ColorsManager.primary
                                //     ,fontSize:26,alignment:Alignment.center,),

                                const SizedBox(width: 60,),

                                ((cubit.data.contains(posts['productid'])==true && cubit.isFav2==false)
                                    || (cubit.isFav ==true&& cubit.isFav2==false))?

                                InkWell (child: const Icon(Icons.favorite
                                  ,size:33
                                  ,color:Colors.redAccent,),
                                  onTap:() {

                                    cubit.DeleteFromFav(posts: posts);

                                  },

                                ):  InkWell(child: const Icon(Icons.favorite_border,size:33,color:Colors.red,),
                                  onTap:(){

                                    cubit.addToFav(posts: posts);

                                  },
                                ),


                              ],
                            ),
                            const SizedBox(height: 20,),
                            // RatingBar.builder(
                            //   itemSize:17,
                            //   ignoreGestures: true,
                            //   initialRating:double.parse(  posts['rate'].toString()),
                            //   minRating: 1,
                            //   direction: Axis.horizontal,
                            //   allowHalfRating: true,
                            //   itemCount: 5,
                            //
                            //   itemPadding:
                            //   const EdgeInsets.symmetric(horizontal: 1.0),
                            //   itemBuilder: (context, _) => const Icon(
                            //     Icons.star,
                            //     color: Colors.amber,
                            //   ),
                            //   unratedColor:Colors.grey,
                            //   onRatingUpdate: (rating) {
                            //
                            //   },
                            // ),
                            const SizedBox(height: 20,),
                            Container(
                              decoration:BoxDecoration(
                                  color:ColorsManager.primary2,
                                  borderRadius:BorderRadius.circular(31)
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Custom_Text(text: posts['des'],fontSize:15,alignment:Alignment.center,
                                  color:ColorsManager.black
                                ),
                              ),
                            ),
                            const SizedBox(height: 20,),
                            const Divider(
                              endIndent:0.8,
                              thickness: 0.7,
                            ),
                            const SizedBox(height: 10,),
                            Row(
                              children: [
                                const SizedBox(width: 60,),
                                Custom_Text(text:" ${posts['price']}  ",
                                  color:ColorsManager.primary,
                                  fontSize:22,alignment:Alignment.center,),

                                const SizedBox(width:30,),

                                Row(
                                  children: [
                                    InkWell(
                                      child: const CircleAvatar
                                        (
                                          backgroundColor: ColorsManager.primary,
                                          child: Center(child: Icon(Icons.minimize_sharp,size: 22,color:ColorsManager.primary2,))),
                                      onTap:(){
                                        cubit.decreaseQuant();
                                      },
                                    ),
                                    const SizedBox(width:30,),
                                    Custom_Text(text:cubit.quant.toString(),
                                      color:ColorsManager.primary,
                                      fontSize:22,alignment:Alignment.center,),
                                    const SizedBox(width:30,),
                                    InkWell(
                                      child: const CircleAvatar
                                        (
                                          backgroundColor: ColorsManager.primary,
                                          child: Center(child: Icon(Icons.add,size: 22,color:ColorsManager.primary2,))),

                                      onTap:(){
                                        cubit.increaseQuant(posts['quant']);
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 12,),
                            const SizedBox(height: 10,),
                            CustomButton(text: 'اضافة الي السلة ', onPressed:(){
                              final box=GetStorage();
                              String email=box.read('email')??'x';

                              if(email=='x'){
                                appMessage(text: 'قم بتسجيل الدخول اولا');
                                Get.to(const LoginView());

                              }else{
                                cubit.dialogAndAdd(
                                  cartProductModel:CartProductModel(
                                    productQuant: posts['quant'],
                                    name: posts['name'],
                                    image: posts['image'],
                                    price: posts['price'].toString(),
                                    quantity: cubit.quant,
                                    productId: posts['productid'],
                                    color: '',
                                    size:'',
                                  ),
                                  productId:posts['productid'],
                                );
                              }
                            }, color1: ColorsManager.primary, color2: ColorsManager.primary2),
                            const SizedBox(height: 50,),
                          ],
                        ),
                      ),


                    ],
                  ),
                ),
              );
            }));
  }



  // Widget CarsoulImage(BuildContext context,List images){
  //   return CarouselSlider(
  //     options: CarouselOptions(
  //       aspectRatio: 16/9,
  //       viewportFraction: 0.8,
  //       initialPage: 0,
  //       enableInfiniteScroll: true,
  //       reverse: false,
  //       autoPlay: false,
  //       autoPlayInterval: const Duration(seconds: 3),
  //       autoPlayAnimationDuration: const Duration(milliseconds: 800),
  //       autoPlayCurve: Curves.fastOutSlowIn,
  //       enlargeCenterPage: true,
  //       enlargeFactor: 0.3,
  //       //onPageChanged: callbackFunction,
  //       scrollDirection: Axis.horizontal,
  //     ),
  //     items: images.map((i) {
  //       return Builder(
  //         builder: (BuildContext context) {
  //           return Padding(
  //             padding: const EdgeInsets.only(left: 0.0, right: 0),
  //             child: Container(
  //                 width: MediaQuery.of(context).size.width,
  //                 margin: const EdgeInsets.symmetric(horizontal: 2.0),
  //                 decoration: const BoxDecoration(color: ColorsManager.primary2),
  //                 child: Image.network(i)),
  //           );
  //         },
  //       );
  //     }).toList(),
  //   );
  // }

  Widget CarsImages(List images){

    List<Color>colors=[];
    if(images.length==1){
      colors = [
        Colors.white,
      ];
    }
    if(images.length==2){
      colors = [
        Colors.white,
        Colors.white,
        // Colors.yellow,
        // Colors.green,
        // Colors.blue,
        // Colors.indigo,
        // Colors.purple,
      ];
    }
    if(images.length==3){
      colors = [
        Colors.white,
        Colors.white,
        Colors.white,

      ];
    }
    if(images.length==4){
      colors = [
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,

      ];
    }
    if(images.length==5){
      colors = [
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,

      ];
    }
    if(images.length==6){
      colors = [
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,
        Colors.white,

      ];
    }

    GlobalKey _sliderKey = GlobalKey();

    return SizedBox(
      height: 500,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          SizedBox(
            height: 500,
            child: CarouselSlider.builder(
                key: _sliderKey,
                unlimitedMode: true,
                slideBuilder: (index) {

                  return Container(
                      height: 200,
                      alignment: Alignment.center,
                      color: colors[index],
                      child:Hero(
                          tag: tag,
                          child: Image.network(images[index]))
                  );
                },
                slideTransform: const CubeTransform(),
                slideIndicator: CircularSlideIndicator(
                  padding: const EdgeInsets.only(bottom: 32),
                ),
                itemCount: colors.length),
          ),
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 32),
          //   child: Align(
          //     child: ConstrainedBox(
          //       constraints: const BoxConstraints(minWidth: 240, maxWidth: 600),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           IconButton(
          //             iconSize: 48,
          //             icon: const Icon(Icons.skip_previous),
          //             onPressed: () {
          //            //   _sliderKey.currentState!.previousPage();
          //             },
          //           ),
          //           IconButton(
          //             iconSize: 64,
          //             icon: Icon(
          //               _isPlaying
          //                   ? Icons.pause_circle_outline
          //                   : Icons.play_circle_outline,
          //             ),
          //             onPressed: () {
          //               // setState(
          //               //       () {
          //               //     _isPlaying = !_isPlaying;
          //               //     _sliderKey.currentState.setPlaying(_isPlaying);
          //               //   },
          //               // );
          //             },
          //           ),
          //           IconButton(
          //             iconSize: 48,
          //             icon: const Icon(Icons.skip_next),
          //             onPressed: () {
          //            //   _sliderKey.currentState.nextPage();
          //             },
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
// Widget ImagesWidget(BuildContext context){
//
//
//   return  BlocProvider(
//       create: (BuildContext context) => CartCubit()..getImageData(posts),
//       child: BlocConsumer<CartCubit, CartStates>(
//           listener: (context, state) {},
//           builder: (context, state) {
//
//             CartCubit cubit = CartCubit.get(context);
//   return
//
//     Stack(
//       children: [
//
//
//
//         Hero(
//             tag: tag,
//             child: Container(
//                            decoration: BoxDecoration(
//                                borderRadius:BorderRadius.circular(21),
//                                color:Colors.grey[100]
//                            ),
//                            width: MediaQuery.of(context).size.width,
//                 height: 450,
//                 child: Image.network(cubit.image2,
//                 fit: BoxFit.cover,
//                 ))),
//
//         (cubit.index<cubit.image.length-1)?
//         Positioned(
//             left: 12,
//             bottom :65,
//             child:InkWell(
//               child: const CircleAvatar(
//                   radius: 40,
//                   backgroundColor:ColorsManager.primary,
//                   child: Icon(Icons.arrow_circle_left_sharp,size: 55,color:Colors.redAccent)),
//               onTap:(){
//                 cubit. buildImageWidget(posts);
//               },
//             )):const SizedBox(height: 1,),
//
//
//         (cubit.index!=0)?
//         Positioned(
//             right: 12,
//             bottom :65,
//             child:InkWell(
//               child:const CircleAvatar(
//                   radius: 40,
//                   backgroundColor:ColorsManager.primary,
//                   child: Icon(Icons.arrow_circle_right_sharp,size: 55,color:Colors.redAccent)),
//               onTap:(){
//                 cubit. returnImage(posts);
//               },
//             )): const SizedBox(),
//       ],
//
//     );
//
// }));
//
// }
}