import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SongPlaylistScreen extends StatelessWidget {

  final PlaylistModel playlist;

  SongPlaylistScreen({
    required this.playlist,
});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit,ModioStates>(
        listener: (context,state){},
        builder: (context,state){
          ModioCubit cubit = ModioCubit.get(context);
          return Scaffold(
            backgroundColor: HexColor("040305"),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios),color: Colors.white,),
              title: Text(playlist.playlist,style: Theme.of(context).textTheme.titleLarge,),
              titleSpacing: 20,
              centerTitle: true,
              toolbarHeight: 90,
              actions: [
                Icon(Icons.search,size: 30,),
                SizedBox(width: 20,)
              ],
            ),
            body: BuildCondition(
              condition: cubit.audios.isNotEmpty,
              builder:(context) => buildSelectedAudios(context, cubit.audios, cubit,playlist),
              fallback: (context) => Center(child: CircularProgressIndicator(color: HexColor("4F3952"),)),
            ),
          );
        },
        );
  }
}
