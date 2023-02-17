import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class VideoScreen extends StatelessWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Center();
      },
    );
  }
}
