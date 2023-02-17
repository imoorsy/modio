import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class ModioLayout extends StatelessWidget {
  const ModioLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit,ModioStates>(
      listener:(context,state) {},
      builder:(context,state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Scaffold(
          backgroundColor: HexColor("040305"),
          appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text("Modio",style: Theme.of(context).textTheme.titleLarge,),
          titleSpacing: 20,
          toolbarHeight: 90,
          actions: [
            Icon(Icons.search,size: 30,),
            SizedBox(width: 20,)
          ],
        ),
          body: cubit.screens[cubit.crntIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.crntIndex,
            elevation: 100,
            backgroundColor: HexColor("191E5D"),
            unselectedItemColor: HexColor("7F7092"),
            showUnselectedLabels: false,
            items: cubit.bottomBarItems,
            onTap: (value) {
              cubit.changeBtmBar(value);
            },
          ),
      );
      },
    );
  }
}
