import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/my_channel/repository/edit_field.dart';
import 'package:youtube_clone/features/channel/my_channel/widgets/edit_setting_dialog.dart';
import 'package:youtube_clone/features/channel/my_channel/widgets/setting_field_item.dart';

class MyChannelSettings extends ConsumerStatefulWidget {
  const MyChannelSettings({super.key});

  @override
  ConsumerState<MyChannelSettings> createState() => _MyChannelSettingsState();
}

class _MyChannelSettingsState extends ConsumerState<MyChannelSettings> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return ref.watch(currentUserProvider).when(
          data: (currentUser) => Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Stack(
                    children: [
                      SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: Image.asset(
                          "assets/images/flutter background.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        left: 180,
                        top: 60,
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(currentUser.profilePic),
                        ),
                      ),
                      Positioned(
                        right: 15,
                        top: 10,
                        child: Image.asset(
                          "assets/icons/camera.png",
                          height: 35,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // second part
                  const SizedBox(height: 15),
                  SettingsItem(
                    identifier: "Name",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "Your New Display Name",
                          onSave: (name) {
                            ref
                                .watch(editSettingsProvider)
                                .editDisplayName(name);
                          },
                        ),
                      );
                    },
                    value: currentUser.displayName,
                  ),
                  const SizedBox(height: 15),
                  SettingsItem(
                    identifier: "Handle",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "Your New User Name",
                          onSave: (username) {
                            ref
                                .watch(editSettingsProvider)
                                .editUserName(username);
                          },
                        ),
                      );
                    },
                    value: currentUser.username,
                  ),
                  const SizedBox(height: 15),
                  SettingsItem(
                    identifier: "Description",
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => SettingsDialog(
                          identifier: "Your New Description",
                          onSave: (description) {
                            ref
                                .watch(editSettingsProvider)
                                .editDescription(description);
                          },
                        ),
                      );
                    },
                    value: currentUser.description,
                  ),

                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Keep all my subscribers private"),
                        Switch(
                          value: isSwitched,
                          onChanged: (value) {
                            setState(() {
                              isSwitched = value;
                            });
                          },
                        )
                      ],
                    ),
                  ),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                    child: Text(
                      "Changes made on your names and profile pictures are visible only to youtube and not other Google Services",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.blueGrey,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          error: (error, stackTrace) => const ErrorPage(),
          loading: () => const Loader(),
        );
  }
}
