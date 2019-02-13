import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';

import '../helpers/ensure_visible.dart';

class LocationInput extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LocationInputState();
  }
}

class LocationInputState extends State<LocationInput> {
  final FocusNode _addressInputFocusNode = FocusNode();
  Uri _staticMapUri;
  @override
  void initState() {
    _addressInputFocusNode.addListener(_updateLocation);
    getStaticMap();
    super.initState();
  }

  void getStaticMap() {
    final StaticMapProvider staticMapViewProvider =
        StaticMapProvider('AIzaSyAr_gu2gL1bGvg_pij6ySySP7srJQzNezQ');
    final Uri staticMapUri = staticMapViewProvider.getStaticUriWithMarkers(
      [Marker('position', 'Position', 44.85308, -93.23809)],
      center: Location(44.85308, -93.23809),
      width: 500,
      height: 300,
      maptype: StaticMapViewType.roadmap,
    );
    setState(() {
      _staticMapUri = staticMapUri;
    });
  }

  void _updateLocation() {}

  @override
  void dispose() {
    _addressInputFocusNode.removeListener(_updateLocation);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        EnsureVisibleWhenFocused(
          focusNode: _addressInputFocusNode,
          child: TextFormField(
            focusNode: _addressInputFocusNode,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Image.network(_staticMapUri.toString())
      ],
    );
  }
}
