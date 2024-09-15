import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music_player/models/song.dart';

class PlaylistProvider extends ChangeNotifier {
  // Playlists of the songs
  final List<Song> _playlist = [
    Song(
        songName: "Ammayi",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Ammayi.mp3"),

    Song(
        songName: "Evarevaro",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Evarevaro.mp3"),

    Song(
        songName: "Ney Verey",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Ney_Veyrey.mp3"),

    Song(
        songName: "Yaalo Yaalaa",
        albumName: "Animal",
        albumArtImagePath: "assets/images/Animal.jpeg",
        audioPath: "audio/Yaalo_Yaalaa.mp3"),

    Song(
        songName: "Chuttamalle",
        albumName: "Devara",
        albumArtImagePath: "assets/images/Devara.jpg",
        audioPath: "audio/Chuttamalle.mp3"),

    Song(
        songName: "Ee Raathale",
        albumName: "Radhe Shyam",
        albumArtImagePath: "assets/images/Radhe_Shyam.jpg",
        audioPath: "audio/Ee_Raathale.mp3"),

    Song(
        songName: "Nagumomu Thaarale",
        albumName: "Radhe Shyam",
        albumArtImagePath: "assets/images/Radhe_Shyam.jpg",
        audioPath: "audio/Nagumomu_Thaarale.mp3"),

    Song(
        songName: "Hoyna Hoyna",
        albumName: "Nani's Gang Leader",
        albumArtImagePath: "assets/images/Nani_GangLeader.jpg",
        audioPath: "audio/Hoyna_Hoyna.mp3"),

    Song(
        songName: "Ninnu Chuse Anandamlo",
        albumName: "Nani's Gang Leader",
        albumArtImagePath: "assets/images/Nani_GangLeader.jpg",
        audioPath: "audio/Ninnu_Chuse_Anandamlo.mp3"),

    Song(
        songName: "Poolamme Pilla",
        albumName: "Hanu-Man",
        albumArtImagePath: "assets/images/Hanu_Man.jpg",
        audioPath: "audio/Poolamme_Pilla.mp3"),

    Song(
        songName: "Neelo Valapu",
        albumName: "Robo",
        albumArtImagePath: "assets/images/Robo.jpg",
        audioPath: "audio/Neelo_Valapu.mp3"),

    Song(
        songName: "Sarimapa",
        albumName: "Saripodha Sanivaram",
        albumArtImagePath: "assets/images/Saripodha_Sanivaram.jpg",
        audioPath: "audio/Sarimapa.mp3"),

    Song(
        songName: "Ullaasam",
        albumName: "Saripodha Sanivaram",
        albumArtImagePath: "assets/images/Saripodha_Sanivaram.jpg",
        audioPath: "audio/Ullaasam.mp3"),
  ];

  int? _currentSongIndex;
  List<Song> _queue = [];

  // Audio player
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Durations
  Duration _currentDuration = Duration.zero;
  Duration _totalDuration = Duration.zero;

  // Constructor
  PlaylistProvider() {
    _listenToDuration();
  }

  // Initially not playing
  bool _isPlaying = false;
  bool _isShuffling = false;
  bool _isRepeating = false;

  // Play the song
  Future<void> play() async {
    if (_currentSongIndex == null) return; // No song selected

    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Replay the song
  Future<void> replay() async {
    if (_currentSongIndex == null) return; // No song selected

    final String path = _playlist[_currentSongIndex!].audioPath;
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(path));
    _isPlaying = true;
    notifyListeners();
  }

  // Pause current song
  Future<void> pause() async {
    await _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }

  // Resume playing
  Future<void> resume() async {
    await _audioPlayer.resume();
    _isPlaying = true;
    notifyListeners();
  }

  // Pause or resume
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await pause();
    } else {
      await resume();
    }
  }

  // Seek to a specific position in the current song
  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  // Play next song
  void playNext() {
    if (_queue.isNotEmpty) {
      _currentSongIndex = _playlist.indexOf(_queue.removeAt(0)); // Get the next song in the queue
    } else if (_isShuffling) {
      _currentSongIndex = DateTime.now().millisecondsSinceEpoch % _playlist.length; // Shuffle to a random song
    } else {
      // Default to playing the next song in the playlist in order
      if (_currentSongIndex != null) {
        _currentSongIndex = (_currentSongIndex! + 1) % _playlist.length;
      }
    }
    play(); // Play the selected song
  }


  // Play previous song
  Future<void> playPrevious() async {
    if (_currentDuration.inSeconds > 2) {
      await seek(Duration.zero);
    } else {
      _currentSongIndex = (_currentSongIndex == 0)
          ? _playlist.length - 1
          : _currentSongIndex! - 1;
    }
    play();
  }

  // Listen to durations
  void _listenToDuration() {
    _audioPlayer.onDurationChanged.listen((newDuration) {
      _totalDuration = newDuration;
      notifyListeners();
    });

    _audioPlayer.onPositionChanged.listen((newPosition) {
      _currentDuration = newPosition;
      notifyListeners();
    });

    _audioPlayer.onPlayerComplete.listen((event) {
      if (_isRepeating) {
        replay(); // Replay the current song if repeat mode is enabled
      } else {
        // Add the song back to the queue and play the next song
        final completedSong = _playlist[_currentSongIndex!];
        addToQueue(completedSong); // Add the completed song back to the queue
        playNext(); // Play the next song in the queue
      }
    });

  }

  // Toggle shuffle
  void toggleShuffle() {
    _isShuffling = !_isShuffling;
    notifyListeners();
  }

  // Toggle repeat
  void toggleRepeat() {
    _isRepeating = !_isRepeating;
    notifyListeners();
  }

  // Play from the queue
  void playFromQueue() {
    if (_queue.isNotEmpty) {
      _currentSongIndex = _playlist.indexOf(_queue.removeAt(0));
      play();
    }
  }

  // Add song to the queue
  void addToQueue(Song song) {
    if (!_queue.contains(song)) {
      _queue.add(song);
      notifyListeners();
    }
  }

  // Remove song from the queue
  void removeFromQueue(Song song) {
    _queue.remove(song);
    notifyListeners();
  }

  // Add song to the queue and play next
  void playNextInQueue(Song song) {
    if (!_queue.contains(song)) {
      _queue.insert(0, song);
      notifyListeners();
    }
  }

  // Dispose audio player
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  // Getters
  List<Song> get playlist => _playlist;
  int? get currentSongIndex => _currentSongIndex;
  bool get isPlaying => _isPlaying;
  bool get isShuffling => _isShuffling;
  bool get isRepeating => _isRepeating;
  Duration get currentDuration => _currentDuration;
  Duration get totalDuration => _totalDuration;
  List<Song> get queue => _queue;

  // Setters
  set currentSongIndex(int? newIndex) {
    _currentSongIndex = newIndex;
    if (newIndex != null) play();
    notifyListeners();
  }
}
