import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

import '../../AppGlobal.dart';
import '../../constants.dart';
import '../../model/ProductModel.dart';
import '../../model/VendorCategoryModel.dart';
import '../../model/VendorModel.dart';
import '../../services/FirebaseHelper.dart';
import '../../services/helper.dart';
import '../../services/localDatabase.dart';
import '../../ui/dineInScreen/dine_in_restaurant_details_screen.dart';
import '../../ui/vendorProductsScreen/newVendorProductsScreen.dart';
import '../productDetailsScreen/ProductDetailsScreen.dart';

class CategoryDetailsScreen extends StatefulWidget {
  final VendorCategoryModel category;

  final bool isDineIn;

  const CategoryDetailsScreen(
      {Key? key, required this.category, required this.isDineIn})
      : super(key: key);

  @override
  _CategoryDetailsScreenState createState() => _CategoryDetailsScreenState();
}

class _CategoryDetailsScreenState extends State<CategoryDetailsScreen> {
  Stream<List<VendorModel>>? categoriesFuture;
  final FireStoreUtils fireStoreUtils = FireStoreUtils();
  Future<List<ProductModel>>? productsByCategory;
  late CartDatabase cartDatabase;

  @override
  void didChangeDependencies() {
    cartDatabase = Provider.of<CartDatabase>(context);
    super.didChangeDependencies();
  }

  late VendorModel vendor;

  @override
  void initState() {
    super.initState();
    getVendor();
    categoriesFuture = fireStoreUtils.getVendorsByCuisineID(
        widget.category.id.toString(),
        isDinein: widget.isDineIn);
    productsByCategory =
        FireStoreUtils.getProductListByCategoryId(widget.category.id!);
  }

  getVendor() async {
    vendor = (await FireStoreUtils.getVendor('kZFFtYvIGgJY0TqoGQ5U'))!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppGlobal.buildSimpleAppBar(
            context, widget.category.title.toString()),
        body: FutureBuilder<List<ProductModel>>(
          future: productsByCategory,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Container(
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
                  ),
                ),
              );
            if (!snapshot.hasData || (snapshot.data?.isEmpty ?? true)) {
              return Center(
                child: showEmptyState('No Restaurant found'.tr(), context),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, inx) => buildRow(
                    snapshot.data![inx],
                    vegSwitch,
                    nonVegSwitch,
                    snapshot.data![inx].categoryID,
                    (inx == (snapshot.data!.length - 1))),
              );
            }
          },
        ),
      ),
    );
  }

  buildVendorItem(VendorModel vendorModel) {
    return GestureDetector(
        onTap: () {
          if (widget.isDineIn) {
            push(
              context,
              DineInRestaurantDetailsScreen(vendorModel: vendorModel),
            );
          } else {
            push(
              context,
              NewVendorProductsScreen(vendorModel: vendorModel),
            );
          }
        },
        child: Column(
          children: [
            ListView.builder(itemBuilder: (context, index) {
              return Container();
            })
          ],
        )
        // Card(
        //   elevation: 0.5,
        //   color: isDarkMode(context) ? Colors.grey.shade900 : Colors.white,
        //   shape: RoundedRectangleBorder(
        //     borderRadius: BorderRadius.all(
        //       Radius.circular(20),
        //     ),
        //   ),
        //   margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //   child: Container(
        //     height: 200,
        //
        //     // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        //     // margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        //     child: Column(
        //       // mainAxisSize: MainAxisSize.max,
        //       // crossAxisAlignment: CrossAxisAlignment.stretch,
        //       children: [
        //         // Expanded(
        //         //   child: CachedNetworkImage(
        //         //     imageUrl: getImageVAlidUrl(vendorModel.photo),
        //         //     imageBuilder: (context, imageProvider) => Container(
        //         //       decoration: BoxDecoration(
        //         //           borderRadius: BorderRadius.circular(20),
        //         //           image: DecorationImage(
        //         //               image: imageProvider, fit: BoxFit.cover)),
        //         //     ),
        //         //     placeholder: (context, url) => Center(
        //         //         child: CircularProgressIndicator.adaptive(
        //         //       valueColor: AlwaysStoppedAnimation(Color(COLOR_PRIMARY)),
        //         //     )),
        //         //     errorWidget: (context, url, error) => ClipRRect(
        //         //         borderRadius: BorderRadius.circular(20),
        //         //         child: Image.network(
        //         //           AppGlobal.placeHolderImage!,
        //         //           fit: BoxFit.fitWidth,
        //         //           width: MediaQuery.of(context).size.width,
        //         //         )),
        //         //     fit: BoxFit.cover,
        //         //   ),
        //         // ),
        //         // // SizedBox(height: 8),
        //         // ListTile(
        //         //   title: Text(vendorModel.title,
        //         //       maxLines: 1,
        //         //       style: TextStyle(
        //         //         fontSize: 16,
        //         //         color: isDarkMode(context)
        //         //             ? Colors.grey.shade400
        //         //             : Colors.grey.shade800,
        //         //         fontFamily: 'Poppinssb',
        //         //       )),
        //         //   subtitle: Text(vendorModel.location,
        //         //       maxLines: 1,
        //         //
        //         //       // filters.keys
        //         //       //     .where(
        //         //       //         (element) => vendorModel.filters[element] == 'Yes')
        //         //       //     .take(2)
        //         //       //     .join(', '),
        //         //
        //         //       style: TextStyle(
        //         //         fontFamily: 'Poppinssm',
        //         //       )),
        //         //   trailing: Padding(
        //         //     padding: const EdgeInsets.only(top: 8.0),
        //         //     child: Column(
        //         //       mainAxisAlignment: MainAxisAlignment.start,
        //         //       children: [
        //         //         Wrap(
        //         //             spacing: 8,
        //         //             crossAxisAlignment: WrapCrossAlignment.center,
        //         //             children: <Widget>[
        //         //               Icon(
        //         //                 Icons.star,
        //         //                 size: 20,
        //         //                 color: Color(COLOR_PRIMARY),
        //         //               ),
        //         //               Text(
        //         //                 (vendorModel.reviewsCount != 0)
        //         //                     ? (vendorModel.reviewsSum /
        //         //                             vendorModel.reviewsCount)
        //         //                         .toStringAsFixed(1)
        //         //                     : "0",
        //         //                 style: TextStyle(
        //         //                   fontFamily: 'Poppinssb',
        //         //                 ),
        //         //               ),
        //         //               Visibility(
        //         //                   visible: vendorModel.reviewsCount != 0,
        //         //                   child: Text(
        //         //                       "(${vendorModel.reviewsCount.toStringAsFixed(1)})")),
        //         //             ]),
        //         //       ],
        //         //     ),
        //         //   ),
        //         // ),
        //         // SizedBox(height: 4),
        //         //
        //         // SizedBox(height: 4),
        //         // Visibility(
        //         //   visible: vendorModel.reviewsCount != 0,
        //         //   child: RichText(
        //         //     text: TextSpan(
        //         //       style: TextStyle(
        //         //           color: isDarkMode(context)
        //         //               ? Colors.grey.shade200
        //         //               : Colors.black),
        //         //       children: [
        //         //         TextSpan(
        //         //             text:
        //         //                 '${double.parse((vendorModel.reviewsSum / vendorModel.reviewsCount).toStringAsFixed(2))} '),
        //         //         WidgetSpan(
        //         //           child: Icon(
        //         //             Icons.star,
        //         //             size: 20,
        //         //             color: Color(COLOR_PRIMARY),
        //         //           ),
        //         //         ),
        //         //         TextSpan(text: ' (${vendorModel.reviewsCount})'),
        //         //       ],
        //         //     ),
        //         //   ),
        //         // ),
        //       ],
        //     ),
        //   ),
        // ),
        );
  }

  bool vegSwitch = false;
  bool nonVegSwitch = false;
  var isAnother = 0;

  buildRow(ProductModel productModel, veg, nonveg, inx, bool index) {
    if (vegSwitch == true && productModel.veg == true) {
      isAnother++;
      return datarow(productModel);
    } else if (nonVegSwitch == true && productModel.veg == false) {
      isAnother++;
      return datarow(productModel);
    } else if (vegSwitch != true && nonVegSwitch != true) {
      isAnother++;
      return datarow(productModel);
    } else if (nonVegSwitch == true && productModel.nonveg == true) {
      isAnother++;
      return datarow(productModel);
    } else if (inx == productModel.categoryID) {
      return (isAnother == 0 && index)
          ? showEmptyState("No Food are available.", context)
          : Container();
    }
  }

  late List<CartProduct> cartProducts = [];

  datarow(ProductModel productModel) {
    var price = double.parse(productModel.price);
    assert(price is double);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await Navigator.of(context)
            .push(MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                    productModel: productModel, vendorModel: vendor)))
            .whenComplete(() => {setState(() {})});

        showModalBottomSheet(
          isScrollControlled: true,
          isDismissible: true,
          context: context,
          backgroundColor: Colors.transparent,
          enableDrag: true,
          builder: (context) => ProductDetailsScreen(
              productModel: productModel, vendorModel: vendor),
        ).whenComplete(() => {setState(() {})});
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: isDarkMode(context)
                  ? const Color(DarkContainerBorderColor)
                  : Colors.grey.shade100,
              width: 1),
          color: isDarkMode(context) ? Color(DarkContainerColor) : Colors.white,
          boxShadow: [
            isDarkMode(context)
                ? const BoxShadow()
                : BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                  ),
          ],
        ),
        child: Row(children: [
          StreamBuilder<List<CartProduct>>(
              stream: cartDatabase.watchProducts,
              initialData: [],
              builder: (context, snapshot) {
                cartProducts = snapshot.data!;
                print("cart pro copre  " + cartProducts.length.toString());
                print(cartProducts.toString());
                print("cart pro co " + productModel.quantity.toString());
                Future.delayed(const Duration(milliseconds: 300), () {
                  productModel.quantity = 0;
                  if (cartProducts.isNotEmpty) {
                    for (CartProduct cartProduct in cartProducts) {
                      if (cartProduct.id == productModel.id) {
                        productModel.quantity = cartProduct.quantity;
                      }
                    }
                  }
                });
                return const SizedBox(
                  height: 0,
                  width: 0,
                );
              }),
          Stack(children: [
            CachedNetworkImage(
                height: 80,
                width: 80,
                imageUrl: getImageVAlidUrl(productModel.photo),
                imageBuilder: (context, imageProvider) => Container(
                      // width: 100,
                      // height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          )),
                    ),
                errorWidget: (context, url, error) => ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      placeholderImage,
                      fit: BoxFit.cover,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                    ))),
            Positioned(
              left: 5,
              top: 5,
              child: Icon(
                Icons.circle,
                color: productModel.veg == true
                    ? const Color(0XFF3dae7d)
                    : Colors.redAccent,
                size: 13,
              ),
            )
          ]),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                productModel.name,
                style: const TextStyle(
                    fontSize: 16, fontFamily: "Poppinssb", letterSpacing: 0.5),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: <Widget>[
                  productModel.disPrice == "" || productModel.disPrice == "0"
                      ? Text(
                          "${amountShow(amount: productModel.price.toString())}",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppinsm",
                              letterSpacing: 0.5,
                              color: Color(COLOR_PRIMARY)),
                        )
                      : Row(
                          children: [
                            Text(
                              "${amountShow(amount: productModel.disPrice.toString())}",
                              style: TextStyle(
                                fontFamily: "Poppinsm",
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(COLOR_PRIMARY),
                              ),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              "${amountShow(amount: productModel.price.toString())}",
                              style: const TextStyle(
                                  fontFamily: "Poppinsm",
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  decoration: TextDecoration.lineThrough),
                            ),
                          ],
                        ),
                  // productModel.quantity == 0
                  //     ? isOpen != true
                  //         ? const Center()
                  //         : Padding(
                  //             padding: const EdgeInsets.only(right: 15),
                  //             child: SizedBox(
                  //                 height: 33,
                  //                 // width: 80,
                  //                 // alignment:Alignment.center,
                  //                 child: Center(
                  //                   // height: 10,
                  //                   //  width: 80,
                  //                   child: TextButton.icon(
                  //                     onPressed: () {
                  //                       if (MyAppState.currentUser == null) {
                  //                         push(context, const AuthScreen());
                  //                       } else {
                  //                         setState(() {
                  //                           productModel.quantity = 1;
                  //                           // productModel.price = productModel.disPrice == "" || productModel.disPrice == "0"?productModel.price:productModel.disPrice;
                  //                           addtocard(productModel, productModel.quantity);
                  //                         });
                  //                       }
                  //                     },
                  //                     icon: Icon(Icons.add, size: 18, color: Color(COLOR_PRIMARY)),
                  //                     label: Text(
                  //                       'ADD'.tr(),
                  //                       style: TextStyle(height: 1.2, fontFamily: "Poppinssb", letterSpacing: 0.5, color: Color(COLOR_PRIMARY)),
                  //                     ),
                  //                     style: TextButton.styleFrom(
                  //                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                  //                       side: const BorderSide(color: Color(0XFFC3C5D1), width: 1.5),
                  //                     ),
                  //                   ),
                  //                 )))
                  //     : Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           IconButton(
                  //               onPressed: () {
                  //                 if (productModel.quantity != 0) {
                  //                   setState(() {
                  //                     productModel.quantity--;
                  //                     if (productModel.quantity >= 0) {
                  //                       // productModel.price = productModel.disPrice == "" || productModel.disPrice == "0"?productModel.price:productModel.disPrice;
                  //                       removetocard(productModel, productModel.quantity);
                  //                     } else {
                  //                       // addtocard(productModel);
                  //                       //removeQuntityFromCartProduct(productModel);
                  //
                  //                     }
                  //
                  //                     //: addtocard(productModel);
                  //                   });
                  //                 }
                  //                 //   productModel.quantity >=1?
                  //                 //   removetocard(productModel, productModel.quantity)
                  //                 //  :null;
                  //                 // },
                  //                 // );
                  //               },
                  //               icon: Image(
                  //                 image: const AssetImage("assets/images/minus.png"),
                  //                 color: Color(COLOR_PRIMARY),
                  //                 height: 28,
                  //               )),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //
                  //           // cartData( productModel.id)== null?
                  //
                  //           StreamBuilder<List<CartProduct>>(
                  //               stream: cartDatabase.watchProducts,
                  //               initialData: const [],
                  //               builder: (context, snapshot) {
                  //                 cartProducts = snapshot.data!;
                  //                 return SizedBox(
                  //                     height: 25,
                  //                     width: 0,
                  //                     child: Column(children: [
                  //                       Expanded(
                  //                           child: ListView.builder(
                  //                               itemCount: cartProducts.length,
                  //                               itemBuilder: (context, index) {
                  //                                 cartProducts[index].id == productModel.id ? productModel.quantity = cartProducts[index].quantity : null;
                  //                                 // print('yahaaaaa');
                  //                                 if (cartProducts[index].id == productModel.id) {
                  //                                   return const Center();
                  //                                 } else {
                  //                                   return Container();
                  //                                 }
                  //                                 //  return Center();
                  //
                  //                                 // print(quen);
                  //                               }))
                  //                     ]));
                  //               }),
                  //           Text(
                  //             '${productModel.quantity}'.tr(),
                  //             style: const TextStyle(
                  //               fontSize: 20,
                  //               color: Colors.black,
                  //               letterSpacing: 0.5,
                  //             ),
                  //           ),
                  //           //  Text("null"),
                  //           const SizedBox(
                  //             width: 5,
                  //           ),
                  //           IconButton(
                  //               onPressed: () {
                  //                 setState(() {
                  //                   if (productModel.quantity != 0) {
                  //                     productModel.quantity++;
                  //                   }
                  //                   //productModel.price = productModel.disPrice == "" || productModel.disPrice == "0"?productModel.price:productModel.disPrice;
                  //                   addtocard(productModel, productModel.quantity);
                  //                 });
                  //               },
                  //               icon: Image(
                  //                 image: const AssetImage("assets/images/plus.png"),
                  //                 color: Color(COLOR_PRIMARY),
                  //                 height: 28,
                  //               ))
                  //         ],
                  //       )
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          productModel.reviewsCount != 0
                              ? (productModel.reviewsSum /
                                      productModel.reviewsCount)
                                  .toStringAsFixed(1)
                              : 0.toString(),
                          style: const TextStyle(
                            fontFamily: "Poppinsm",
                            letterSpacing: 0.5,
                            fontSize: 12,
                            color: Colors.white,
                          )),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )),
          TextButton(
            onPressed: () async {
              await Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => ProductDetailsScreen(
                          productModel: productModel, vendorModel: vendor)))
                  .whenComplete(() => {setState(() {})});
            },
            // icon: Icon(
            //   Icons.add,
            //   color: Color(COLOR_PRIMARY),
            //   size: 16,
            // ),
            child: Text(
              'Options'.tr(),
              style: TextStyle(
                  fontFamily: "Poppinsm", color: Color(COLOR_PRIMARY)),
            ),
            style: TextButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade300, width: 2),
            ),
          )
        ]),
      ),
    );
  }
}
