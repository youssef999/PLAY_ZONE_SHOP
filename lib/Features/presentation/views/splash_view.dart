import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/Core/resources/assets_manager.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Features/presentation/views/Home/main_home.dart';
import 'Country/country_view.dart';


class SplashView extends StatefulWidget
 {
  const SplashView({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();

 }
class _MySplashScreenState extends State<SplashView>
{
  startTimer()
  {
final box=GetStorage();

String country=box.read('country')??"x";



    Timer(const Duration(seconds: 6), () async
    {
      if( country!='x'){

        Get.offAll(const  MainHome());
      }

      else{
        Get.offAll(const  MainHome());
      }

    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  Widget build(BuildContext context)
  {
    return
      Scaffold(
        backgroundColor: ColorsManager.primary,
          appBar: AppBar(
            elevation: 0.0,
            toolbarHeight: 0,
            backgroundColor:ColorsManager.white,
          ),
          body:
          Container(
            color:    ColorsManager.primary,
            child:   Center(
              child: Container(
                  color:ColorsManager.white,
                  height: 290, child:
            SizedBox(
                 height: 320,
                  child: Image.asset(AssetsManager.Logo2,fit:BoxFit.fill,))),
            ),
          )
      );
  }
}