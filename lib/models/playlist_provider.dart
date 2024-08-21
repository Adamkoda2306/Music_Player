import 'package:audioplayers/audioplayers.dart';
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
        audioPath: "audio/Yaalo_Yaalaa.mp3"),

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
  // audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  //durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  //constructors
  PlaylistProvider() {
    listenToDuration();
  }

  //initially not playing
  bool _isPlaying = false;

  // play the song
  void play() async {
    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  //pause current song
  void pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // resume playing
  void resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  //pause or resume
  void PausedOrResume() async {
    if (_isPlaying) {
      pause();
    } else {
      resume();
    }
    notifyListeners();
  }

  // seek to a specific position in the current song
  void seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  //play next song
  void playNext() {
    if (_currentSongIndex != null) {
      if (_currentSongIndex! < _playlist.length - 1) {
        currentSongIndex = _currentSongIndex! + 1;
      } else {
        currentSongIndex = 0;
      }
    }
  }

  // play previous song
  void playPreious() async {
    if (_currentDuration.inSeconds > 2) {
      seek(Duration.zero);
    } else {
      if (_currentSongIndex! > 0) {
        currentSongIndex = _currentSongIndex! - 1;
      } else {
        currentSongIndex = _playlist.length - 1;
      }
    }
  }

  //listen to durations
  void listenToDuration() {
    // listen to total duration
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    // listen to current duration
    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    //listen for song completion
    _audioPlayer.onPlayerComplete.listen((event) {
      playNext();
    });
  }

  //dispose audio player

  /*
    G E T T E R S
  */

  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;

  /*
    S E T T E R S
  */

  set currentSongIndex(int? newIndex) {
    //update current song index
    _currentSongIndex = newIndex;

    if (newIndex != null) {
      play();
    }

    //update UI
    notifyListeners();
  }
}
