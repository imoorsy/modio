import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioScreen extends StatelessWidget {
  final SongModel song;


  AudioScreen({
    required this.song,
  });

  @override
  Widget build(BuildContext context) {

    return BlocConsumer<ModioCubit,ModioStates>(
      listener: (context,state) {},
      builder:(context,state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
              onPressed: () async {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Text(
            "now playing",
            style: Theme.of(context).textTheme.titleSmall,
          ),
          centerTitle: true,
          actions: [
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  size: 30,
                )),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  size: 30,
                )),
            SizedBox(
              width: 10,
            )
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 100),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor("283CAF").withOpacity(0.6),
                  HexColor("283CAF").withOpacity(0.9),
                ],
              )),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 50,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.3,
                child: QueryArtworkWidget(
                  id: song.id,
                  type: ArtworkType.AUDIO,
                  artworkFit: BoxFit.contain,
                  artworkBorder: BorderRadius.circular(100),
                  artworkWidth: MediaQuery.of(context).size.width * 0.8,
                  artworkHeight: MediaQuery.of(context).size.height * 0.3,
                  nullArtworkWidget: Image.asset('assets/image/no-results.png'),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(10),
                scrollDirection: Axis.horizontal,
                child: Text(song.title,maxLines: 1,overflow: TextOverflow.visible,style: Theme.of(context).textTheme.titleMedium,)
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 50),
                child: StreamBuilder(
                  stream: cubit.audioManager.onPositionChanged,
                  builder:(context,val) {
                    if(val.hasData) {
                      if(val.data!.inSeconds == Duration(milliseconds: song.duration!.toInt()).inSeconds) {
                        cubit.goNext(song, context);
                        return Center(child: CircularProgressIndicator());
                      } else {
                        return ProgressBar(
                          progress: Duration(seconds: val.data!.inSeconds),
                          total: Duration(milliseconds: song.duration!.toInt().floor() - 60),
                          timeLabelLocation: TimeLabelLocation.below,
                          progressBarColor: HexColor("191E5D"),
                          thumbColor: HexColor("191E5D"),
                          thumbGlowColor: Colors.grey,
                          thumbGlowRadius: 20,
                          timeLabelTextStyle: Theme.of(context).textTheme.labelMedium,
                          timeLabelType: TimeLabelType.remainingTime,
                          thumbCanPaintOutsideBar: true,
                          timeLabelPadding: 10,
                          thumbRadius: 5,
                          barHeight: 10,
                          baseBarColor: Colors.white38,
                          onSeek: (duration) async {
                            await cubit.audioManager.seek(duration);
                          },
                        );
                      }
                    } else {
                      return Center(child: CircularProgressIndicator());
                    }

                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.skip_previous),
                    iconSize: 70,
                    onPressed: () async {
                      await cubit.goPrevious(song, context);
                    },
                  ),
                  IconButton(
                    color: HexColor("191E5D"),
                    onPressed: () async {
                     await cubit.pauseAudio();
                    },
                    iconSize: 90,
                    icon: Icon(
                     cubit.isPlaying ? Icons.pause : Icons.play_arrow,
                    ),
                  ),
                  IconButton(
                    color: Colors.white,
                    icon: Icon(Icons.skip_next),
                    iconSize: 70,
                    onPressed: () async {
                      await cubit.goNext(song, context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      );
      },
    );
  }
}
