import 'package:flutter/material.dart';
import 'package:flutter_riverpod/all.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:miniplayer/miniplayer.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../screens/nav_screen.dart';

class VideoCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Video video;
  final bool haspadding;
  const VideoCard({
    Key? key,
    required this.video,
    this.haspadding = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read(selectedVideoProvider).state = video;
        context
            .read(MiniplayerControllerProvider)
            .state
            .animateToHeight(state: PanelState.MAX);
        if (onTap != null) onTap!();
      },
      child: Column(
        children: [
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: haspadding ? 12 : 0,
                ),
                child: Image.network(
                  video.thumbnailUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 18,
                right: haspadding ? 20 : 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  color: Colors.black,
                  child: Text(
                    video.duration,
                    style: Theme.of(context).textTheme.caption!.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(
                    video.author.profileImageUrl,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          video.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.bodyText1!.copyWith(
                                    fontSize: 15,
                                  ),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          '${video.author.username} . ${video.viewCount} views .${timeago.format(video.timestamp)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.caption!.copyWith(
                                fontSize: 14,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.more_vert,
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
