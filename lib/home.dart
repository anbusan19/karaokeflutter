import 'package:flutter/material.dart';
import 'package:karaokeflutter/karaoke_player2.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  void _navigateToKaraokePlayer2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => KaraokePlayerScreen2()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karaoke Songs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          SongCard(
            albumCover: 'assets/album1.jpg',
            songName: 'Cinnamon Girl',
            artist: 'Lana Del Rey',
          ),
          SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              try {
                _navigateToKaraokePlayer2(context);
              } catch (e) {
                print('Error navigating to KaraokePlayer2: $e');
                // Handle the error appropriately, e.g., show a snackbar
              }
            },
            child: SongCard(
              albumCover: 'assets/album2.jpg',
              songName: 'Starboy',
              artist: 'The Weeknd ft. Daft Punk',
            ),
          ),
        ],
      ),
    );
  }
}

class SongCard extends StatelessWidget {
  final String albumCover;
  final String songName;
  final String artist;

  const SongCard({
    super.key,
    required this.albumCover,
    required this.songName,
    required this.artist,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                albumCover,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => 
                  const Icon(Icons.album, size: 80),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    songName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    artist,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
