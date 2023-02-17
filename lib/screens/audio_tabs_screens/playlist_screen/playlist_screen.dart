import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/screens/song_playlist_screen/song_playlist_screen.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:modio/shared/cubit/status.dart';


class PLaylistScreen extends StatelessWidget {
  const PLaylistScreen({Key? key}) : super(key: key);

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
              onRefresh: cubit.getPlaylist,
              child: ListView(
                children: [
                  InkWell(
                    child: Container(
                      child: Row(
                        children: [
                          Container(
                            child: Center(
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                Colors.grey.shade50.withOpacity(0.5)),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "new Playlist",
                            style: Theme.of(context).textTheme.subtitle2,
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(20),
                    ),
                    onTap: () {
                      showDialog(context: context, builder: (context) => SimpleDialog(
                        backgroundColor: Colors.transparent,
                        children: [
                          Center(
                            child: Container(
                              padding: EdgeInsets.all(40),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: HexColor("040305"),
                              ),
                              child: Form(
                                key: cubit.formKey,
                                child: Column(
                                  children: [
                                    Text("set playlist name",style: Theme.of(context).textTheme.titleSmall,),
                                    SizedBox(height: 20,),
                                    defaultTextFormField(
                                        context,
                                        controller: cubit.playlistTtleController,
                                        keyboardtype: TextInputType.text,
                                        validator: (value){
                                          if(value.isEmpty) {
                                            return "Name Can't Be Empty";
                                          }
                                          return null;
                                        },
                                        prefix: Icons.title,
                                        labelText: 'Enter Playlist Name ...'),
                                    SizedBox(height: 20,),
                                    MaterialButton(
                                      onPressed: () async{
                                        if(cubit.formKey.currentState!.validate() || cubit.formKey == null){
                                          cubit.addPlaylist();
                                          await cubit.getPlaylist().then((value) {
                                            Navigator.pop(context);
                                            cubit.playlistTtleController.text = "";
                                            navigatorGoto(context, SongPlaylistScreen(playlist:cubit.playlist.last));
                                          });

                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 30),
                                        child: Text(
                                          "add PlayList",
                                          style: Theme.of(context).textTheme.titleSmall,
                                        ),
                                        decoration: BoxDecoration(
                                          color: HexColor("283CAF"),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ));
                    },
                  ),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        if((index + 1) == cubit.playlist.length){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              buildPlaylist(context, cubit.playlist[index], cubit: cubit),
                              SizedBox(height: 50,)
                            ],
                          );
                        }
                        return buildPlaylist(
                            context, cubit.playlist[index],
                            cubit: cubit);
                      },
                      separatorBuilder: (context, index) => const SizedBox(
                        width: double.infinity,
                        height: 0,
                      ),
                      itemCount: cubit.playlist.length)
                ],
              ),
            ),
          );
        }
    );
  }
}
