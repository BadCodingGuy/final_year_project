import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Home/student_home.dart';

class RevisionPage extends StatefulWidget {
  @override
  _RevisionPageState createState() => _RevisionPageState();
}

class _RevisionPageState extends State<RevisionPage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  String? _selectedExamBoard;
  String? _selectedTopic;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.asset('assets/example_video.mp4');

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      showControls: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        backgroundColor: Colors.brown[600],
        title: Text('Revise',
          style: TextStyle(
            fontFamily: 'Jersey 10', // Use your font family name here
            fontSize: 30,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StudentHome()),  // Navigate to Sell page
            );
          },
          child: Image.asset('assets/logo.png', height: 40, width: 40), // Replace with your logo path
        ),
      ),
      body: Row(
        children: <Widget>[
          // Left side content
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                // Video player
                Expanded(
                  child: Center(
                    child: Chewie(
                      controller: _chewieController,
                    ),
                  ),
                ),

                // Buttons
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        // First Column of Buttons
                        _buildButton('assets/bitesize.png', _getLinkBitesize()),

                        // Second Column of Buttons
                        _buildButton('assets/revision.jpg', _getLinkRevision()),

                        // Third Column of Buttons
                        _buildButton('assets/ada.png', _getLinkAda()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Right side content
          Expanded(
            flex: 1,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'What exam board are you using?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Select exam board'),
                        value: _selectedExamBoard,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedExamBoard = newValue;
                            _updateVideo();
                          });
                        },
                        items: <String>['AQA', 'OCR', 'Eduqas', 'Edexcel'].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'What do you need to learn?',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        hint: Text('Select topic'),
                        value: _selectedTopic,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTopic = newValue;
                            _updateVideo();
                          });
                        },
                        items: <String>[
                          'Programming Basics',
                          'Data Structures',
                          'Algorithms',
                          'Networking',
                          'Databases'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(String imagePath, String url) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.15,
      height: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          _launchURL(url);
        },
        child: Image.asset(imagePath),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
          ),
          primary: Colors.brown,
        ),
      ),
    );
  }

  void _updateVideo() {
    if (_selectedExamBoard == 'AQA' && _selectedTopic == 'Programming Basics') {
      _videoPlayerController = VideoPlayerController.asset('assets/alt_video.mp4');
    } else {
      _videoPlayerController = VideoPlayerController.asset('assets/example_video.mp4');
    }
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: false,
      looping: true,
      aspectRatio: 16 / 9,
      allowFullScreen: true,
      showControlsOnInitialize: true,
      showControls: true,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      deviceOrientationsOnEnterFullScreen: [DeviceOrientation.landscapeRight, DeviceOrientation.landscapeLeft],
    );
  }

  String _getLinkBitesize() {
    if (_selectedExamBoard == 'AQA' && _selectedTopic == 'Programming Basics') {
      return 'https://www.bbc.co.uk/bitesize/guides/zh66pbk/revision/1';
    }
    else {
      return 'https://www.bbc.co.uk/bitesize/examspecs/zkwsjhv';
    }
  }

  String _getLinkRevision() {
    if (_selectedExamBoard == 'AQA' && _selectedTopic == 'Programming Basics') {
      return 'https://revisionworld.com/gcse-revision/ict/past-papers/aqa-gcse-computer-science-past-papers';
    } else {
      return 'https://revisionworld.com/gcse-revision/ict/past-papers';
    }
  }

  String _getLinkAda() {
    if (_selectedExamBoard == 'AQA' && _selectedTopic == 'Programming Basics') {
      return 'https://isaaccomputerscience.org/topics/gcse#aqa';
    } else {
      return 'https://isaaccomputerscience.org/?examBoard=all&stage=gcse';
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
