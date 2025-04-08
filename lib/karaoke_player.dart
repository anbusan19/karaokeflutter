import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class KaraokePlayerScreen extends StatefulWidget {
  const KaraokePlayerScreen({super.key});

  @override
  _KaraokePlayerScreenState createState() => _KaraokePlayerScreenState();
}

class _KaraokePlayerScreenState extends State<KaraokePlayerScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentLyricIndex = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Sample lyrics data
  final List<Map<String, dynamic>> _lyrics = [
    {'text': 'Cinnamon in my teeth', 'timestamp': 2670},
    {'text': "From your kiss, you're touchin' me", 'timestamp': 9470},
    {'text': 'All the pills that you take', 'timestamp': 16650},
    {'text': "Violet, blue, green, red to keep me at arm's length don't work", 'timestamp': 22660},
    {'text': 'You try to push me out', 'timestamp': 29460},
    {'text': 'But I just find my way back in', 'timestamp': 32350},
    {'text': 'Violet, blue, green, red to keep me out', 'timestamp': 36660},
    {'text': 'I win', 'timestamp': 41020},
    {'text': "There's things I wanna say to you", 'timestamp': 41790},
    {'text': "But I'll just let you live", 'timestamp': 45230},
    {'text': "Like if you hold me without hurting me", 'timestamp': 48350},
    {'text': "You'll be the first who ever did", 'timestamp': 52040},
    {'text': "There's things I wanna talk about", 'timestamp': 55380},
    {'text': 'But better not to give', 'timestamp': 59030},
    {'text': "But if you hold me without hurting me", 'timestamp': 62120},
    {'text': "You'll be the first who ever did", 'timestamp': 65840},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 69400},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 73390},
    {'text': 'Hold me, love me, touch me, honey', 'timestamp': 76570},
    {'text': 'Be the first who ever did', 'timestamp': 80120},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 83530},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 87220},
    {'text': 'Hold me, love me, touch me, honey', 'timestamp': 90510},
    {'text': 'Be the first who ever did', 'timestamp': 94090},
    {'text': 'Kerosene in my hands', 'timestamp': 100110},
    {'text': "You make me mad, I'm fire again", 'timestamp': 106630},
    {'text': 'All the pills that you take', 'timestamp': 114070},
    {'text': "Violet, blue, green, red to keep me at arm's length don't work", 'timestamp': 120050},
    {'text': "There's things I wanna say to you", 'timestamp': 125320},
    {'text': "But I'll just let you live", 'timestamp': 128620},
    {'text': "Like if you hold me without hurting me", 'timestamp': 131680},
    {'text': "You'll be the first who ever did", 'timestamp': 135590},
    {'text': "There's things I wanna talk about", 'timestamp': 138900},
    {'text': 'But better not to give', 'timestamp': 142630},
    {'text': "But if you hold me without hurting me", 'timestamp': 145860},
    {'text': "You'll be the first who ever did", 'timestamp': 149470},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 153090},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 156820},
    {'text': 'Hold me, love me, touch me, honey', 'timestamp': 160280},
    {'text': 'Be the first who ever did', 'timestamp': 163680},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 167360},
    {'text': 'Ah, ah, ah, ah, ah, ah', 'timestamp': 170730},
    {'text': 'Hold me, love me, touch me, honey', 'timestamp': 174030},
    {'text': 'Be the first who ever did', 'timestamp': 177540},
    {'text': "There's things I wanna say to you", 'timestamp': 180870},
    {'text': "But I'll just let you live", 'timestamp': 184350},
    {'text': "Like if you hold me without hurting me", 'timestamp': 187590},
    {'text': "You'll be the first who ever did", 'timestamp': 191180},
    {'text': "There's things I wanna talk about", 'timestamp': 194530},
    {'text': 'But better not to give', 'timestamp': 198160},
  ];

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer.setAsset('assets/Cinnamon Girl.mp3');

      _audioPlayer.durationStream.listen((duration) {
        if (duration != null) {
          setState(() => _duration = duration);
        }
      });

      _audioPlayer.positionStream.listen((position) {
        setState(() => _position = position);
        _updateLyrics(position.inMilliseconds);
      });

      _audioPlayer.playerStateStream.listen((state) {
        if (state.playing) {
          setState(() => _isPlaying = true);
        } else {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      debugPrint('Error initializing player: $e');
    }
  }

  void _updateLyrics(int currentTime) {
    final nextIndex = _lyrics.indexWhere((lyric) => lyric['timestamp'] > currentTime);
    if (nextIndex != -1 && nextIndex != _currentLyricIndex) {
      setState(() => _currentLyricIndex = nextIndex - 1);
    }
  }

  Future<void> _togglePlayback() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  Future<void> _seekToPosition(double value) async {
    final position = Duration(milliseconds: (value * _duration.inMilliseconds).toInt());
    await _audioPlayer.seek(position);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[900]!,
              Colors.black,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Song Info
                Column(
                  children: [
                    Text(
                      'Cinnamon Girl',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Lana Del Rey',
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),

                // Lyrics
                Expanded(
                  child: Center(
                    child: Text(
                      _lyrics[_currentLyricIndex]['text'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                // Controls
                Column(
                  children: [
                    // Progress Bar
                    SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 3,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
                        activeTrackColor: Colors.white,
                        inactiveTrackColor: Colors.grey[800],
                        thumbColor: Colors.white,
                        overlayColor: Colors.white.withOpacity(0.2),
                      ),
                      child: Slider(
                        value: _position.inMilliseconds.toDouble(),
                        min: 0.0,
                        max: _duration.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          _seekToPosition(value / _duration.inMilliseconds);
                        },
                      ),
                    ),

                    // Time Display
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDuration(_position),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            _formatDuration(_duration),
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Playback Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.shuffle, color: Colors.grey[400], size: 20),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_previous, color: Colors.white, size: 35),
                          onPressed: () {},
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: IconButton(
                            iconSize: 40,
                            icon: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black,
                            ),
                            onPressed: _togglePlayback,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.skip_next, color: Colors.white, size: 35),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: Icon(Icons.repeat, color: Colors.grey[400], size: 20),
                          onPressed: () {},
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}