import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'food.dart';

class FoodDetails extends StatefulWidget {
  final Food food;

  const FoodDetails({Key key, this.food}) : super(key: key);

  @override
  _FoodDetailsState createState() => _FoodDetailsState();
}

class _FoodDetailsState extends State<FoodDetails> {
  double screenHeight, screenWidth;
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.food.foodname),
      ),
      body: Column(
        children: [
          Container(
              height: screenHeight / 4,
              width: screenWidth / 0.3,
              child: CachedNetworkImage(
                imageUrl:
                    "https://foodloverv3.000webhostapp.com/foodninjav2/images/foodimages/${widget.food.foodid}.jpg",
                fit: BoxFit.cover,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(
                  Icons.broken_image,
                  size: screenWidth / 2,
                ),
              )),
        ],
      ),
    );
  }
}
