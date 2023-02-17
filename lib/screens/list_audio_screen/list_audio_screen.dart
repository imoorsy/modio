import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ListAudioScreen extends StatelessWidget {
  final String listName;

  ListAudioScreen({
    required this.listName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit,ModioStates>(
      listener: (context,state) {},
      builder: (context,state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Scaffold(
            backgroundColor: HexColor("040305"),
            appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(listName,style: Theme.of(context).textTheme.titleLarge,),
            titleSpacing: 20,
            toolbarHeight: 90,
            actions: [
              Icon(Icons.search,size: 30,),
              SizedBox(width: 20,)
            ],
          ),
            body: buildListAudios(context, cubit.audiosPage, cubit),
          bottomSheet: BuildCondition(
            condition: cubit.currentAudio != null,
            builder:(context) => buildBottomAudioItem(context, cubit.currentAudio!, cubit),
            fallback: (context) => Container(height: 0,),
          ),
        );
      },
    );
  }
}
