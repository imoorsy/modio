import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/layout/modio_layout/modio_layout.dart';
import 'package:modio/screens/home_screen/home_screen.dart';
import 'package:modio/shared/bloc_observer.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:modio/shared/network/local/cache_helper.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  await cacheHelper.init();
  int? crid = cacheHelper.getSongData(key: "crntId");
  runApp(MyApp(crid: crid ?? 0,));
}

class MyApp extends StatelessWidget {
  final int? crid;
  MyApp({this.crid});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ModioCubit>(
      create: (BuildContext context) => ModioCubit()..setID(fromShared: crid)..getAll(),
      child: BlocConsumer<ModioCubit,ModioStates>(
        listener: (context,state) {},
        builder: (context,state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Modio',
          theme: ThemeData(
            textTheme: TextTheme(
              titleLarge: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
              titleSmall: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelLarge: TextStyle(
                color: HexColor("283CAF"),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              labelSmall: TextStyle(
                fontSize: 16,
                color: HexColor("7F7092")
              ),
              labelMedium: TextStyle(
                fontSize: 16,
                color: Colors.white
              ),
              headlineSmall: TextStyle(
                  fontSize: 12,
                  color: HexColor("7F7092"),
              )
            )
          ),
          home: ModioLayout(),
        ),
      ),
    );
  }
}

