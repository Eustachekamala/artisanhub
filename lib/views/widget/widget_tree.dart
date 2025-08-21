import 'package:flutter/foundation.dart'; // For kDebugMode
import 'package:flutter/material.dart';
import 'package:artisanhub/services/api_service.dart';

class WidgetTree extends StatefulWidget {
  const WidgetTree({super.key});

  @override
  State<StatefulWidget> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  // State for products
  List<dynamic> _products = [];
  bool _isLoadingProducts = true;
  String? _productError;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    // Ensure `mounted` is checked before calling setState if the widget might be disposed.
    // However, for initState, it's generally safe.
    if (!mounted) return;

    setState(() {
      _isLoadingProducts = true;
      _productError = null; // Reset error on new fetch attempt
    });
    try {
      final result = await ApiService.getAllProducts();
      if (!mounted) return;
      setState(() {
        _products = result;
        _isLoadingProducts = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoadingProducts = false;
        _productError = "Failed to load products: $e";
      });
      if (kDebugMode) {
        print("Error loading products: $e");
      }
    }
  }

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
                  SnackBar(content: Text('Displaying fetched products in the main grid.')),
                );
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
      // --- MODIFIED BODY TO DISPLAY PRODUCTS ---
      body: _buildProductGrid(),
    );
  }

  Widget _buildProductGrid() {
    if (_isLoadingProducts) {
      return Center(child: CircularProgressIndicator());
    }

    if (_productError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: Colors.red, size: 50),
              SizedBox(height: 10),
              Text(
                'Could not load products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                _productError!, // Display the specific error
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text('Retry'),
                onPressed: _fetchProducts, // Retry fetching
              ),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront_outlined, size: 50, color: Colors.grey[600]),
              SizedBox(height: 10),
              Text(
                'No products found.',
                style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh),
                label: Text('Refresh'),
                onPressed: _fetchProducts,
              ),
            ],
          ),
        ),
      );
    }

    // Display products in a Grid
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Display 2 products per row, adjust as needed
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        childAspectRatio: 0.75,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final String productName = product['name'] ?? 'No Name';
        final String? imageUrl = product['imageFile'];
        final String productDescription = product['description'] ?? 'No description available.';
        final double productPrice = product['price'] ?? 0.0;

        return Card( // Wrap each product item in a Card for better UI
          clipBehavior: Clip.antiAlias, // Ensures content respects card's rounded corners
          elevation: 2.0,
          child: InkWell(
            onTap: () {
              // TODO: Navigate to product detail page or show more info
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Tapped on $productName')),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch, // Make children stretch horizontally
              children: <Widget>[
                Expanded(
                  flex: 3, // Give more space to the image
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ));
                    },
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(child: Icon(Icons.broken_image, color: Colors.grey[400], size: 40)),
                      );
                    },
                  )
                      : Container( // Placeholder if no image URL
                    color: Colors.grey[200],
                    child: Center(child: Icon(Icons.image_not_supported, color: Colors.grey[400], size: 40)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        productName,
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        productDescription,
                        style: TextStyle(fontSize: 12.0, color: Colors.grey[700]),
                        maxLines: 2, // Limit description lines in the grid view
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        productPrice.toString(),
                        style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
