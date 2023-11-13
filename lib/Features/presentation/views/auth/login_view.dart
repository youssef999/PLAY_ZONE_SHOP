
import 'package:get/get.dart';
  import 'package:flutter/material.dart';
  import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/Core/resources/assets_manager.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Core/widgets/Custom_Text.dart';
import 'package:shop_app/Core/widgets/Custom_button.dart';
import 'package:shop_app/Core/widgets/custom_textformfield.dart';
import 'package:shop_app/Features/presentation/views/auth/sign_up_view.dart';
import '../../../../Core/const/app_message.dart';
import '../../bloc/auth/auth-states.dart';
import '../../bloc/auth/auth_cubit.dart';
import '../Home/main_home.dart';
import 'forgot_pass_view.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
        create: (BuildContext context) => AuthCubit(),
        child: BlocConsumer<AuthCubit, AuthStates>(
            listener: (context, state) {

              if(state is LoginSuccessState){
                appMessage(text: 'تم تسجيل الدخول بنجاح');
                Get.offAll(const MainHome());
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
                      Container(
                          width: MediaQuery.of(context).size.width,
                       color: ColorsManager.primary4,
                          child: SizedBox(
                            height: 240,
                            child: Image.asset(AssetsManager.Logo,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomTextFormField(hint: 'البريد الاكتروني',
                              obx: false, ontap: (){}, type: TextInputType.emailAddress, obs:false,
                              color:ColorsManager.black
                              , controller: cubit.emailController),
                        ),
                        const SizedBox(height: 5,),
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: CustomTextFormField(hint: 'كلمة المرور',
                              obx: true, ontap: (){},
                              type: TextInputType.visiblePassword, obs:true
                              , color:ColorsManager.black
                              , controller: cubit.passController),
                        ),
                        const SizedBox(height: 20,),
                        CustomButton(text: 'تسجيل دخول', onPressed: (){
                          cubit.userLogin();
                        }, color1: ColorsManager.primary, color2:Colors.white),
                        
                        const SizedBox(height: 34,),
                        InkWell(
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Custom_Text(text: 'ليس لديك حساب ؟ ',fontSize:17,color:ColorsManager.primary,),
                              SizedBox(width: 30,),
                              Custom_Text(text: 'انشاء حساب جديد ',fontSize:15,color:Colors.grey,),
                            ],
                          ),
                          onTap:(){
                            Get.to(const SignUpView());
                          },
                        ),
                        const SizedBox(height: 34,),
                        //ForgotPassView
                        InkWell(
                          child: const Row(
                            children: [
                              SizedBox(width: 20,),
                              Custom_Text(text:  ' نسيت كلمة المرور ؟ ',
                              fontSize: 16,
                                alignment:Alignment.center,
                                color:Colors.grey,
                              ),
                              SizedBox(width: 22,),
                              Custom_Text(text: 'اعادة كلمة المرور ',
                                fontSize: 20,
                                alignment:Alignment.center,
                                color:ColorsManager.primary,
                              ),

                            ],
                          ),
                          onTap:(){

                            Get.to(const ForgotPassView());

                          },
                        )
                      ],
                    ),
                  ),
                ),
              );
            }));
  }
}
