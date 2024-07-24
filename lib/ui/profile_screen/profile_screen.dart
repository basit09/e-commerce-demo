import 'package:e_commerce_task/infrastructure/provider/provider_registration.dart';
import 'package:e_commerce_task/ui/login_screen/login_screen.dart';
import 'package:e_commerce_task/ui/widgets/common_auth_buttons.dart';
import 'package:e_commerce_task/ui/widgets/common_text_field.dart';
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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {
        ref.read(authProvider).getName();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProviderRead = ref.read(authProvider);
    final authProviderWatch = ref.watch(authProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Data'),
        centerTitle: true,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
              authProviderRead.setIsEdit(false);
            },
            child: const Icon(Icons.arrow_back_rounded)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: InkWell(
                onTap: () {
                  authProviderRead.setIsEdit(!authProviderWatch.isEdit);
                },
                child: authProviderWatch.isEdit
                    ? const Icon(Icons.cancel_rounded)
                    : const Icon(Icons.edit)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25.0,
            ),
            Stack(
              children: [
                authProviderWatch.selectedImage != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            MemoryImage(authProviderWatch.selectedImage!))
                    : const CircleAvatar(
                        radius: 64,
                        backgroundColor: Colors.grey,
                        backgroundImage: NetworkImage(
                            'https://st3.depositphotos.com/9998432/13335/v/600/depositphotos_133352010-stock-illustration-default-placeholder-man-and-woman.jpg')),
                Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: () async {
                          if (authProviderWatch.isEdit) {
                            await authProviderRead.getImage(context);
                          }
                        },
                        icon: const Icon(Icons.add_a_photo_rounded)))
              ],
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFieldInput(
              enabled: authProviderWatch.isEdit,
              onSubmitted: (p0) {
                //  ref.read(authProvider).updateNameAndEmail(p0, null);
              },
              icon: Icons.person,
              textEditingController: ref.watch(authProvider).nameController,
              textInputType: TextInputType.text,
              hintText: '',
            ),
            const SizedBox(
              height: 15.0,
            ),
            TextFieldInput(
                enabled: authProviderWatch.isEdit,
                onSubmitted: (p0) {
                  //ref.read(authProvider).updateNameAndEmail(null, p0);
                },
                icon: Icons.email,
                textEditingController: ref.watch(authProvider).emailController,
                hintText: 'Enter your email',
                textInputType: TextInputType.text),
            const SizedBox(
              height: 15.0,
            ),
            CommonAuthButton(
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
                text: 'Log Out'),
            if (authProviderWatch.isEdit)
              const SizedBox(
                height: 15.0,
              ),
            authProviderWatch.isEdit
                ? CommonAuthButton(
                    onTap: () async {
                      String res = await authProviderRead.updateData(
                          authProviderWatch.nameController.text,
                          authProviderWatch.emailController.text,
                          authProviderWatch.selectedImage!);
                      if (res == 'success') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Data Updated Successfully',
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                        authProviderRead.setIsEdit(false);
                      }
                    },
                    text: "Update")
                : const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
