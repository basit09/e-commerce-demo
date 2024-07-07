import 'package:e_commerce_task/infrastructure/provider/auth_provider.dart';
import 'package:e_commerce_task/infrastructure/provider/product_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authProvider = ChangeNotifierProvider<AuthProvider>((_) => AuthProvider());
final productProvider = ChangeNotifierProvider<ProductProvider>((_) => ProductProvider());
