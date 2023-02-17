import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class AlbumsScreen extends StatelessWidget {
  const AlbumsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
        listener: (context, state) {},
    builder: (context, state) {
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
        onRefresh: cubit.getAlbums,
        child: ListView.separated(
            itemBuilder: (context, index) {
              if((index + 1) == cubit.aLbums.length){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    buildAlbum(context, cubit.aLbums[index],cubit: cubit),
                    SizedBox(height: 50,)
                  ],
                );
              }
              return buildAlbum(context, cubit.aLbums[index],cubit: cubit);
            },
            separatorBuilder: (context, index) => SizedBox(
              width: double.infinity,
              height: 0,
            ),
            itemCount: cubit.aLbums.length),
      ),
    );

    }
    );
  }
}