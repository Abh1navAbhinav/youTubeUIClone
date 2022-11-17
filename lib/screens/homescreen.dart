import 'package:flutter/material.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/widgets/video_card.dart';

import '../widgets/custom_sliver_appbar.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const CustomSliverAppbar(),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 60),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                 final video = videos[index];
          
                  return VideoCard(video:video);
                },
                childCount: videos.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
