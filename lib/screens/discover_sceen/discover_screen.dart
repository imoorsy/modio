import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';

class DiscoverScreen extends StatelessWidget {

  List<Map<String,dynamic>> webs = [
    {
      "icon" : FontAwesomeIcons.soundcloud,
      "color": Colors.deepOrange,
      "title": "SoundCloud",
      "url" : "https://www.soundcloud.com"
    },
    {
      "icon" : FontAwesomeIcons.facebook,
      "color": Colors.blue[900]!,
      "title": "facebook",
      "url" : "https://www.facebook.com"
    },
    {
      "icon" : FontAwesomeIcons.spotify,
      "color": Colors.green[800]!,
      "title": "Spotify",
      "url" : "https://www.spotify.com"
    },
    {
      "icon" : FontAwesomeIcons.bookQuran,
      "color": Colors.lightBlue[800],
      "title": "mp3 Quran",
      "url" : "https://mp3quran.net/"
    },
    {
      "icon" : FontAwesomeIcons.youtube,
      "color": Colors.red[900]!,
      "title": "youtube",
      "url" : "https://www.youtube.com"
    },
    {
      "icon" : FontAwesomeIcons.instagram,
      "color": Colors.purpleAccent,
      "title": "instagram",
      "url" : "https://www.instagram.com"
    },
    {
      "icon" : FontAwesomeIcons.twitter,
      "color": Colors.blue[700]!,
      "title": "twitter",
      "url" : "https://www.twitter.com"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        ModioCubit cubit = ModioCubit.get(context);
        return Container(
          // padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  HexColor("040305").withOpacity(0.9),
                  HexColor("283CAF").withOpacity(0.5),
                ],
              )),
          child: Center(
            child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 20,mainAxisExtent: 120),
            padding: EdgeInsets.all(20),
            itemBuilder: (BuildContext context, int index) => buildDiscoverItem(context, webs[index],cubit: cubit),
            itemCount: webs.length,
            ),
          ),
        );
      },
    );
  }
}
