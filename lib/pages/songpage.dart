import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class Songpage extends StatelessWidget {
  const Songpage({super.key});

  // Convert duration to min:seconds format
  String formatTime(Duration duration) {
    String twoDigitMinutes = duration.inMinutes.toString();
    String twoDigitSeconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;
        final currentSong = playlist[value.currentSongIndex ?? 0];
        final albumName = currentSong.albumName;

        // Filter songs to show only those from the same album
        final albumSongs =
            playlist.where((song) => song.albumName == albumName).toList();

        return Scaffold(
          endDrawer: Drawer(
            width: 220.0,
            child: SafeArea(
              child: ListView.builder(
                itemCount: albumSongs.length,
                itemBuilder: (context, index) {
                  final song = albumSongs[index];
                  return ListTile(
                    title: Text(song.songName),
                    subtitle: Text(song.albumName),
                    leading: Image.asset(
                      song.albumArtImagePath,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    onTap: () {
                      // Set the current song index to the selected song and play it
                      value.currentSongIndex = playlist.indexOf(song);
                      Navigator.pop(context); // Close the drawer
                    },
                  );
                },
              ),
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AppBar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      const Text("P L A Y L I S T"),
                      Builder(builder: (context) {
                        return IconButton(
                          onPressed: () {
                            Scaffold.of(context).openEndDrawer();
                          },
                          icon: const Icon(Icons.menu),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Album artwork
                  NeuBox(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.asset(currentSong.albumArtImagePath),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Text(
                              currentSong.songName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(currentSong.albumName),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 25),
                  // Song duration and progress
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatTime(value.currentDuration)),
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                color: value.isShuffling
                                    ? Colors.green
                                    : Colors.black,
                              ),
                              onPressed: () {
                                value.toggleShuffle();
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.repeat,
                                color: value.isRepeating
                                    ? Colors.green
                                    : Colors.black,
                              ),
                              onPressed: () {
                                value.toggleRepeat();
                              },
                            ),
                            Text(formatTime(value.totalDuration)),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 10),
                          activeTrackColor: Colors.green,
                          inactiveTrackColor: Colors.grey,
                        ),
                        child: Slider(
                          min: 0,
                          max: value.totalDuration.inSeconds.toDouble(),
                          value: value.currentDuration.inSeconds.toDouble(),
                          onChanged: (double newValue) {
                            value.seek(Duration(seconds: newValue.toInt()));
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  // Playback controls
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPreious,
                          child: const NeuBox(
                            child: Icon(Icons.skip_previous),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.PausedOrResume,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playNext,
                          child: const NeuBox(
                            child: Icon(Icons.skip_next),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
