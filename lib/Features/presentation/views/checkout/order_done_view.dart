
import 'package:get/get.dart';
 import 'package:flutter/material.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Features/presentation/views/Home/main_home.dart';


class OrderDoneView extends StatelessWidget {
  const OrderDoneView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor:ColorsManager.primary,
        leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
          onTap:(){
           Get.offAll(const MainHome());
          },
        ),
      ),
      body:Column(
        children:  [
          const SizedBox(height: 50,),
          const Icon(Icons.check_circle,size:121,color:Colors.lightGreen,),
          const SizedBox(height: 40,),
          const Custom_Text(text: 'تم تنفيذ طلبك بنجاح',fontSize: 30,alignment:Alignment.center),
          const SizedBox(height: 12,),
          CustomButton(text: 'انتقل للرئيسية', onPressed: (){
            Get.off(const MainHome());
          }, color1:ColorsManager.primary , color2: ColorsManager.primary2)
        ],
      ),
    );
  }
}
