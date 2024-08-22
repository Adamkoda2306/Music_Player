import 'package:flutter/material.dart';
import 'package:music_player/components/my_drawer.dart';
import 'package:music_player/models/playlist_provider.dart';
import 'package:music_player/models/song.dart';
import 'package:music_player/pages/songpage.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late final PlaylistProvider playlistProvider;
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Get the playlist provider
    playlistProvider = Provider.of<PlaylistProvider>(context, listen: false);

    // Add listener to search controller
    searchController.addListener(() {
      setState(() {
        searchQuery = searchController.text.toLowerCase();
        print('Search Query: $searchQuery'); // Debugging
      });
    });
  }

  // Go to a song
  void goToSong(int songIndex) {
    // Update current song index
    playlistProvider.currentSongIndex = songIndex;

    // Navigate to song page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const Songpage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final inversePrimaryColor = Theme.of(context).colorScheme.inversePrimary;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          "P L A Y L I S T",
          style: TextStyle(
            color: inversePrimaryColor,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search songs...',
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      drawer: const MyDrawer(),
      body: Column(
        children: [
          Expanded(
            child: Consumer<PlaylistProvider>(
              builder: (context, value, child) {
                // Get the playlist
                final List<Song> playlist = value.playlist;

                // Filter the playlist based on search query
                final filteredPlaylist = playlist.where((song) {
                  return song.songName.toLowerCase().contains(searchQuery) ||
                      song.albumName.toLowerCase().contains(searchQuery);
                }).toList();

                // Return list view to UI
                return ListView.builder(
                  itemCount: filteredPlaylist.length,
                  itemBuilder: (context, index) {
                    // Get individual song
                    final Song song = filteredPlaylist[index];

                    // Return list tile UI
                    return ListTile(
                      title: Text(song.songName),
                      subtitle: Text(song.albumName),
                      leading: Image.asset(song.albumArtImagePath),
                      onTap: () {
                        // Find the index of the selected song in the full playlist
                        int originalIndex = playlist.indexOf(song);
                        goToSong(originalIndex);
                      },
                    );
                  },
                );
              },
            ),
          ),
          // Bottom bar for current song details
          Consumer<PlaylistProvider>(
            builder: (context, value, child) {
              // Check if currentSongIndex is null before accessing the playlist
              final Song? currentSong = value.currentSongIndex != null
                  ? value.playlist[value.currentSongIndex!]
                  : null;

              if (currentSong == null) {
                return Container(); // Return a placeholder if no song is selected
              }

              return GestureDetector(
                onTap: () {
                  goToSong(value.currentSongIndex!);
                },
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      // Album art image
                      Image.asset(
                        currentSong.albumArtImagePath,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      // Song details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentSong.songName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              currentSong.albumName,
                              style: const TextStyle(color: Colors.black),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Play previous button
                      IconButton(
                        icon: const Icon(Icons.skip_previous),
                        onPressed: () {
                          value
                              .playPreious(); // Implement this in your provider
                        },
                      ),
                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          value.isPlaying ? Icons.pause : Icons.play_arrow,
                        ),
                        onPressed: () {
                          value
                              .PausedOrResume(); // Implement this in your provider
                        },
                      ),
                      // Play next button
                      IconButton(
                        icon: const Icon(Icons.skip_next),
                        onPressed: () {
                          value.playNext(); // Implement this in your provider
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
