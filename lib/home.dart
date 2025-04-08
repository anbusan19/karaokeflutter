import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Karaoke Songs'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          SongCard(
            albumCover: 'https://open.spotify.com/album/3lH4gaKdQ12d4OewBkaVWl',
            songName: 'Shape of You',
            artist: 'Ed Sheeran',
          ),
          SizedBox(height: 16),
          SongCard(
            albumCover: 'https://example.com/album2.jpg',
            songName: 'Uptown Funk',
            artist: 'Mark Ronson ft. Bruno Mars',
          ),
          SizedBox(height: 16),
          SongCard(
            albumCover: 'https://example.com/album3.jpg',
            songName: 'Rolling in the Deep',
            artist: 'Adele',
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
