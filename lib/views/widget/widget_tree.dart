import 'package:flutter/material.dart';
import 'dart:math';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  // Generate a list of random image URLs from Picsum Photos
  // We'll generate a fixed number for this example.
  // Each image will be 200x200 pixels. Add a random seed to get different images on each run.
  final Random _random = Random();
  final List<String> _imageUrls = List.generate(
    21, // Generate 21 image URLs for a 3-column grid
        (index) => 'https://picsum.photos/seed/${DateTime.now().millisecondsSinceEpoch + index}/200/200',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ArtisanHub",
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.store_mall_directory_outlined),
              title: Text('Shop'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to Shop')),
                );
                // TODO: Navigator.push(context, MaterialPageRoute(builder: (context) => ShopPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.amp_stories_outlined),
              title: Text('Story'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to Story')),
                );
                // TODO: Navigator.push(context, MaterialPageRoute(builder: (context) => StoryPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to About')),
                );
                // TODO: Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()));
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings_outlined),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Navigate to Settings')),
                );
                // TODO: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
          ],
        ),
      ),
      // --- MODIFIED BODY ---
      body: GridView.builder(
        padding: const EdgeInsets.all(4.0), // Add some padding around the grid
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, // Number of columns
          crossAxisSpacing: 4.0, // Horizontal space between items
          mainAxisSpacing: 4.0,   // Vertical space between items
          childAspectRatio: 1.0,  // Aspect ratio of items (1.0 for square)
        ),
        itemCount: _imageUrls.length,
        itemBuilder: (context, index) {
          return Image.network(
            _imageUrls[index],
            fit: BoxFit.cover,
            // Optional: Add a loading builder
            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
              if (loadingProgress == null) return child; // Image is loaded
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            // Optional: Add an error builder
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Container(
                color: Colors.grey[300],
                child: Icon(Icons.broken_image, color: Colors.grey[600], size: 40),
              );
            },
          );
        },
      ),
      // --- END MODIFIED BODY ---
    );
  }
}

// TODO: Define your actual pages like ShopPage, StoryPage, AboutPage, SettingsPage
// class ShopPage extends StatelessWidget { /* ... */ }
// class StoryPage extends StatelessWidget { /* ... */ }
// class AboutPage extends StatelessWidget { /* ... */ }
// class SettingsPage extends StatelessWidget { /* ... */ }
