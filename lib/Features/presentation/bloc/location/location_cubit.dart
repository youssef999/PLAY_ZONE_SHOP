
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shop_app/Features/presentation/bloc/location/location_states.dart';







class LocationCubit extends Cubit<LocationStates> {

  LocationCubit() :super(AppIntialState());

  static LocationCubit get(context) => BlocProvider.of(context);

  TextEditingController addressController=TextEditingController();
  TextEditingController homeController=TextEditingController();
  TextEditingController floorController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController nearController=TextEditingController();



}













