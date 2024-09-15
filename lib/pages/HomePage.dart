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

  // Go to a song and add it to the queue if not already present
  void goToSong(int songIndex) {
    // Get the selected song
    Song selectedSong = playlistProvider.playlist[songIndex];

    // Check if the song is already in the queue
    if (!playlistProvider.queue.contains(selectedSong)) {
      playlistProvider.addToQueue(selectedSong); // Add the song to the queue
    }

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

  // Handle menu item selection
  void handleMenuSelection(String value, Song song) {
    switch (value) {
      case 'Add to Queue':
        playlistProvider.addToQueue(song); // Ensure this method exists in PlaylistProvider
        break;
      case 'Play Next':
        playlistProvider.playNextInQueue(song); // Adjust to correct method if necessary
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final inversePrimaryColor = Theme.of(context).colorScheme.inversePrimary;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
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
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.secondary,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
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
                      leading: Image.asset(song.albumArtImagePath),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) => handleMenuSelection(value, song),
                        itemBuilder: (BuildContext context) {
                          return [
                             PopupMenuItem<String>(
                              value: 'Add to Queue',
                              child: Text(
                                'Add to Queue',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                             PopupMenuItem<String>(
                              value: 'Play Next',
                              child: Text(
                                  'Play Next',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                          ];
                        },
                        icon: Icon(
                          Icons.more_vert,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
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
                  // Navigate to the Songpage when the bottom bar is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Songpage(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary.withOpacity(0.6), // Glass effect background
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
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
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              currentSong.albumName,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.inversePrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      // Play previous button
                      IconButton(
                        icon: Icon(
                          Icons.skip_previous,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: () {
                          value.playPrevious(); // Ensure this method exists in PlaylistProvider
                        },
                      ),
                      // Play/Pause button
                      IconButton(
                        icon: Icon(
                          value.isPlaying ? Icons.pause : Icons.play_arrow,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: () {
                          value.togglePlayPause(); // Ensure this method exists in PlaylistProvider
                        },
                      ),
                      // Play next button
                      IconButton(
                        icon: Icon(
                          Icons.skip_next,
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                        onPressed: () {
                          value.playNext(); // Ensure this method exists in PlaylistProvider
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
