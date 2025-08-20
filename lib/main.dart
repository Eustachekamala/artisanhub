import 'package:artisanhub/views/widget/widget_tree.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(ArtisanHub());
}

class ArtisanHub extends StatefulWidget{
  const ArtisanHub({super.key});
  @override
  State<StatefulWidget> createState() => _ArtisanHubState();
}

class _ArtisanHubState extends State<ArtisanHub>{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.dark(),
        brightness: Brightness.dark
      ),
      home: WidgetTree(),
    );
  }
}