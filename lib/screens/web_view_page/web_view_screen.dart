import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: HexColor("283CAF"),
            centerTitle: true,
            title: FutureBuilder(
              future: cubit.controller.currentUrl(),
              builder: (context,url) {
                return Text(url.data.toString(),style: Theme.of(context).textTheme.titleSmall,);
              },
            ),
            elevation: 0,
            toolbarHeight: 40,
            // centerTitle: true,
            // title: FutureBuilder(
            //   future: cubit.controller.getTitle(),
            //   builder: (context,val) => Text(val.data!,style: TextStyle(
            //     fontSize: 18,
            //     color: Colors.grey
            //
            //   ),),
            // ),
            actions: [
              IconButton(onPressed: ()async{
               await cubit.controller.goBack();
              }, icon: Icon(Icons.arrow_back_ios)),
              IconButton(onPressed: ()async{
                await cubit.controller.reload();
              }, icon: Icon(Icons.refresh)),
            ],
          ),
          extendBody: true,
          body: Stack(
            children: [
              WebViewWidget(
                controller: cubit.controller,
              ),
              BuildCondition(
                condition: cubit.getProgress(),
                builder: (context) => Center(),
                fallback: (context) => Center(child: CircularProgressIndicator()),
              ),
            ],
          ),
        );
      },
    );
  }
}
