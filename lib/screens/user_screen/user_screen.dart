import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/screens/audio_page/audio_screen.dart';
import 'package:modio/screens/contact_screen/contact_screen.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share_plus/share_plus.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ModioCubit, ModioStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Container(
          // padding: EdgeInsets.only(top: 10),
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              HexColor("040305").withOpacity(0.9),
              HexColor("283CAF").withOpacity(0.5),
            ],
          )),
          child: Column(
            children: [
              ListTile(
                title: Text("Contact us",style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal
                ),),
                leading: Icon(Icons.message_outlined,size: 30,),
                trailing:Icon(Icons.arrow_forward,size: 30,),
                contentPadding: EdgeInsets.all(10),
                iconColor: Colors.grey,
                onTap: () async {
                  await Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: ContactScreen(),duration: Duration(milliseconds: 500)));
                },
              ),
              // ListTile(
              //   title: Text("Share app",style: Theme.of(context).textTheme.titleMedium!.copyWith(
              //       fontWeight: FontWeight.normal
              //   ),),
              //   leading: Icon(Icons.share,size: 30,),
              //   trailing:Icon(Icons.arrow_forward,size: 30,),
              //   contentPadding: EdgeInsets.all(10),
              //   iconColor: Colors.grey,
              //   onTap: (){
              //     Share.shareXFiles();
              //   },
              // ),
              ListTile(
                title: Text("About us",style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal
                ),),
                leading: Icon(Icons.info_outline,size: 30,),
                trailing:Icon(Icons.arrow_forward,size: 30,),
                contentPadding: EdgeInsets.all(10),
                iconColor: Colors.grey,
                onTap: (){
                  showDialog(context: context, builder: (context) => Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width *0.6,
                      padding: EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: RadialGradient(
                          radius: 0.3,
                            colors: [
                          HexColor("040305"),
                          HexColor("283CAF"),
                        ])
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("Modio" , style: Theme.of(context).textTheme.titleLarge,),
                          SizedBox(height: 20,),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 20,),
                          Text("version 1.0",style: Theme.of(context).textTheme.labelMedium,),
                          SizedBox(height: 10,),
                          Text("Copyright @AMorsy",style: Theme.of(context).textTheme.labelSmall,),
                        ],
                      ),
                    ),
                  ));
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
