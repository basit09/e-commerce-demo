// ignore_for_file: use_build_context_synchronously

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/login_screen/login_screen.dart';
import 'package:e_commerce_task/ui/product_detail_screen/product_detail_screen.dart';
import 'package:e_commerce_task/ui/profile_screen/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(productProvider).getProductDataList(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProviderRead = ref.read(productProvider);
    final productProviderWatch = ref.watch(productProvider);

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                )),
            child: const Icon(
              Icons.account_circle_outlined,
              size: 25,
            )),
        actions: [
          InkWell(
              onTap: () async {
                await ref.read(authProvider).signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                  (route) => true,
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Icon(
                  Icons.logout,
                ),
              ))
        ],
        title: Text(
          'Product List',
          style: TextStyle(color: Colors.orange.withOpacity(0.5), fontSize: 25),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.only(right: 12, top: 12, bottom: 12),
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF000000).withOpacity(0.5),
                            // Semi-transparent black
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          )
                        ]),
                    child: ListTile(
                      title: Text(
                        productProviderWatch.productList?[index].title ?? '',
                        maxLines: 2,
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductDetailScreen(
                                productModel:
                                    productProviderWatch.productList?[index],
                              ),
                            ));
                      },
                      leading: CachedNetworkImage(
                        imageUrl: productProviderWatch
                                .productList?[index].category?.image ??
                            '',
                        placeholder: (context, url) {
                          if (url.isEmpty) {
                            return const CircularProgressIndicator();
                          } else {
                            return Image.network(
                              url ?? '',
                              height: 100,
                              width: 100,
                            );
                          }
                        },
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const SizedBox(
                      height: 10.0,
                    ),
                itemCount: productProviderWatch.productList?.length ?? 0);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
        future: productProviderWatch.getProductDataList(context),
      ),
    );
  }
}
