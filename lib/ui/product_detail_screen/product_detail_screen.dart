import 'package:e_commerce_task/infrastructure/models/product_model_class.dart';
import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final ProductModel? productModel;

  const ProductDetailScreen({
    required this.productModel,
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async {
        final List<int> myFavourites =
            await ref.read(productProvider).getFavouriteList();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: const Icon(Icons.arrow_back_ios)),
        title: Text(
          widget.productModel?.title ?? '',
          style: const TextStyle(color: Colors.orange, fontSize: 25),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.productModel?.category?.image ?? ''),
            const SizedBox(
              height: 15.0,
            ),
            InkWell(
                onTap: () {
                  ref
                      .read(productProvider)
                      .addFavourite(widget.productModel?.id ?? 0);
                },
                child: (ref
                            .watch(productProvider)
                            .favProductList
                            ?.contains(widget.productModel?.id) ??
                        false)
                    ? const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite,
                        color: Colors.grey,
                      )),
            Text.rich(TextSpan(
                text: "Price: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.productModel?.price.toString() ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                  const TextSpan(
                    text: '\$',
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  )
                ])),
            Text.rich(TextSpan(
                text: "Description: ",
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.w700),
                children: [
                  TextSpan(
                    text: widget.productModel?.description ?? '',
                    style: const TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.w400),
                  ),
                ])),
          ],
        ),
      ),
    );
  }
}
