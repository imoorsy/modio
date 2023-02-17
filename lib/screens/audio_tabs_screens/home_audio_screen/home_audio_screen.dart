import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class HomeAudioScreen extends StatelessWidget {
  const HomeAudioScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit,ModioStates>(
      listener: (context,state) {},
      builder:(context,state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Container(
        padding: EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                HexColor("040305").withOpacity(0.9),
                HexColor("283CAF").withOpacity(0.5),
              ],
            )),
        child: RefreshIndicator(
          onRefresh: cubit.getAudios,
          child: BuildCondition(
            condition: state is ModioAudiosDoneStates || cubit.audios.isNotEmpty,
            builder: (context) => BuildCondition(
              condition: cubit.audios.isNotEmpty,
              builder: (context) =>
                  buildAudios(context, cubit.audios, cubit),
              fallback: (context) => buildNoAudios(context),
            ),
            fallback: (context) => Center(
                child: CircularProgressIndicator(
                  color: HexColor("4F3952"),
                )),
          ),
        ),
      );
      },
    );
  }
}
