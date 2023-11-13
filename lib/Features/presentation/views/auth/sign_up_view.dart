

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Core/const/app_message.dart';
import 'package:shop_app/Core/resources/assets_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Core/widgets/custom_textformfield.dart';
import 'package:shop_app/Features/presentation/views/Home/main_home.dart';
import 'package:shop_app/Features/presentation/views/auth/login_view.dart';
import '../../../../Core/resources/color_manager.dart';
import '../../bloc/auth/auth-states.dart';
import '../../bloc/auth/auth_cubit.dart';
import 'package:get/get.dart';
class SignUpView extends StatelessWidget {
  const SignUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (BuildContext context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {


              if(state is SignUpSuccessState){

                appMessage(text: 'تم انشاء الحساب بنجاح');

                Get.offAll(const MainHome());

              }

              if(state is SignUpErrorState){

                appMessage(text: 'حدث خطا');

              }

            },
            builder: (context, state) {
              AuthCubit cubit = AuthCubit.get(context);
              return Scaffold(
                backgroundColor:ColorsManager.primary2,
                appBar: AppBar(
                  elevation: 0.0,
                  toolbarHeight: 50,
                  backgroundColor:ColorsManager.primary4,
                  leading: InkWell(child: const Icon(Icons.arrow_back_ios,size: 27,color:Colors.white),
                    onTap:(){
                      Get.back();
                    },
                  ),
                ),
                body:SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(0.0),
                    child: Column(
                      children:  [
                        //const SizedBox(height: 11,),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          color: ColorsManager.primary4,
                          child: SizedBox(
                            height: 240,
                            child: Image.asset(AssetsManager.Logo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(hint: 'البريد الاكتروني',
                              obx: false, ontap: (){},
                              type: TextInputType.emailAddress, obs:false,
                              color:ColorsManager.black
                              , controller: cubit.emailController),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(hint: 'الاسم',
                              obx: false, ontap: (){}, type: TextInputType.text,
                              obs:false, color:ColorsManager.black
                              , controller: cubit.nameController),
                        ),
                        const SizedBox(height: 10,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomTextFormField(hint: 'كلمة المرور',
                              obx: true, ontap: (){},
                              type: TextInputType.visiblePassword,
                              obs:true, color:ColorsManager.black
                              , controller: cubit.passController),
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(text: 'انشاء حساب', onPressed: (){
                          cubit.userSignUp();
                          }, color1: ColorsManager.primary, color2:Colors.white),
                        const SizedBox(height: 34,),
                        InkWell(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Custom_Text(text: 'لدي حساب بالفعل  ؟ ',fontSize:17,color:ColorsManager.primary,),
                              SizedBox(width: 30,),
                              Custom_Text(text: 'تسجيل دخول ',fontSize:15,color:Colors.grey,),
                            ],
                          ),
                          onTap:(){
                            Get.to(const LoginView());
                          },
                        ),
                        const SizedBox(height: 40,),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
