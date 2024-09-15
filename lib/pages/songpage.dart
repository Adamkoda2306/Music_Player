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
    final inversePrimaryColor = Theme.of(context).colorScheme.inversePrimary;
    return Consumer<PlaylistProvider>(
      builder: (context, value, child) {
        final playlist = value.playlist;
        final currentSong = playlist[value.currentSongIndex ?? 0];
        final albumName = currentSong.albumName;

        // Filter songs to show only those from the same album
        final albumSongs = playlist.where((song) => song.albumName == albumName).toList();

        // Combine album songs from the playlist and queue to ensure no song is excluded if added to the queue
        final queueSongs = value.queue.where((song) => song.albumName != albumName).toList();
        final albumQueueSongs = albumSongs.where((song) => value.queue.contains(song)).toList();
        final combinedQueueSongs = queueSongs + albumQueueSongs;

        return Scaffold(
          endDrawer: Drawer(
            width: 250.0,
            child: SafeArea(
              child: Column(
                children: [
                  // Queue
                  Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: ListTile(
                      title: Text(
                        'Q u e u e',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: inversePrimaryColor,
                        ),
                      ),
                      tileColor: Colors.grey[200],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: combinedQueueSongs.length,
                      itemBuilder: (context, index) {
                        final song = combinedQueueSongs[index];
                        return ListTile(
                          title: Text(
                            song.songName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          subtitle: Text(
                            song.albumName,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                          leading: Image.asset(
                            song.albumArtImagePath,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              value.removeFromQueue(song);
                            },
                          ),
                          onTap: () {
                            // Play the selected song from the queue
                            value.currentSongIndex = playlist.indexOf(song);
                            Navigator.pop(context); // Close the drawer
                          },
                        );
                      },
                    ),
                  ),
                ],
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
                      Text(
                        "P L A Y L I S T",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Scaffold.of(context).openEndDrawer();
                            },
                            icon: Icon(
                              Icons.menu,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                            Text(
                              currentSong.albumName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
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
                            Text(
                              formatTime(value.currentDuration),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.shuffle,
                                color: value.isShuffling
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.inversePrimary,
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
                                    : Theme.of(context).colorScheme.inversePrimary,
                              ),
                              onPressed: () {
                                value.toggleRepeat();
                              },
                            ),
                            Text(
                              formatTime(value.totalDuration),
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          thumbShape: const RoundSliderThumbShape(
                            enabledThumbRadius: 10,
                          ),
                          activeTrackColor: Colors.green,
                          thumbColor: Colors.green,
                          inactiveTrackColor: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(25),
                              boxShadow: [
                                //darker shadow on bottom right
                                BoxShadow(
                                  color: Colors.grey.shade500,
                                  blurRadius: 15,
                                  offset: const Offset(4, 4),
                                ),
                                //lighter shadow on top left
                                BoxShadow(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  blurRadius: 15,
                                  offset: Offset(-4, -4),
                                ),
                              ]),
                          padding: const EdgeInsets.all(2),
                          child: Slider(
                            min: 0,
                            max: value.totalDuration.inSeconds.toDouble(),
                            value: value.currentDuration.inSeconds.toDouble(),
                            onChanged: (double newValue) {
                              value.seek(Duration(seconds: newValue.toInt()));
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  // Playback controls
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: value.playPrevious,
                          child: NeuBox(
                            child: Icon(
                              Icons.skip_previous,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        flex: 2,
                        child: GestureDetector(
                          onTap: value.togglePlayPause,
                          child: NeuBox(
                            child: Icon(value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            if (value.queue.isNotEmpty) {
                              value.playFromQueue(); // Play the next song from the queue
                            } else {
                              value.playNext();
                            }
                          },
                          child: NeuBox(
                            child: Icon(
                              Icons.skip_next,
                              color: Theme.of(context).colorScheme.inversePrimary,
                            ),
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
