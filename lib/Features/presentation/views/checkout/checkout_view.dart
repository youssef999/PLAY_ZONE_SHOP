import 'package:clipboard/clipboard.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:random_string/random_string.dart';
import 'package:shop_app/Core/const/app_message.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Core/widgets/custom_textformfield.dart';
import 'package:shop_app/Features/data/models/cart_model.dart';
import 'package:shop_app/Features/presentation/views/checkout/checout_complete.dart';
import '../../bloc/cart/cart_cubit.dart';
import '../../bloc/cart/cart_states.dart';
import 'order_done_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class CheckOutView extends StatelessWidget {
  List <CartProductModel> order;
  String total;



  CheckOutView(
      {super.key, required this.order,
        required this.total});


  TextEditingController walletNum=TextEditingController();
  TextEditingController email=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController name=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (BuildContext context) => CartCubit()..getAllProduct(),
        child: BlocConsumer<CartCubit, CartStates>(
            listener: (context, state) {},
            builder: (context, state) {

        CartCubit cubit = CartCubit.get(context);
        final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor:ColorsManager.primary,
        leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
          onTap:(){
            Get.back();
          },

        ),
      ),
      // bottomNavigationBar: CustomButton(
      //   text: 'تاكيد الطلب' + "   " + "$total",
      //   color1: ColorsManager.primary,
      //   color2: ColorsManager.primary2,
      //   onPressed: () {
      //     addOrderToFireBase();
      //     cubit.DeleteAll(order[0]);
      //   },
      // ),
      body: ListView(
        children: [

          const SizedBox(height: 14,),
          const Row(children: [
            SizedBox(width: 17,),
            Icon(Icons.circle,color:ColorsManager.primary,size: 24,),
            SizedBox(width: 33,),
            Custom_Text(text: 'بيانات عملية الدفع ',
              fontSize: 17,alignment:Alignment.topRight,
              color:Colors.black45,),
          ],),
          const SizedBox(height: 11,),
          const Custom_Text(text: 'قم بالتحويل علي هذا الرقم ',
          fontSize: 17,color:ColorsManager.black,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 11,),
          Row(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              const Custom_Text(text: '0303920202',
                fontSize: 17,color:ColorsManager.red,
                alignment: Alignment.center,
              ),
              const SizedBox(width: 22,),
              IconButton(onPressed: (){
                FlutterClipboard.copy('000qqw929')
                    .then(( value ) =>
                    print('copied'));
              },
                  icon: const Icon(Icons.copy,
                  color:ColorsManager.grey3,
                  ))
            ],
          ),
          const SizedBox(height: 14,),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const Custom_Text(text: 'رقم المحفطة',
                alignment:Alignment.center,
                ),
                const SizedBox(height: 7,),
                CustomTextFormField(hint: 'رقم المحفظة ',
                    obx: false
                    , ontap: (){}, type:TextInputType.number
                    , obs: false
                    , color: ColorsManager.black
                    , controller: walletNum),
                const SizedBox(height: 14,),
                const Custom_Text(text: 'الاسم ',
                  alignment:Alignment.center,
                ),
                const SizedBox(height: 7,),
                CustomTextFormField(hint: 'الاسم ',
                    obx: false
                    , ontap: (){}, type:TextInputType.number
                    , obs: false
                    , color: ColorsManager.black
                    , controller: name),
                const SizedBox(height: 11,),
                const Custom_Text(text: 'رقم الهاتف',
                  alignment:Alignment.center,
                ),
                const SizedBox(height: 7,),
                CustomTextFormField(hint: 'رقم الهاتف',
                    obx: false
                    , ontap: (){}, type:TextInputType.phone
                    , obs: false
                    , color: ColorsManager.black
                    , controller: phone),
                const SizedBox(height: 20,),
                CustomButton(text: 'التالي',
                    onPressed:(){


                      Get.to(CheckOutCompleteView(
                        total: cubit.totalPrice.toString(),
                        order: cubit.cartProductModel,
                        name: name.text,
                        phone: phone.text,
                        walletNum: walletNum.text,
                      ));

                    }, color1: ColorsManager.primary
                    , color2: ColorsManager.white)
              ],
            ),
          ),

         // OrderWidget(order: order, total: total)
        ],
      ),
    );

            }));

}


  Widget LocationWidget(
      {required String address, required String phone, required String home, required String floor}) {
    return Card(
      color: Colors.grey[300],
      child: Column(
        children: [
          const SizedBox(height: 11,),
          const Custom_Text(text: 'بيانات العنوان الخاص بك',
            alignment: Alignment.center,
            fontSize: 21,
            color: ColorsManager.primary,),
          const SizedBox(height: 11,),
          const Custom_Text(text: 'العنوان',
            alignment: Alignment.center,
            fontSize: 16,
            color: ColorsManager.primary,),
          Custom_Text(text: address,
            alignment: Alignment.center,
            fontSize: 16,
            color: Colors.grey,),
          const SizedBox(height: 11,),
          const Custom_Text(text: 'رقم المبني',
            alignment: Alignment.center,
            fontSize: 16,
            color: ColorsManager.primary,),
          Custom_Text(text: home,
            alignment: Alignment.center,
            fontSize: 16,
            color: Colors.grey,),
          const SizedBox(height: 11,),
          const Custom_Text(text: 'رقم الهاتف',
            alignment: Alignment.center,
            fontSize: 16,
            color: ColorsManager.primary,),
          Custom_Text(text: phone,
            alignment: Alignment.center,
            fontSize: 16,
            color: Colors.grey,),
          const SizedBox(height: 11,),
          const Custom_Text(text: 'رقم الطابق',
            alignment: Alignment.center,
            fontSize: 16,
            color: ColorsManager.primary,),
          Custom_Text(text: floor,
            alignment: Alignment.center,
            fontSize: 16,
            color: Colors.grey,),
          const SizedBox(height: 11,),
        ],
      ),
    );
  }

  Widget OrderWidget(
      {required List <CartProductModel> order, required String total}) {
    return SizedBox(
      height: 2100,
      child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: order.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                child: Row(
                  children: [
                    const SizedBox(height: 11,),
                    Column(
                      children: [
                        const SizedBox(height: 10,),
                        SizedBox(
                            width: 100,
                            child: Image.network(order[index].image
                                .toString())),
                        const SizedBox(height: 10,),

                        SizedBox(
                          width:170,
                          child: Wrap(
                              children:[
                                Center(
                                  child: Text(
                                      order[index].name.toString(),
                                      maxLines:2,
                                      style: GoogleFonts.tajawal(
                                        color:ColorsManager.primary,fontSize: 15,fontWeight: FontWeight.bold,
                                        textBaseline: TextBaseline.alphabetic,
                                      )
                                  ),
                                ),
                              ]
                          ),
                        ),

                        const SizedBox(height: 10,),
                      ],
                    ),
                    const SizedBox(height: 12,),
                    const SizedBox(width: 11,),
                    Column(
                      children: [
                        const Custom_Text(text: 'السعر ', fontSize: 18),
                        Custom_Text(text: order[index].price.toString(),
                            alignment: Alignment.center,
                            fontSize: 16),
                      ],
                    ),
                    const SizedBox(width: 11,),
                    Custom_Text(text: " X ${order[index].quantity}",
                        alignment: Alignment.center,
                        fontSize: 16),
                  ],
                ),
              ),
            );
          }),
    );
  }
  String generateRandomString(int length) {
    return randomAlphaNumeric(length);
  }
  addOrderToFireBase() async {

    final box=GetStorage();
    String email=box.read('email')??"Guest";
    String name=box.read('name')??'Guest';
    String currency=box.read('currency')??'';
    DateTime now = DateTime.now();
    String currentDate = '${now.year}-${now.month}-${now.day}';
    String currentTime = '${now.hour}:${now.minute}:${now.second}';
    List<String>orderNames=[];
    List<String>orderQuant=[];
    List<String>orderPrice=[];
    List<String>orderImage=[];
    String orderId = generateRandomString(18);
    for(int i=0;i<order.length;i++){
      orderNames.add(order[i].name!);
    }
    for(int i=0;i<order.length;i++){
      orderImage.add(order[i].image!);
    }
    for(int i=0;i<order.length;i++){
      orderQuant.add(order[i].quantity.toString());
    }

    for(int i=0;i<order.length;i++){
      orderPrice.add(order[i].price.toString());
    }


    await FirebaseFirestore.instance.collection('orders').add({
      'order_id':orderId,
      'order': [
        for(int i=0;i<order.length;i++)
        {
          "name":orderNames[i],
          "quant":orderQuant[i],
          "price":orderPrice[i],
          "image":orderImage[i]
        }
      ],
      'user_name': name,
      'user_email': email,
       'total':total,
      'date':currentDate,
      'time':currentTime,
      'status':'waiting',
      'currency':currency
    }).then((value) {
      appMessage(text: 'تم اضافة طليك بنجاح');

      Get.offAll(const OrderDoneView());
    });
  }
}

