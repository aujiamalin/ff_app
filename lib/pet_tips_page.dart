import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PetTipsPage extends StatefulWidget {
  const PetTipsPage({Key? key}) : super(key: key);

  @override
  State<PetTipsPage> createState() => _PetTipsPageState();
}

class _PetTipsPageState extends State<PetTipsPage> {
  // 1. Data Mentah Kategori dan Video Tips Online
  final List<String> categories = [
    'Cats 🐱',
    'Hamsters 🐹',
    'Rabbits 🐰',
    'Birds 🦜',
  ];
  String selectedCategory = 'Cats 🐱';

  // Contoh data video (Gantikan URL YouTube ini dengan video pilihan awak nanti)
  final List<Map<String, dynamic>> videoData = [
    {
      'title': 'How to Take Care of a New Kitten',
      'category': 'Cats 🐱',
      'duration': '5:30',
      'youtubeUrl': 'https://www.youtube.com/watch?v=peUVLEUj-AM',
    },
    {
      'title': 'Cat Diet & Nutrition Guide',
      'category': 'Cats 🐱',
      'duration': '8:15',
      'youtubeUrl': 'https://www.youtube.com/watch?v=1VMp67UInHg',
    },
    {
      'title': 'Hamster Care 101: Absolute Basics',
      'category': 'Hamsters 🐹',
      'duration': '10:00',
      'youtubeUrl': 'https://www.youtube.com/watch?v=Jm9Iu88fFfM',
    },
    {
      'title': 'What NOT to Feed Your Rabbit',
      'category': 'Rabbits 🐰',
      'duration': '6:45',
      'youtubeUrl': 'https://www.youtube.com/watch?v=Oa_766I65_M',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Menapis video berdasarkan kategori yang dipilih oleh pengguna
    final filteredVideos = videoData
        .where((video) => video['category'] == selectedCategory)
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xfff8f9fa),
      appBar: AppBar(
        title: const Text(
          'Pet Care Tips',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- BAHAGIAN 1: SENARAI KATEGORI (HORIZONTAL) ---
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: SizedBox(
              height: 45,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  bool isSelected = categories[index] == selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.orange : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange
                                : Colors.grey.shade300,
                          ),
                        ),
                        child: Text(
                          categories[index],
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : Colors.blueGrey[700],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              'Recommended Videos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),

          // --- BAHAGIAN 2: SENARAI KAD VIDEO (VERTICAL) ---
          Expanded(
            child: ListView.builder(
              itemCount: filteredVideos.length,
              itemBuilder: (context, index) {
                final video = filteredVideos[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Gambar Mini Video & Butang Play
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                              child: Image.network(
                                YoutubePlayerController.getThumbnail(
                                  videoId:
                                      YoutubePlayerController.convertUrlToId(
                                        video['youtubeUrl'],
                                      )!,
                                ),
                                height: 180,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                // Apabila ditekan, buka skrin pemain video
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => VideoPlayerScreen(
                                      youtubeUrl: video['youtubeUrl'],
                                    ),
                                  ),
                                );
                              },
                              child: const CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.orange,
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 35,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Tajuk Video
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video['title'],
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    video['duration'],
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// --- SUB-WIDGET: SKRIN PEMAIN VIDEO YOUTUBE ---
class VideoPlayerScreen extends StatefulWidget {
  final String youtubeUrl;
  const VideoPlayerScreen({Key? key, required this.youtubeUrl})
    : super(key: key);

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  final _controller = YoutubePlayerController(
    params: const YoutubePlayerParams(
      showControls: true,
      showFullscreenButton: true,
      mute: false,
    ),
  );

  @override
  void initState() {
    super.initState();
    final videoId = _controller.loadVideo(widget.youtubeUrl);
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
      body: Center(child: YoutubePlayer(controller: _controller)),
    );
  }
}
