import 'package:buildcondition/buildcondition.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:modio/screens/audio_page/audio_screen.dart';
import 'package:modio/screens/list_audio_screen/list_audio_screen.dart';
import 'package:modio/screens/web_view_page/web_view_screen.dart';
import 'package:modio/shared/cubit/cubit.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:page_transition/page_transition.dart';

Widget defaultTextFormField(
  context, {
  required TextEditingController controller,
  required TextInputType keyboardtype,
  ValueChanged<String>? submitFunction,
  required FormFieldValidator validator,
  required IconData prefix,
  required String labelText,
  bool isPassword = false,
  IconData? suflix,
  ValueChanged<String>? onchange,
  VoidCallback? suflixpressed,
  VoidCallback? onTap,
  String value = '',
}) =>
    TextFormField(
      controller: controller,
      keyboardType: keyboardtype,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: Theme.of(context).textTheme.labelSmall,
        prefixIcon: Icon(prefix),
        suffixIcon: suflix != null
            ? IconButton(icon: Icon(suflix), onPressed: suflixpressed)
            : null,
        border: const UnderlineInputBorder(),
      ),
      obscureText: isPassword,
      onFieldSubmitted: submitFunction,
      onChanged: onchange,
      onTap: onTap,
      validator: validator,
      style: Theme.of(context).textTheme.titleSmall,
    );

Widget buildAudioItem(context, SongModel song, ModioCubit cubit) => InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                artworkBorder: BorderRadius.circular(10),
                errorBuilder: (BuildContext context, exception, stackTrace) {
                  return const Icon(Icons.reddit);
                },
                nullArtworkWidget: Image.asset('assets/image/no-results.png'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildCondition(
                    condition: song.id == cubit.currentAud,
                    builder: (context) => Text(
                      song.title,
                      style: Theme.of(context).textTheme.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    fallback: (context) => Text(
                      song.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          song.artist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text(
                        parseTimeInSec(song.duration!.toInt()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: HexColor("7062E9"),
                  size: 30,
                )),
          ],
        ),
      ),
      onTap: () async {
        await cubit.audioManager.setSourceUrl(song.data);
        await cubit.audioManager.play(cubit.audioManager.source!);
        cubit.currentAudio = song;
        cubit.setID(id: song.id);
        cubit.currentList = cubit.audios;
        cubit.isPlaying = true;
        await Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AudioScreen(song: song),duration: Duration(milliseconds: 500)));
        // cubit.audioManager.start("file://${song.data}", "title", desc: "desc", cover: "assets/image/no-results.png").catchError((error) {print("error${error}");});
      },
    );
Widget buildBottomAudioItem(context, SongModel song, ModioCubit cubit) =>
    InkWell(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            color: HexColor("283CAF"),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            width: double.infinity,
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 50,
                  child: QueryArtworkWidget(
                    id: song.id,
                    type: ArtworkType.AUDIO,
                    artworkFit: BoxFit.cover,
                    artworkBorder: BorderRadius.circular(10),
                    errorBuilder:
                        (BuildContext context, exception, stackTrace) {
                      return const Icon(Icons.reddit);
                    },
                    nullArtworkWidget: Image.asset('assets/image/no-results.png'),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        style: Theme.of(context).textTheme.titleSmall,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        song.artist.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 12, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      await cubit.pauseAudio();
                    },
                    icon: Icon(
                      cubit.isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 30,
                      color: HexColor("7062E9"),
                    )),
              ],
            ),
          ),
        ],
      ),
      onTap: () async {
        await Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AudioScreen(song: song),duration: Duration(milliseconds: 500)));
        // cubit.audioManager.start("file://${song.data}", "title", desc: "desc", cover: "assets/image/no-results.png").catchError((error) {print("error${error}");});
      },
    );
Widget buildAudios(context, List<SongModel> audios, ModioCubit cubit) =>
    ListView.separated(
        itemBuilder: (context, index) =>
            buildAudioItem(context, audios[index], cubit),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: audios.length);

Widget buildListAudioItem(context, SongModel song, ModioCubit cubit) => InkWell(
      child: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        width: double.infinity,
        child: Row(
          children: [
            Container(
              height: 50,
              width: 50,
              child: QueryArtworkWidget(
                id: song.id,
                type: ArtworkType.AUDIO,
                artworkFit: BoxFit.cover,
                artworkBorder: BorderRadius.circular(10),
                errorBuilder: (BuildContext context, exception, stackTrace) {
                  return const Icon(Icons.reddit);
                },
                nullArtworkWidget: Image.asset('assets/image/no-results.png'),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BuildCondition(
                    condition: song.id == cubit.currentAud,
                    builder: (context) => Text(
                      song.title,
                      style: Theme.of(context).textTheme.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    fallback: (context) => Text(
                      song.title,
                      style: Theme.of(context).textTheme.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          song.artist.toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                      ),
                      Text(
                        parseTimeInSec(song.duration!.toInt()),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.favorite_border,
                  color: HexColor("7062E9"),
                  size: 30,
                )),
          ],
        ),
      ),
      onTap: () async {
        await cubit.audioManager.setSourceUrl(song.data);
        await cubit.audioManager.play(cubit.audioManager.source!);
        cubit.currentAudio = song;
        cubit.setID(id: song.id);
        cubit.currentList = cubit.audiosPage;
        navigatorGoto(context, AudioScreen(song: song));
        // cubit.audioManager.start("file://${song.data}", "title", desc: "desc", cover: "assets/image/no-results.png").catchError((error) {print("error${error}");});
      },
    );
Widget buildListAudios(context, List<SongModel> audios, ModioCubit cubit) =>
    ListView.separated(
        itemBuilder: (context, index) =>
            buildListAudioItem(context, audios[index], cubit),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: audios.length);

Widget buildSelectedAudioItem(
        context, SongModel song, PlaylistModel playlist, ModioCubit cubit) =>
    Container(
      padding: const EdgeInsets.only(left: 20, right: 20),
      width: double.infinity,
      child: Row(
        children: [
          Container(
            height: 50,
            width: 50,
            child: QueryArtworkWidget(
              id: song.id,
              type: ArtworkType.AUDIO,
              artworkFit: BoxFit.cover,
              artworkBorder: BorderRadius.circular(10),
              errorBuilder: (BuildContext context, exception, stackTrace) {
                return const Icon(Icons.reddit);
              },
              nullArtworkWidget: Image.asset('assets/image/no-results.png'),
            ),
          ),
          const SizedBox(
            width: 20,
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  song.title,
                  style: Theme.of(context).textTheme.titleSmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        song.artist.toString(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    Text(
                      parseTimeInSec(song.duration!.toInt()),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                )
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                await cubit.addToPLaylsit(playlist, song);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Added"),
                  duration: Duration(milliseconds: 200),
                ));
              },
              icon: cubit.checkSongClicked(song)
                  ? Icon(
                      Icons.add_box_rounded,
                      color: Colors.white24,
                      size: 30,
                    )
                  : Icon(
                      Icons.add_box_rounded,
                      color: HexColor("7062E9"),
                      size: 30,
                    )),
        ],
      ),
    );
Widget buildSelectedAudios(context, List<SongModel> audios, ModioCubit cubit,
        PlaylistModel playlist) =>
    ListView.separated(
        itemBuilder: (context, index) =>
            buildSelectedAudioItem(context, audios[index], playlist, cubit),
        separatorBuilder: (context, index) => const SizedBox(
              height: 10,
            ),
        itemCount: audios.length);

Widget buildNoAudios(context) => SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          const SizedBox(
            height: 150,
          ),
          Icon(
            Icons.no_cell,
            size: 200,
            color: HexColor("7F7092"),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "No Data !",
            style: Theme.of(context).textTheme.titleLarge,
          )
        ],
      ),
    );

Widget buildPlaylist(context, PlaylistModel playlist, {ModioCubit? cubit}) =>
    InkWell(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade50.withOpacity(0.5)),
              child: QueryArtworkWidget(
                id: playlist.id,
                type: ArtworkType.PLAYLIST,
                nullArtworkWidget: Image.asset("assets/image/no-results.png"),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              playlist.playlist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ))
          ],
        ),
      ),
      onTap: () {
        cubit!.getAudiosFromPlaylist(playlist);
        navigatorGoto(
            context,
            ListAudioScreen(
              listName: playlist.playlist,
            ));
      },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (context) => SimpleDialog(
            backgroundColor: Colors.transparent,
            children: [
              Container(
                color: Colors.grey[800],
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        cubit!.deletePlaylist(playlist.id);
                        cubit.getPlaylist();
                        Navigator.pop(context);
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        title: Text(
                          "delete",
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        textColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
Widget buildArtist(context, ArtistModel artist, {ModioCubit? cubit}) => InkWell(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade50.withOpacity(0.5)),
              child: QueryArtworkWidget(
                id: artist.id,
                type: ArtworkType.ARTIST,
                nullArtworkWidget: Image.asset("assets/image/no-results.png"),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
                child: Text(
              artist.artist,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle2,
            ))
          ],
        ),
      ),
      onTap: () {
        cubit!.getAudiosFromArtist(artist);
        navigatorGoto(context, ListAudioScreen(listName: artist.artist));
      },
    );
Widget buildAlbum(context, AlbumModel album, {ModioCubit? cubit}) => InkWell(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade50.withOpacity(0.5)),
              child: QueryArtworkWidget(
                id: album.id,
                type: ArtworkType.ALBUM,
                nullArtworkWidget: Image.asset("assets/image/no-results.png"),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: Text(
                album.album,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.subtitle2,
              ),
            )
          ],
        ),
      ),
      onTap: () {
        cubit!.getAudiosFromAlbums(album);
        navigatorGoto(
            context,
            ListAudioScreen(
              listName: album.album,
            ));
      },
    );

Widget buildDiscoverItem(
        context, Map model,
        {ModioCubit? cubit}) => InkWell(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomCenter, colors: [
            model["color"],
            Colors.grey,
            Colors.white,
          ]),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                model["icon"],
                color: model["color"],
                size: 50,
              ),
              SizedBox(height: 10,),
              Text(
                model["title"],
                style: Theme.of(context).textTheme.titleSmall,
              )
            ],
          ),
        ),
      ),
      onTap: () {
         cubit!.controller.clearCache().then((value) {
           cubit.setUrl(model["url"]).then((value) {
             navigatorGoto(context, WebViewScreen());
           });
         });
      },
    );

Future<void> navigatorGoto(context, Widget widget) async =>
    await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => widget,
        ));

String parseTimeInSec(int ms) {
  String data = "";
  Duration dur = Duration(milliseconds: ms);
  int hor = dur.inHours;
  int min = (dur.inMinutes) - (hor * 60);
  if (hor > 0) data += hor.toString() + ":";
  int sec = (dur.inSeconds) - (dur.inMinutes * 60);
  if (min <= 9) data += "0";
  data += min.toString() + ":";
  if (sec <= 9) data += "0";
  data += sec.toString();
  return data;
}
