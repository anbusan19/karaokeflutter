import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class KaraokePlayerScreen2 extends StatefulWidget {
  const KaraokePlayerScreen2({super.key});

  @override
  _KaraokePlayerScreen2State createState() => _KaraokePlayerScreen2State();
}

class _KaraokePlayerScreen2State extends State<KaraokePlayerScreen2> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentLyricIndex = 0;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  // Updated lyrics data
final List<Map<String, dynamic>> _lyrics = [
  {'text': "I'm tryna put you in the worst mood, ah", 'timestamp': 16390},
  {'text': "P1 cleaner than your church shoes, ah", 'timestamp': 18640},
  {'text': "Milli' point two just to hurt you, ah", 'timestamp': 21300},
  {'text': "All red Lamb' just to tease you, ah", 'timestamp': 23750},
  {'text': "None of these toys on lease too, ah", 'timestamp': 26390},
  {'text': "Made your whole year in a week too, yeah", 'timestamp': 28960},
  {'text': "Main bitch outta your league too, ah", 'timestamp': 31400},
  {'text': "Side bitch out of your league too, ah", 'timestamp': 34110},
  {'text': "House so empty, need a centerpiece", 'timestamp': 37070},
  {'text': "20 racks a table, cut from ebony", 'timestamp': 39320},
  {'text': "Cut that ivory into skinny pieces", 'timestamp': 42190},
  {'text': "Then she clean it with her face, man, I love my baby, ah", 'timestamp': 44010},
  {'text': "You talking money, need a hearing aid", 'timestamp': 47350},
  {'text': "You talking 'bout me, I don't see the shade", 'timestamp': 49830},
  {'text': "Switch up my style, I take any lane", 'timestamp': 52460},
  {'text': "I switch up my cup, I kill any pain", 'timestamp': 54840},
  {'text': "Look what you've done", 'timestamp': 61120},
  {'text': "I'm a motherfucking starboy", 'timestamp': 66360},
  {'text': "Look what you've done", 'timestamp': 71530},
  {'text': "I'm a motherfucking starboy", 'timestamp': 76810},
  {'text': "Every day a nigga try to test me, ah", 'timestamp': 78100},
  {'text': "Every day a nigga try to end me, ah", 'timestamp': 80490},
  {'text': "Pull off in that Roadster SV, ah", 'timestamp': 83130},
  {'text': "Pockets overweight gettin' hefty, ah", 'timestamp': 85710},
  {'text': "Coming for the king, that's a far cry, ah", 'timestamp': 88400},
  {'text': "I come alive in the fall time, I", 'timestamp': 91160},
  {'text': "No competition, I don't really listen", 'timestamp': 93640},
  {'text': "I'm in the blue Mulsanne bumping New Edition", 'timestamp': 95660},
  {'text': "House so empty, need a centerpiece", 'timestamp': 99050},
  {'text': "20 racks a table, cut from ebony", 'timestamp': 101320},
  {'text': "Cut that ivory into skinny pieces", 'timestamp': 104040},
  {'text': "Then she clean it with her face, man, I love my baby", 'timestamp': 106070},
  {'text': "You talking money, need a hearing aid", 'timestamp': 109350},
  {'text': "You talking about me, I don't see the shade", 'timestamp': 111750},
  {'text': "Switch up my style, I take any lane", 'timestamp': 114450},
  {'text': "I switch up my cup, I kill any pain", 'timestamp': 117040},
  {'text': "Look what you've done", 'timestamp': 123050},
  {'text': "I'm a motherfucking starboy", 'timestamp': 128250},
  {'text': "Look what you've done", 'timestamp': 133580},
  {'text': "I'm a motherfucking starboy", 'timestamp': 138510},
  {'text': "Let a nigga Brad Pitt", 'timestamp': 140780},
  {'text': "Legend of the fall took the year like a bandit", 'timestamp': 141880},
  {'text': "Bought mama a crib and a brand new wagon", 'timestamp': 144590},
  {'text': "Now she hit the grocery shop looking lavish", 'timestamp': 146930},
  {'text': "Star Trek roof in that Wraith of Khan", 'timestamp': 149780},
  {'text': "Girls get loose when they hear this song", 'timestamp': 152100},
  {'text': "100 on the dash, get me close to God", 'timestamp': 154730},
  {'text': "We don't pray for love, we just pray for cars", 'timestamp': 157020},
  {'text': "House so empty, need a centerpiece", 'timestamp': 161040},
  {'text': "20 racks a table, cut from ebony", 'timestamp': 163280},
  {'text': "Cut that ivory into skinny pieces", 'timestamp': 166030},
  {'text': "Then she clean it with her face, man, I love my baby", 'timestamp': 168080},
  {'text': "You talking money, need a hearing aid", 'timestamp': 171190},
  {'text': "You talking 'bout me, I don't see the shade", 'timestamp': 173700},
  {'text': "Switch up my style, I take any lane", 'timestamp': 176280},
  {'text': "I switch up my cup, I kill any pain", 'timestamp': 178720},
  {'text': "Look what you've done", 'timestamp': 185100},
  {'text': "I'm a motherfucking starboy", 'timestamp': 190090},
  {'text': "Look what you've done", 'timestamp': 195440},
  {'text': "I'm a motherfucking starboy", 'timestamp': 200460},
  {'text': "Look what you've done", 'timestamp': 205790},
  {'text': "I'm a motherfucking starboy", 'timestamp': 210790},
  {'text': "Look what you've done", 'timestamp': 216120},
  {'text': "I'm a motherfucking starboy", 'timestamp': 221170},
];
  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      await _audioPlayer.setAsset('assets/Starboy_Instrumental.mp3');

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
                      'Starboy',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'The Weeknd',
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