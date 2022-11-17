import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_youtube_ui/data.dart';
import 'package:flutter_youtube_ui/screens/video_screen.dart';
import 'package:miniplayer/miniplayer.dart';

import 'homescreen.dart';

final selectedVideoProvider = StateProvider<Video?>(
  (ref) => null,
);

final MiniplayerControllerProvider =
    StateProvider.autoDispose<MiniplayerController>(
        (ref) => MiniplayerController());

class NavScreen extends StatefulWidget {
  const NavScreen({Key? key}) : super(key: key);

  @override
  State<NavScreen> createState() => _NavScreenState();
}

class _NavScreenState extends State<NavScreen> {
  static const playerMinHeight = 60.0;
  int selectedIndex = 0;
  final screens = [
    const HomeScreen(),
    const Scaffold(
      body: Center(
        child: Text('Explore'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Add'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Subscriptions'),
      ),
    ),
    const Scaffold(
      body: Center(
        child: Text('Library'),
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(
        builder: (context, watch, child) {
          final selectedVideo = watch(selectedVideoProvider).state;
          final MiniplayerController =
              watch(MiniplayerControllerProvider).state;
          return Stack(
            children: screens
                .asMap()
                .map(
                  (i, screen) => MapEntry(
                    i,
                    Offstage(
                      offstage: selectedIndex != i,
                      child: screen,
                    ),
                  ),
                )
                .values
                .toList()
              ..add(
                Offstage(
                  offstage: selectedVideo == null,
                  child: Miniplayer(
                    controller: MiniplayerController,
                    minHeight: playerMinHeight,
                    maxHeight: MediaQuery.of(context).size.height,
                    builder: ((height, percentage) {
                      if (selectedVideo == null) return const SizedBox.shrink();
                      if(height <= playerMinHeight+50)
                      return Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: Center(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.network(
                                    selectedVideo.thumbnailUrl,
                                    height: playerMinHeight - 4,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              selectedVideo.title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                            ),
                                          ),
                                          Flexible(
                                            child: Text(
                                              selectedVideo.author.username,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption!
                                                  .copyWith(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.play_arrow,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      context
                                          .read(selectedVideoProvider)
                                          .state = null;
                                    },
                                    icon: Icon(
                                      Icons.close,
                                    ),
                                  ),
                                ],
                              ),
                              LinearProgressIndicator(
                                value: 0.4,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                      return VideoScreen();
                    }),
                  ),
                ),
              ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        onTap: (value) => setState(() {
          selectedIndex = value;
        }),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home_outlined,
            ),
            label: 'Home',
            activeIcon: Icon(
              Icons.home,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore_outlined,
            ),
            label: 'Explore',
            activeIcon: Icon(
              Icons.explore,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
            ),
            label: 'Add',
            activeIcon: Icon(
              Icons.add_circle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.subscriptions_outlined,
            ),
            label: 'Subscriptions',
            activeIcon: Icon(
              Icons.subscriptions,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.video_library_outlined,
            ),
            label: 'Library',
            activeIcon: Icon(
              Icons.video_library,
            ),
          ),
        ],
      ),
    );
  }
}
