import 'package:flutter/material.dart';
import 'package:youtube_clone/features/auth/pages/logout_page.dart';
import 'package:youtube_clone/features/content/Long_video/long_video_screen.dart';
import 'package:youtube_clone/features/content/Short_video/pages/short_video_page.dart';
import 'package:youtube_clone/features/search/pages/search_screen.dart';

List pages = [
  const LongVideoScreen(),
  const ShortVideoPage(),
  const Center(child: Text("upload")),
  const SearchScreen(),
  const LogoutPage(),
];
