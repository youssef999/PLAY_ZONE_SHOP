import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Features/data/models/cart_model.dart';
import 'package:shop_app/Features/presentation/bloc/cart/cart_cubit.dart';
import 'package:shop_app/Features/presentation/bloc/cart/cart_states.dart';
import 'package:shop_app/Features/presentation/views/checkout/checkout_view.dart';

import '../../../../Core/widgets/Custom_Text.dart';
import '../../../../Core/widgets/Custom_button.dart';
import '../location/location_form_view.dart';
import '../location/prev_location.dart';

class CartView extends StatefulWidget {
  const CartView({Key? key}) : super(key: key);

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  var locationMessage = "";
  String? country = '';
  String? city = '';
  String? address = '';



  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (BuildContext context) => CartCubit()..getAllProduct(),
        child: BlocConsumer<CartCubit, CartStates>(
            listener: (context, state) {},
            builder: (context, state) {
              CartCubit cubit = CartCubit.get(context);

              final box=GetStorage();

       String currency=box.read('currency')??"";

              return Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  backgroundColor: ColorsManager.primary,
                  toolbarHeight: 1,
                ),
                backgroundColor: Colors.white,
                body: cubit.cartProductModel.isEmpty
                    ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset("assets/images/cart2.png"),
                    const SizedBox(
                      height: 5,
                    ),
                   const Custom_Text(
                      text: 'السلة فارغة ',
                      fontSize: 35,
                      color: ColorsManager.primary,
                      alignment: Alignment.center,
                    )
                  ],
                )
                    : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 12, right: 12, top: 25),
                            child: Container(
                              decoration:BoxDecoration(
                                border:Border.all(color:Colors.black),
                                borderRadius:BorderRadius.circular(16)
                              ),
                                height: 152,
                                child: Row(
                                  children: [
                                    const SizedBox(width: 5,),
                                    SizedBox(
                                      width: 135,
                                      height:135,
                                      child: Image.network(
                                          cubit.cartProductModel[index]
                                              .image
                                              .toString(),
                                          fit: BoxFit.fill),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 20),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 17,),
                                          SizedBox(
                                            width:110,
                                            child: Text(
                                              cubit.cartProductModel[index]
                                                  .name
                                                  .toString(),
                                              maxLines: 1,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight:
                                                  FontWeight.bold),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            "${cubit.cartProductModel[index].price} $currency",
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight:
                                                FontWeight.w600,
                                                color: ColorsManager
                                                    .primary),
                                          ),
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          Container(
                                            width: 160,
                                            color: Colors.grey.shade200,
                                            height: 53,
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .center,
                                              children: [
                                                InkWell(
                                                    onTap: () {

                                                      cubit
                                                          .increaseQuantity(
                                                          index,
                                                          cubit.cartProductModel[index].productQuant!
                                                      );
                                                    },
                                                    child: const CircleAvatar(
                                                      radius: 17,
                                                      backgroundColor:Colors.greenAccent,
                                                      child: Icon(
                                                        Icons.add,
                                                        color: ColorsManager
                                                            .white,
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                Custom_Text(
                                                  alignment:
                                                  Alignment.center,
                                                  text: cubit
                                                      .cartProductModel[
                                                  index]
                                                      .quantity
                                                      .toString(),
                                                  fontSize: 20,
                                                ),
                                                const SizedBox(
                                                  width: 10,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      cubit
                                                          .decreaseQuantity(
                                                          index);
                                                    },
                                                    child: const CircleAvatar(
                                                      backgroundColor:Colors.red,
                                                      radius: 17,
                                                      child: Padding(
                                                        padding: EdgeInsets.only(bottom:12.0),
                                                        child: Icon(
                                                          Icons.minimize,
                                                          color:
                                                          ColorsManager
                                                              .white,
                                                        ),
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                InkWell(
                                                    onTap: () {
                                                      cubit.DeleteProducts(
                                                          CartProductModel(
                                                              productQuant: cubit.cartProductModel[index].productQuant,
                                                              name: cubit
                                                                  .cartProductModel[
                                                              index]
                                                                  .name,
                                                              image: cubit
                                                                  .cartProductModel[
                                                              index]
                                                                  .image,
                                                              price: cubit
                                                                  .cartProductModel[
                                                              index]
                                                                  .price,
                                                              quantity: cubit
                                                                  .cartProductModel[
                                                              index]
                                                                  .quantity,
                                                              productId: cubit
                                                                  .cartProductModel[
                                                              index]
                                                                  .productId),
                                                          cubit
                                                              .cartProductModel[
                                                          index]
                                                              .productId!);
                                                    },
                                                    child: const Icon(Icons
                                                        .delete_outline))
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                          );
                        },
                        itemCount: cubit.cartProductModel.length,
                        separatorBuilder: (context, index) =>
                        const SizedBox(
                          height: 5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text(
                                "الاجمالي ",
                                style: TextStyle(
                                    fontSize: 22, color: Colors.grey),
                              ),
                              const SizedBox(
                                height: 15,
                              ),
                              Custom_Text(
                                text: "${cubit.totalPrice} $currency",
                                color: ColorsManager.black,
                                fontSize: 23,
                                fontWeight:FontWeight.w500,
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: SizedBox(
                                height: 70,
                                width: 120,
                                child: CustomButton(
                                  text: "التالي",
                                  onPressed: () {
                                    Get.to(CheckOutView(
                                      total: cubit.totalPrice.toString(),
                                      order: cubit.cartProductModel,
                                    ));



                                  },
                                  color1: ColorsManager.primary,
                                  color2: ColorsManager.primary2,
                                ),
                              ))
                        ],
                      ),
                    )
                  ],
                ),
              );
            }));
  }

// void currentLocation() async {
//   position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high);
//   latLng = LatLng(position.latitude, position.longitude);
//   var lastposition = await Geolocator.getLastKnownPosition();
//   lat = position.latitude;
//   long = position.longitude;
//   print(lastposition);
//   print("lll=$locationMessage");
//   print(
//     "ooo=${position.latitude}",
//   );
//   print(
//     "yyy=${position.longitude}",
//   );
//
//   setState(() {
//     locationMessage = "$position";
//     lat = position.latitude;
//     long = position.longitude;
//   });
// }
//
// Future<void> getData() async {
//   bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     appMessage(text: 'Location service disapled');
//   }
//   LocationPermission permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//   }
//
//   print("HERE");
//   Future.delayed(const Duration(seconds: 4)).then((value) async {
//     try {
//       // emit(GetLocationLoadingState());
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best,
//       );
//
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         position.latitude,
//         position.longitude,
//       );
//       Placemark placemark = placemarks.first;
//       // print(placemark);
//       // print(position.longitude);
//       setState(() {
//         lat = position.latitude;
//         long = position.longitude;
//         // emit(GetLocationSuccessState());
//         country = placemark.country!;
//         city = placemark.locality!;
//       });
//       // print(position.latitude);
//
//       address = placemark.street.toString();
//       //   locatate = true;
//       appMessage(text: 'تم تحديد موقعك بنجاح');
//       // emit(GetLocationSuccessState());
//     } catch (e) {
//       print(e);
//       appMessage(text: '$e');
//     }
//   });
// }
}