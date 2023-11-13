
import 'package:get/get.dart';
 import 'package:flutter/material.dart';
 import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Core/const/app_message.dart';
import 'package:shop_app/Core/resources/assets_manager.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Core/widgets/custom_textformfield.dart';
import 'package:shop_app/Features/presentation/views/Home/main_home.dart';
import '../../bloc/auth/auth-states.dart';
import '../../bloc/auth/auth_cubit.dart';

class ChangePasswordView extends StatelessWidget {
  const ChangePasswordView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (BuildContext context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
        listener: (context, state) {

          if(state is ChangePassSuccessState){
            appMessage(text: 'تم تغير كلمة المرور بنجاح');
            Get.off(const MainHome());
          }
    },
    builder: (context, state) {

    AuthCubit cubit = AuthCubit.get(context);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 50,
        backgroundColor:ColorsManager.primary,
        leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
          onTap:(){
        Get.back();
          },

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
           // const SizedBox(height: 13,),
            Container(
              height: 300,
              color:ColorsManager.primary4,
        width: MediaQuery.of(context).size.width,
              child:Image.asset(AssetsManager.Logo,

              ),
            ),
            const SizedBox(height: 43,),
            CustomTextFormField(hint:'كلمة مرور جديدة', obx: true,
                ontap:(){}, type:TextInputType.text, obs: true, color:ColorsManager.primary, controller: cubit.passController),
            const SizedBox(height: 22,),
            CustomTextFormField(
                hint:'تاكيد كلمة المرور ', obx: true,
                ontap:(){}, type:TextInputType.text, obs: true, color:ColorsManager.primary, controller: cubit.checkPassController),
            const SizedBox(height: 20,),
            CustomButton(text:'تغيير كلمة المرور ', onPressed: (){
              cubit.changePassword();

            }, color1: ColorsManager.primary, color2:ColorsManager.primary2)
          ],
        ),
      ),
    );
    }));
  }
}
