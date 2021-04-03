import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class PrepareForTakingPictureView extends StatelessWidget {
  prepareforPictureView(BuildContext context) async {
    final cameras = await availableCameras();
    final camera = cameras.first;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureView(camera),
        ));
  }

  @override
  Widget build(BuildContext context) {
    prepareforPictureView(context);
    return Container();
  }
}

class TakePictureView extends StatefulWidget {
  final CameraDescription camera;
  const TakePictureView(this.camera);
  @override
  _TakePictureViewState createState() => _TakePictureViewState();
}

class _TakePictureViewState extends State<TakePictureView> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _cameraController = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Take a picture')),
      // Wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner
      // until the controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            // If the Future is complete, display the preview.
            return CameraPreview(_cameraController);
          } else {
            // Otherwise, display a loading indicator.
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
