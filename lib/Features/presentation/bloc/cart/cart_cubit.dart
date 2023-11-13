

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shop_app/Core/const/app_message.dart';
import 'package:shop_app/Core/resources/color_manager.dart';
import 'package:shop_app/Features/data/models/cart_model.dart';
import 'package:shop_app/Features/data/models/product_model.dart';
import 'package:shop_app/Features/data/services/data_base.dart';
import 'cart_states.dart';




class CartCubit extends Cubit<CartStates> {

  CartCubit() :super(AppIntialState());

  static CartCubit get(context) => BlocProvider.of(context);

  ValueNotifier<bool> get loading => _loading;
  ValueNotifier<bool> _loading = ValueNotifier(false);
  List<CartProductModel> _cartProductModel = [];
  List<CartProductModel> get cartProductModel => _cartProductModel;
  double get totalPrice => _totalPrice;
  double _totalPrice = 0.0;
  num total = 0.0;
  int quant2 = 1;
  var dbHelper = CartDatabaseHelper.db;
  ProductModel ? model;
  bool isFav=false;
  bool isFav2=false;
  num quant=1;
  List data=[];
  final ScrollController scrollController = ScrollController();
  int currentIndex = 0;
  List image=[];
 String image2='';
  int index=0;


  getImageData(DocumentSnapshot posts){
    image=posts['image'];
    image2=image[index];
    emit(GetImageSuccessState());
  }
   buildImageWidget(DocumentSnapshot posts){
     index++;
     emit(NextImageSuccessState());
     getImageData(posts);
  }

  returnImage(DocumentSnapshot posts){
    index--;
    emit(NextImageSuccessState());
    getImageData(posts);
  }


  void scrollToIndex(int index) {
    scrollController.animateTo(
      index * 100.0, // Adjust the value based on the item width
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    emit(AnimateImageSuccessState());
  }

  CartViewModel() {
    getAllProduct();
    getTotalPrice();
  }

  increaseQuant(int num)async{
    if(quant<num){
      quant++;
      emit(IncreaseQuantitySuccessState());
    }
  //   quant=num;
  //   if(quant<num){
  //    // quant++;
  //     quant=num;
  //     emit(IncreaseQuantitySuccessState());
  //   }else{
  //     quant=num;
  //     emit(IncreaseQuantitySuccessState());
  // //    appMessage(text: 'لا يمكن الزيادة عن هذا العدد لهذا المنتج ');
  //   }
  }

  decreaseQuant()async{
    if(quant>1){
      quant--;
      emit( DecreaseQuantitySuccessState());
    }
  }

  getAllProduct() async {
    emit(GetAllProductsLoadingState());
    _loading.value = true;
    try{
      _cartProductModel = await dbHelper.getAllProduct();
      print('CART LEGNTH =${_cartProductModel.length}');
      _loading.value = false;
      getTotalPrice();
      emit(GetAllProductsSuccessState());

    }
    catch(e){
      print(e);
      emit(GetAllProductsErrorState('$e'));
    }


  }


  addProduct(CartProductModel cartProductModel, String productId) async {

    //
    // if (_cartProductModel.length == 10) {
    //   appMessage(text: 'لا يمكن اضافة اكثر من 10 منتجات في كل طلب');
    // }
    // else {

      emit(AddProductProductLoadingState());
      var dbHelper = CartDatabaseHelper.db;
      await dbHelper.insert(cartProductModel);
      appMessage(text: 'تم اضافة المنتج بنجاح');
      _cartProductModel.add(cartProductModel);
      _totalPrice +=
      (double.parse(cartProductModel.price!) * cartProductModel.quantity!);
      emit(AddProductProductSuccessState());
      getAllProduct();
//    }


  }


  dialogAndAdd ({required CartProductModel cartProductModel, required String productId}) {

    Get.defaultDialog(
      title: "متاكد من اضافة هذا المنتج ",
      middleText: "",
      onConfirm: () {
        addProduct (cartProductModel, productId);
        Get.back();
      },
      onCancel: () {
      },
      textCancel: "لا",
      textConfirm: "نعم",
      cancelTextColor: Colors.black,
      buttonColor: ColorsManager.black,
      confirmTextColor: Colors.white,
      barrierDismissible: true,
      //middleText: "Hello world!",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.black),
      middleTextStyle: const TextStyle(color: Colors.white),
    );
  }

  dialogAndDelete(CartProductModel cartProductModel, String productId) {
    Get.defaultDialog(
      title: "متاكد من حذف طلبك السابق ",
      middleText: "",
      onConfirm: () {
        DeleteAll(cartProductModel);
        addProduct(cartProductModel, productId);
        print("");
        Get.back();
        // Get.off(ControlView());
      },

      onCancel: () {

      },
      textCancel: "لا",
      textConfirm: "نعم",
      cancelTextColor: Colors.deepOrange,
      buttonColor: Colors.red,
      confirmTextColor: Colors.white,
      barrierDismissible: true,
      //middleText: "Hello world!",
      backgroundColor: Colors.white,
      titleStyle: const TextStyle(color: Colors.green),
      middleTextStyle: const TextStyle(color: Colors.white),
    );
  }

  DeleteProducts (CartProductModel cartProductModel, String productId) async {
    try{
      emit(DeleteAllLoadingState());
      var dbHelper = CartDatabaseHelper.db;
      await dbHelper.Delete(cartProductModel);
      _totalPrice = 0;
      emit(DeleteAllSuccessState());
      getAllProduct();
    }catch(e){
      emit(DeleteAllErrorState(e.toString()));
    }

  }

  DeleteAll(CartProductModel cartProductModel) async {
    var dbHelper = CartDatabaseHelper.db;
    try{
      emit(DeleteAllLoadingState());
      await dbHelper.DeleteAll(cartProductModel);
      final box = GetStorage();
      box.remove('brand');
      print("delete Done");
      emit(DeleteAllSuccessState());
    }catch(e){
      emit(DeleteAllErrorState('$e'));
    }


  }


  getTotalPrice() {
    _totalPrice = 0.0;
    for (int i = 0; i < _cartProductModel.length; i++) {
      _totalPrice = _totalPrice +
          (double.parse(_cartProductModel[i].price!) *
              _cartProductModel[i].quantity!);
      print('t=$_totalPrice');
      emit(GetTotalPriceSuccessState());
    }
  }

  increaseQuantity(int index,num quant) async {
    if (_cartProductModel[index].quantity ! < quant) {
      _cartProductModel[index].quantity = _cartProductModel[index].quantity! + 1;
      _totalPrice += (double.parse(_cartProductModel[index].price!));
      dbHelper.updateProduct(_cartProductModel[index]);
      emit(IncreaseQuantitySuccessState());
      getTotalPrice();
    } else {
      appMessage(text: 'لا يمكن الاضافة اكثر من ذلك');
    }
  }

  decreaseQuantity(int index) async {
    if (_cartProductModel[index].quantity! > 1) {
      _cartProductModel[index].quantity = _cartProductModel[index].quantity! - 1;
      _totalPrice -= (double.parse(_cartProductModel[index].price!));
      dbHelper.updateProduct(_cartProductModel[index]);
      emit(DecreaseQuantitySuccessState());
      getTotalPrice();
    } else {
      print("very small num");
    }
  }



  Future <List<DocumentSnapshot>> fetchDataFromFirestore() async {

    emit(GetDataFireBaseLoadingState());
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('fav').get();
      List<DocumentSnapshot> documents = querySnapshot.docs;

      for(int i=0;i<documents.length;i++){
        data.add(documents[i]['productid']);
      }
      print(data);
      emit(GetDataFireBaseSuccessState());
      return documents;

    } catch (e) {
      // Handle any errors that occur during the data retrieval process
      print('Error retrieving data from Firestore: $e');
      emit(GetDataFireBaseErrorState());
      return [];

    }
  }

  addToFav({required DocumentSnapshot posts }) async {

final box=GetStorage();
String email=box.read('email')??"x";
String country=box.read('country')??"x";

    emit(AddToFireBaseLoadingState());
    await FirebaseFirestore.instance.collection('fav').add({
      'user_email': email,
      'country': country,
      'name':posts['name'],
      'image':posts['image'],
      'productid':posts['productid'],
      'des':posts['des'],
      'price':posts['price'],
     // 'rate':posts['rate'],
    }).then((value) {
      isFav=true;
      isFav2=false;
      appMessage(text: 'تم الاضافة الي المفضلة ');
      emit(AddToFireBaseSuccessState());
    });
  }

  DeleteFromFav({required DocumentSnapshot posts})async{
    emit(DeleteFromFavLoadingState());
    final CollectionReference _updates =
    FirebaseFirestore.instance.collection('fav');
    await _updates
        .where('productid', isEqualTo: posts['productid'])
        .get().then((snapshot) {
      snapshot.docs.last.reference.delete().then((value) {
        print("Deleted");

        isFav=false;
        isFav2=true;

        emit(DeleteFromFavSuccessState());
      });
    });
  }

}













