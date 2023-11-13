
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
 import 'package:flutter/material.dart';
import 'package:shop_app/Core/resources/assets_manager.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Features/presentation/views/auth/login_view.dart';
import '../splash_view.dart';
import 'change_password_view.dart';
import 'user_orders_view.dart';

class UserProfileView extends StatelessWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

final box=GetStorage();
String email=box.read('email')??"x";
String name=box.read('name')??"x";

if(email=='x'){
  return Scaffold(
    backgroundColor: ColorsManager.white,
    appBar:AppBar(
      toolbarHeight: 2,
      elevation: 0.0,
      backgroundColor:ColorsManager.primary4,
    ),
    body:Center(
      child: Column(
        children: [
         // const SizedBox(height: 32,),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 340,
            child:Image.asset(AssetsManager.Logo,
            fit: BoxFit.fill,
            ),),
          const SizedBox(height: 70,),

          CustomButton(text:'تسجيل دخول', onPressed: (){

            Get.to(const LoginView());

          }, color1:ColorsManager.primary, color2: ColorsManager.white)

        ],
      ),
    ),
  );
}else{
  return Scaffold(
    backgroundColor:Colors.white,
    appBar: AppBar(
      toolbarHeight: 2,
      backgroundColor:ColorsManager.primary,
    ),


    body:SingleChildScrollView(
      child: Column(
        children: [
        //  const SizedBox(height: 21,),
          Container(
            width: MediaQuery.of(context).size.width,
            color: ColorsManager.primary,
            child: SizedBox(
              height: 270,
              child:Image.asset(AssetsManager.Logo,
              fit:BoxFit.fill,
              ) ,),
          ),
          const SizedBox(height: 11,),
          (name!='x')?
          Custom_Text(text:name,fontSize: 22,alignment:Alignment.center,color:ColorsManager.primary,):const SizedBox(),
          const SizedBox(height: 30,),
          Row(
            children: [
              const SizedBox(width: 20,),
              const Icon(Icons.email,size: 28,color:ColorsManager.primary3,),
              const SizedBox(width: 20,),
              Custom_Text(text: email,
                fontSize: 20,
                alignment:Alignment.center,
                color:ColorsManager.TextColorDark,)
            ],
          ),
          const SizedBox(height: 30,),
          InkWell(
            child: const Row(
              children: [
                SizedBox(width: 20,),
                Icon(Icons.on_device_training_sharp,size: 28,color:ColorsManager.primary3,),
                SizedBox(width: 20,),
                Custom_Text(text: ' طلباتي السابقة  ',fontSize: 20,alignment:Alignment.center,color:ColorsManager.TextColorDark,)
              ],
            ),
            onTap:(){
              Get.to(const UserOrdersView());
            },
          ),
          const SizedBox(height: 30,),
          InkWell(
            child: const Row(
              children: [
                SizedBox(width: 20,),
                Icon(Icons.password,size: 28,color:ColorsManager.primary3,),
                SizedBox(width: 20,),
                Custom_Text(text: 'تغير كلمة المرور ',fontSize: 20,alignment:Alignment.center,color:ColorsManager.TextColorDark,)
              ],
            ),
            onTap:(){
              Get.to(const ChangePasswordView());
            },
          ),
          const SizedBox(height: 30,),
          InkWell(
            child: const Row(
              children: [
                SizedBox(width: 20,),
                Icon(Icons.delete,size: 28,color:ColorsManager.primary3,),
                SizedBox(width: 20,),
                Custom_Text(text: 'حذف الحساب ',fontSize: 20,alignment:Alignment.center,color:ColorsManager.TextColorDark)
              ],
            ),
            onTap:(){
              showDialog();
            },
          ),
        ],
      ),
    ),


  );

}

  }

  showDialog(){
    return  Get.defaultDialog(
      title: "متاكد من حذف حسابك الان ؟ ",
      middleText: "",
      onConfirm: () {
        DeleteUserAccount();
        Get.back();
      },
      onCancel: () {
        Get.back();
      },
      textCancel: "لا",
      textConfirm: "نعم",
      cancelTextColor: Colors.black,
      buttonColor: ColorsManager.primary,
      confirmTextColor: Colors.white,
      barrierDismissible: true,
      //middleText: "Hello world!",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.white),
    );
  }

  DeleteUserAccount(){
    final box=GetStorage();
    box.remove('email');
    User? currentUser = FirebaseAuth.instance.currentUser;
    currentUser!.delete();
    Get.offAll(const SplashView());

  }

}
