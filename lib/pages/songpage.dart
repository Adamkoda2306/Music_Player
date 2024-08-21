import 'package:flutter/material.dart';
import 'package:music_player/components/neu_box.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:provider/provider.dart';

class Songpage extends StatelessWidget {
  const Songpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PlaylistProvider>(builder: (context, value, child) {
      // get playlist
      final playlist = value.playlist;

      // get current song
      final currentSong = playlist[value.currentSongIndex ?? 0];

      // return Scafflod UI
      return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 0, 25, 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // appbar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // back btn
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.arrow_back_ios),
                    ),

                    //title
                    Text("P L A Y L I S T"),

                    // menubtn
                    IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.menu),
                    )
                  ],
                ),

                // album artwork
                NeuBox(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(currentSong.albumArtImagePath),
                      ),

                      //song and artist name
                      Column(
                        children: [
                          Text(
                            currentSong.songName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                          Text(
                            currentSong.albumName,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),
                //song duration progress
                Column(
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // start time
                          Text("0:00"),

                          // shuffle icon
                          Icon(Icons.shuffle),

                          //repeat icon
                          Icon(Icons.repeat),

                          // end time
                          Text("0:00"),
                        ],
                      ),
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        thumbShape:
                            const RoundSliderThumbShape(enabledThumbRadius: 0),
                      ),
                      child: Slider(
                        min: 0,
                        max: 100,
                        value: 50,
                        activeColor: Colors.green,
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),

                //playback controls
                Row(
                  children: [
                    // skip previous
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: const NeuBox(
                          child: Icon(Icons.skip_previous),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // play pause
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {},
                        child: const NeuBox(
                          child: Icon(Icons.play_arrow),
                        ),
                      ),
                    ),

                    const SizedBox(width: 20),

                    //skip forward
                    Expanded(
                      child: GestureDetector(
                        onTap: () {},
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
    });
  }
}
