import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Playlists of the songs
  final List<Song> _playlist = [
    // Song 1
    Song(
        songName: "Ammayi",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Ammayi.mp3"),

    // Song 2
    Song(
        songName: "Evarevaro",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Evarevaro.mp3"),

    // Song 3
    Song(
        songName: "Ney Verey",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Ney_Veyrey.mp3"),

    // Song 4
    Song(
        songName: "Yaalo Yaalaa",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Yaalo_Yaala.mp3"),

    // Song 5
    Song(
        songName: "Chuttamalle",
        albumName: "Devara",
        albumArtImagePath: "assets/images/Devara.jpg",
        audioPath: "audio/Chuttamalle.mp3"),

    // Song 6
    Song(
        songName: "Ee Raathale",
        albumName: "Radhe Shyam",
        albumArtImagePath: "assets/images/Radhe_Shyam.jpg",
        audioPath: "audio/Ee_Raathale.mp3"),

    // Song 7
    Song(
        songName: "Nagumomu Thaarale",
        albumName: "Radhe Shyam",
        albumArtImagePath: "assets/images/Radhe_Shyam.jpg",
        audioPath: "audio/Nagumomu_Thaarale.mp3"),

    // Song 8
    Song(
        songName: "Hoyna Hoyna",
        albumName: "Nani's Gang Leader",
        albumArtImagePath: "assets/images/Nani_GangLeader.jpg",
        audioPath: "audio/Hoyna_Hoyna.mp3"),

    // Song 9
    Song(
        songName: "Ninnu Chuse Anandamlo",
        albumName: "Nani's Gang Leader",
        albumArtImagePath: "assets/images/Nani_GangLeader.jpg",
        audioPath: "audio/Ninnu_Chuse_Anandamlo.mp3"),

    // Song 10
    Song(
        songName: "Poolamme Pilla",
        albumName: "Hanu-Man",
        albumArtImagePath: "assets/images/Hanu_Man.jpg",
        audioPath: "audio/Poolamme_Pilla.mp3"),

    // Song 11
    Song(
        songName: "Neelo Valapu",
        albumName: "Robo",
        albumArtImagePath: "assets/images/Robo.jpg",
        audioPath: "audio/Neelo_Valapu.mp3"),
  ];

  int? _currentSongIndex;

  /*
    A U D I O P L A Y E R
  */

  /*
    G E T T E R S
  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;

  /*
    S E T T E R S
  */

  set currentSongIndex(int? newIndex) {
    //update current song index
    _currentSongIndex = newIndex;

    //update UI
    notifyListeners();
  }
}
