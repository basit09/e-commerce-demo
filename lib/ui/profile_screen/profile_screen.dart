import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/widgets/common_text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(authProvider).getName();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Data'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldInput(
            onSubmitted: (p0) {
              ref.read(authProvider).updateNameAndEmail(p0, null);
            },
            icon: Icons.person,
            textEditingController: ref.watch(authProvider).nameController,
            textInputType: TextInputType.text,
            hintText: '',
          ),
          TextFieldInput(
              onSubmitted: (p0) {
                ref.read(authProvider).updateNameAndEmail(null, p0);
              },
              icon: Icons.email,
              textEditingController: ref.watch(authProvider).emailController,
              hintText: 'Enter your email',
              textInputType: TextInputType.text),
        ],
      ),
    );
  }
}
