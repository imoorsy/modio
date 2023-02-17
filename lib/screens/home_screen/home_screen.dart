import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/screens/audio_tabs_screens/albums_screen/albums_screen.dart';
import 'package:modio/screens/audio_tabs_screens/artist_screen/artist_screen.dart';
import 'package:modio/screens/audio_tabs_screens/home_audio_screen/home_audio_screen.dart';
import 'package:modio/screens/audio_tabs_screens/playlist_screen/playlist_screen.dart';
import 'package:modio/screens/song_playlist_screen/song_playlist_screen.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:buildcondition/buildcondition.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ModioCubit cubit = ModioCubit.get(context);
        return DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: HexColor("040305"),
            appBar: AppBar(
              toolbarHeight: 0,
              backgroundColor: Colors.transparent,
              bottom: TabBar(
                unselectedLabelColor: Colors.grey,
                indicatorColor: HexColor("283CAF"),
                tabs: [
                  Tab(
                    text: "audios",
                  ),
                  Tab(
                    text: "platlist",
                  ),
                  Tab(
                    text: "artist",
                  ),
                  Tab(
                    text: "albums",
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                HomeAudioScreen(),
                PLaylistScreen(),
                ArtistScreen(),
                AlbumsScreen(),
              ],
            ),
            bottomSheet: BuildCondition(
              condition: cubit.currentAudio != null,
              builder:(context) => buildBottomAudioItem(context, cubit.currentAudio!, cubit),
              fallback: (context) => Container(height: 0,),
            ),
          ),
        );
      },
    );
  }
}
