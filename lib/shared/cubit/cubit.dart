import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:modio/screens/audio_page/audio_screen.dart';
import 'package:modio/screens/discover_sceen/discover_screen.dart';
import 'package:modio/screens/home_screen/home_screen.dart';
import 'package:modio/screens/user_screen/user_screen.dart';
import 'package:modio/screens/video_screen/video_screen.dart';
import 'package:modio/shared/componants.dart';
import 'package:modio/shared/cubit/status.dart';
import 'package:modio/shared/network/local/cache_helper.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ModioCubit extends Cubit<ModioStates> {
  ModioCubit() : super(initialStates());

  static ModioCubit get(context) => BlocProvider.of(context);

  int crntIndex = 0;

  var playlistTtleController = TextEditingController();

  var formKey = GlobalKey<FormState>();

  static bool? webFinish = false;

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000))
    ..enableZoom(true)
    ..canGoBack()
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (int progress) {
          // Update loading bar.
        },
        onPageStarted: (String url) {
          webFinish = false;
        },
        onPageFinished: (String url) {
          webFinish = true;
        },
        onWebResourceError: (WebResourceError error) {
        },
      ),
    );

  bool? getProgress () {
    return webFinish;
  }


  Future<void> setUrl(String url) async{
    await controller.loadRequest(Uri.parse(url));
  }

  List<BottomNavigationBarItem> bottomBarItems = [
    BottomNavigationBarItem(icon: Icon(Icons.audiotrack),label: "audio",backgroundColor: HexColor("191E5D"),),
    // BottomNavigationBarItem(icon: Icon(Icons.video_collection),label: "videos",backgroundColor: HexColor("191E5D"),),
    BottomNavigationBarItem(icon: Icon(Icons.cloud_circle),label: "discover",backgroundColor: HexColor("191E5D"),),
    BottomNavigationBarItem(icon: Icon(Icons.settings),label: "settings",backgroundColor: HexColor("191E5D"),),
  ];

  List<Widget> screens = [
    HomeScreen(),
    // VideoScreen(),
    DiscoverScreen(),
    UserScreen()
  ];

  void changeBtmBar(int index){
    if(crntIndex != index){
      crntIndex = index;
    }
    emit(ModioChangeBtmBarStates());
  }


  final OnAudioQuery _audioQuery = new OnAudioQuery();

  // final AudioPlayer _player  = AudioPlayer();
  SongModel? currentAudio;
  List<SongModel> audios = [];
  List<AlbumModel> aLbums = [];
  List<ArtistModel> artists = [];
  List<PlaylistModel> playlist = [];
  List<SongModel> audiosPage = [];

  List<SongModel> newPlylistSongs = [];

  Future<void> getAll()async {
    emit(ModioAudiosLoadingStates());
    await requestPremision();
    audios.clear();
    await _audioQuery.querySongs(
        sortType: SongSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
    ).then((value) {
      for(int i = 0 ; i < value.length;i++){
        if (value[i].data.contains("ringtone") || value[i].data.contains("Tones") || value[i].data.contains("ogg") || value[i].isRingtone! || value[i].isNotification! || value[i].isAlarm!) {
      }
      else if(value[i].fileExtension.contains("mp3")){
        audios.add(value[i]);
      }
      }
    });
    aLbums.clear();
    _audioQuery.queryAlbums(
        sortType: AlbumSortType.NUM_OF_SONGS,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
    ).then((value) {
      aLbums = value;
    });
    artists.clear();
    _audioQuery.queryArtists(
        sortType: ArtistSortType.NUM_OF_TRACKS,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
    ).then((value) {
      artists = value;
    });
    playlist.clear();
    _audioQuery.queryPlaylists(
        sortType: PlaylistSortType.DATE_ADDED,
        orderType: OrderType.DESC_OR_GREATER,
        uriType: UriType.EXTERNAL,
        ignoreCase: true
    ).then((value) {
      playlist = value;
    });
    emit(ModioAudiosDoneStates());
  }

  Future<void> getAudios() async{
    emit(ModioAudiosLoadingStates());
    await requestPremision();
    audios.clear();
     await _audioQuery.querySongs(
       sortType: SongSortType.DATE_ADDED,
       orderType: OrderType.DESC_OR_GREATER,
       uriType: UriType.EXTERNAL,
       ignoreCase: true
     ).then((value) {
       for(int i = 0 ; i < value.length;i++){
         if (value[i].data.contains("ringtone") || value[i].data.contains("Tones") || value[i].data.contains("ogg") || value[i].isRingtone! || value[i].isNotification! || value[i].isAlarm!) {
         }
         else if(value[i].fileExtension.contains("mp3")){
           audios.add(value[i]);
         }
       }
       currentList = audios;
     });
    emit(ModioAudiosDoneStates());
  }
  Future<void> getAlbums() async{
    emit(ModioPlaylistLoadingStates());
    await requestPremision();
    aLbums.clear();
     await _audioQuery.queryAlbums(
         sortType: AlbumSortType.ARTIST,
         orderType: OrderType.DESC_OR_GREATER,
         uriType: UriType.EXTERNAL,
         ignoreCase: true
    ).then((value) {
      aLbums = value;
     });
    emit(ModioAlbumsDoneStates());
  }
  Future<void> getArtist() async{
    emit(ModioArtistLoadingStates());
    await requestPremision();
    artists.clear();
     await _audioQuery.queryArtists(
         sortType: ArtistSortType.NUM_OF_TRACKS,
         orderType: OrderType.DESC_OR_GREATER,
         uriType: UriType.EXTERNAL,
         ignoreCase: true
    ).then((value) {
       artists = value;
     });
    emit(ModioArtistsDoneStates());
  }
  Future<void> getPlaylist() async{
    await requestPremision();
    playlist.clear();
     await _audioQuery.queryPlaylists(
         sortType: PlaylistSortType.DATE_ADDED,
         orderType: OrderType.DESC_OR_GREATER,
         uriType: UriType.EXTERNAL,
         ignoreCase: true
    ).then((value) {
      playlist = value;
     });
    emit(ModioPlaylistsDoneStates());
  }

  Future<SongModel?> getAudiosFrom(int id,context) async {
    requestPremision().then((value) {
      for(int i = 0; i < audios.length;i++){
        if(id == audios[i].id){
          return audios[i];
        }
      }
      emit(ModioAudiosDoneStates());
    });
    return null;
  }

  void getAudiosFromPlaylist(PlaylistModel plylist) async{
    emit(ModioAudiosLoadingStates());
    await requestPremision();
    audiosPage.clear();
     await _audioQuery.queryAudiosFrom(
       AudiosFromType.PLAYLIST,
       plylist.playlist,
       sortType: SongSortType.DATE_ADDED,
       orderType: OrderType.DESC_OR_GREATER,
       ignoreCase: true,
     ).then((value) {
       audiosPage = value;
     });
    emit(ModioAudiosDoneStates());
  }
  void getAudiosFromArtist(ArtistModel artist) async{
    emit(ModioAudiosLoadingStates());
    await requestPremision();
    audiosPage.clear();
     await _audioQuery.queryAudiosFrom(
         AudiosFromType.ARTIST_ID,
         artist.id,
         sortType: SongSortType.DATE_ADDED,
         orderType: OrderType.DESC_OR_GREATER,
         ignoreCase: true,
     ).then((value) {
       audiosPage = value;
     });
    emit(ModioAudiosDoneStates());
  }
  void getAudiosFromAlbums(AlbumModel album) async{
    emit(ModioAudiosLoadingStates());
    await requestPremision();
    audiosPage.clear();
     await _audioQuery.queryAudiosFrom(
       AudiosFromType.ALBUM_ID,
       album.id,
       sortType: SongSortType.DATE_ADDED,
       orderType: OrderType.DESC_OR_GREATER,
       ignoreCase: true,
     ).then((value) {
       audiosPage = value;
     });
    emit(ModioAudiosDoneStates());
  }

  void addPlaylist() async {
    if(playlistTtleController.text.isNotEmpty){
     await _audioQuery.createPlaylist(playlistTtleController.text);
    }
    emit(ModioPlaylistNewStates());
  }
  Future<void> addToPLaylsit (PlaylistModel playlist, SongModel audio) async {
    {
       await _audioQuery.addToPlaylist(playlist.id,audio.id);
       await requestPremision();
       audiosPage.clear();
       await _audioQuery.queryAudiosFrom(
         AudiosFromType.PLAYLIST,
         playlist.playlist,
         sortType: SongSortType.DATE_ADDED,
         orderType: OrderType.DESC_OR_GREATER,
         ignoreCase: true,
       ).then((value) {
         newPlylistSongs = value;
       });
      emit(ModioSongPlaylistAddedStates());
    }
  }
  void renamePlaylist(int playlistId,String newName)async{
    await _audioQuery.renamePlaylist(playlistId, newName);
    emit(ModioPlaylistRenamedStates());
  }

  bool checkSongClicked(SongModel son){
    for(int i = 0; i < newPlylistSongs.length;i++){
      if(son.id == newPlylistSongs[i].id){
        return true;
      }
    }
    return false;
  }

  bool showplaylistactions = false;

  void deletePlaylist(int playlistid) async {
    await _audioQuery.removePlaylist(playlistid);
    showplaylistactions = true;
    emit(ModioPlaylistDeletedStates());
  }

  Future<void> requestPremision() async {
    if(!kIsWeb){
      bool permStates = await _audioQuery.permissionsStatus();
      if(!permStates){
        await _audioQuery.permissionsRequest();
      }
    }
  }


  var audioManager = AudioPlayer();

  int currentAud = 0;

  Future<void> setID ({int? fromShared,int? id}) async {
      if(fromShared != null)
      {
        currentAud = fromShared;
       for(int i = 0 ; i < audios.length;i++){
          if(audios[i].id == currentAud){
            currentAudio = audios[i];
          }
        }
      }
      else
      {
        currentAud = id!;
        for(int i = 0 ; i < audios.length;i++){
          if(audios[i].id == currentAud){
            currentAudio = audios[i];
          }
        }
        cacheHelper.putSongData(key: "crntId", value: currentAud).then((value) {
        });
      }
    }


  bool isPlaying = true;

  Future<void> pauseAudio() async {
    if(audioManager.state == PlayerState.playing && isPlaying){
      await audioManager.pause();
      isPlaying = !isPlaying;
    }else{
      await audioManager.play(audioManager.source!);
      isPlaying = !isPlaying;
    }

    emit(ModioChangePlayerStates());
  }

  List<SongModel> currentList = [];

  Future<void> goNext(SongModel aud,context,{bool isFinshed = false}) async {
    if(aud.id == currentList.last.id){
      await audioManager.stop();
      await audioManager.setSourceUrl(currentList.first.data);
      await audioManager.play(audioManager.source!);
      currentAudio = currentList.first;
      setID(id : currentList.first.id);
      Navigator.pop(context);
      await navigatorGoto(context, AudioScreen(song: currentList.first));
    }
    // else if(isFinshed && audioManager.){
    //   for(int i = 0; i < audios.length;i++){
    //     if(aud.id == audios[i].id){
    //       await audioManager.stop();
    //       await audioManager.setSourceDeviceFile(audios[i+1].data);
    //       await navigatorGoto(context, AudioScreen(song: audios[i+1]));
    //       await audioManager.play(audioManager.source!);
    //     }
    //   }
    // }
    else{
      for(int i = 0; i < currentList.length;i++){
        if(aud.id == currentList[i].id){
          await audioManager.stop();
          await audioManager.setSourceUrl(currentList[i+1].data);
          await audioManager.play(audioManager.source!);
          currentAudio = currentList[i+1];
          setID(id : currentList[i+1].id);
          Navigator.pop(context);
          await navigatorGoto(context, AudioScreen(song: currentList[i+1]));
        }
      }
    }
    emit(ModioNextPlayerStates());
  }
  Future<void> goPrevious(SongModel aud,context) async {
    if(aud.id == currentList.first.id){
      await audioManager.stop();
      await audioManager.setSourceUrl(currentList.last.data);
      await audioManager.play(audioManager.source!);
      currentAudio = currentList.last;
      setID(id : currentList.last.id);
      Navigator.pop(context);
      await navigatorGoto(context, AudioScreen(song: currentList.last));
    }else{
      for(int i = 0; i < currentList.length;i++){
        if(aud.id == currentList[i].id){
          await audioManager.stop();
          await audioManager.setSourceUrl(currentList[i-1].data);
          await audioManager.play(audioManager.source!);
          currentAudio = currentList[i-1];
          setID(id: currentList[i-1].id);

          Navigator.pop(context);
          await navigatorGoto(context, AudioScreen(song: currentList[i-1]));
        }
      }
    }
    emit(ModioPreviousPlayerStates());
  }

  // late VideoPlayerController videocontroller;
  //
  //
  // FetchAllVideos ob =  FetchAllVideos();
  // List videos = [];
  // Future<void> getVideos () async {
  //   videos = await ob.getAllVideos();
  //
  // }
  // void playVideo () {
  //   videocontroller = VideoPlayerController.network("http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")..initialize().then((value) {
  //     print("Play");
  //     emit(ModioAudiosDoneStates());
  //   });
  // }


//Contact Form

  var contactFormKey = GlobalKey<FormState>();

  var subjectController = TextEditingController();

  var bodyController = TextEditingController();



  // void sendMail (String body, String subject) async {
  //   final Email email = Email(
  //     body: body,
  //     subject: subject,
  //     recipients: ["abdo.morsy.2722002@gmail.com"],
  //     attachmentPaths: ['/path/to/attachment.zip'],
  //     isHTML: false,
  //   );
  //   await FlutterEmailSender.send(email);
  // }

}