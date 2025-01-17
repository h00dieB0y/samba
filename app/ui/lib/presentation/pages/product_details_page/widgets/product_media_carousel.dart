import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ProductMediaCarousel extends StatefulWidget {
  final List<String> images;

  const ProductMediaCarousel({super.key, required this.images});

  @override
  _ProductMediaCarouselState createState() => _ProductMediaCarouselState();
}

class _ProductMediaCarouselState extends State<ProductMediaCarousel> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    double height;
    double aspectRatio;

    if (screenWidth < 600) {
      height = 250;
      aspectRatio = 16 / 9;
    } else if (screenWidth < 1200) {
      height = 350;
      aspectRatio = 16 / 9;
    } else {
      height = 450;
      aspectRatio = 21 / 9;
    }

    return Column(
      children: [
        CarouselSlider(
          carouselController: _controller,
          items: widget.images
              .map(
                (image) => GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FullScreenImageView(imageUrl: image),
                      ),
                    );
                  },
                  child: InteractiveViewer(
                    child: Image.network(
                      image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: progress.expectedTotalBytes != null
                                ? progress.cumulativeBytesLoaded /
                                    progress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Center(
                          child: Icon(
                            Icons.broken_image,
                            color: Colors.grey,
                            size: 50,
                            semanticLabel: 'Image failed to load',
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
              .toList(),
          options: CarouselOptions(
            height: height,
            aspectRatio: aspectRatio,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            autoPlay: false,
            enlargeCenterPage: false,
            scrollDirection: Axis.horizontal,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
            // Accessibility
            pauseAutoPlayOnTouch: true,
          ),
        ),
        SizedBox(height: 10),
        // Thumbnails
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 60.0,
                height: 60.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _current == entry.key
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  image: DecorationImage(
                    image: NetworkImage(entry.value),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class FullScreenImageView extends StatelessWidget {
  final String imageUrl;

  const FullScreenImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image View'),
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: progress.expectedTotalBytes != null
                      ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes!
                      : null,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Center(
                child: Icon(
                  Icons.broken_image,
                  color: Colors.grey,
                  size: 100,
                  semanticLabel: 'Image failed to load',
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
