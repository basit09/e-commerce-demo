import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/product_detail_screen/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FavouriteScreen extends ConsumerStatefulWidget {
  const FavouriteScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _FavouriteScreenState();
}

class _FavouriteScreenState extends ConsumerState<FavouriteScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(productProvider).getFavData();
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProviderRead = ref.read(productProvider);
    final productProviderWatch = ref.watch(productProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style: TextStyle(fontSize: 15),
        ),
      ),
      body: ListView.separated(
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return Container(
              padding: const EdgeInsets.only(right: 12, top: 12, bottom: 12),
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
                  productProviderWatch.favProductsData?[index].title ?? '',
                  maxLines: 2,
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productModel:
                              productProviderWatch.favProductsData?[index],
                        ),
                      ));
                },
                leading: CachedNetworkImage(
                  imageUrl: productProviderWatch
                          .favProductsData?[index].category?.image ??
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 10.0,
              ),
          itemCount: productProviderWatch.favProductsData?.length ?? 0),
    );
  }
}
