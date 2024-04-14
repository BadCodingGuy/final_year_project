import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RevisionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: Text('Revision Page'),
        elevation: 0.0,
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2, // Number of columns
          mainAxisSpacing: 20.0, // Spacing between rows
          crossAxisSpacing: 20.0, // Spacing between columns
          padding: EdgeInsets.all(20.0), // Padding around the grid
          children: [
            InkWell(
              onTap: () {
                _launchURL('https://student.craigndave.org/');
              },
              child: Image.asset(
                'assets/Craig-n-Dave.png',
                width: 80, // Reduced width
                height: 80, // Reduced height
              ),
            ),
            InkWell(
              onTap: () {
                _launchURL('https://www.bbc.co.uk/bitesize/subjects/z34k7ty');
              },
              child: Image.asset(
                'assets/bitesize.png',
                width: 80, // Reduced width
                height: 80, // Reduced height
              ),
            ),
            InkWell(
              onTap: () {
                _launchURL('https://adacomputerscience.org/');
              },
              child: Image.asset(
                'assets/ada.png',
                width: 80, // Reduced width
                height: 80, // Reduced height
              ),
            ),
            InkWell(
              onTap: () {
                _launchURL('https://revisionworld.com/gcse-revision/ict/past-papers');
              },
              child: Image.asset(
                'assets/revision.jpg',
                width: 80, // Reduced width
                height: 80, // Reduced height
              ),
            ),
          ],
        ),
      ),
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
