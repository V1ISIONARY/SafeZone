import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/bloc/mapBloc/map_bloc.dart';
import 'package:safezone/backend/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/bloc/mapBloc/map_state.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/bloc/notificationBloc/notification_state.dart';
import 'package:safezone/backend/services/first_run_service.dart';
import 'package:safezone/frontend/utils/marker_utils.dart';
import 'package:safezone/frontend/utils/safezone_navigator.dart';
import 'package:safezone/frontend/widgets/dialogs/dialogs.dart';
import 'package:safezone/frontend/widgets/loadingstate.dart';
import 'package:safezone/resources/schema/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class Maps extends StatefulWidget {
  final String UserToken;

  const Maps({super.key, required this.UserToken});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin {
  List<Map<String, dynamic>> members = [];
  Map<String, BitmapDescriptor> memberMarkers = {};
  Set<Marker> markers = {};
  Set<Circle> circles = {};
  Set<Marker> membersMarkers = {};
  Set<Polyline> _polylines = {};
  List<LatLng> _safeZones = [];
  static const LatLng sourceLocation = LatLng(16.0471, 120.3425);

  final Completer<GoogleMapController> _mapController = Completer();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _circleKey = GlobalKey();
  final GlobalKey _reportKey = GlobalKey();
  final GlobalKey _safeKey = GlobalKey();

  bool _showMarkers = true;
  bool _showOptions = false;
  bool _isSafeZoneShown = false;
  bool _wasInsideSafeZone = false;
  bool _wasInsideDangerZone = false;

  BitmapDescriptor? customMarker;
  BitmapDescriptor? customDangerZoneMarker;
  BitmapDescriptor? customSafeZoneMarker;
  BitmapDescriptor? customMemberMarker;

  MapType _currentMapType = MapType.normal;

  GoogleMapController? googleMapController;
  late AnimationController _controller;
  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;
  late FocusNode _focusNode;
  late AnimationController _controllerFade;
  late Animation<Color?> _colorAnimation;
  late TextEditingController _textEditingController;
  late AnimationController _mapCategoryHint;

  final List<String> hints = [
    'Barangay',
    'Hospital',
    'Police Station',
    'Municipal',
  ];
  int? _userId;
  int _currentHintIndex = 0;
  LatLng? _currentUserLocation;
  StreamSubscription? _locationSubscription;

  StreamSubscription<Position>? _positionStreamSubscription;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserId();
  }

  @override
  void initState() {
    super.initState();
    _loadUserId();

    context.read<MapBloc>().add(FetchMapData());
    context.read<DangerZoneBloc>().add(FetchDangerZones());
    _checkFirstRun();
    _createCustomMarker().then((_) {
      _fetchLocation();
    });
    print("Members list before fetching: $members");

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _mapCategoryHint = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _mapCategoryHint.repeat();

    _hintAnimation =
        Tween<Offset>(begin: const Offset(0, 0), end: const Offset(0, -1))
            .animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.black.withOpacity(0.5),
      end: const Color.fromARGB(0, 148, 37, 37),
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.black87,
      end: Colors.transparent,
    ).animate(_controllerFade);

    _focusNode = FocusNode();
    _textEditingController = TextEditingController();
    _changeHintText();

    _focusNode.addListener(() {
      if (_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
      }
    });

    _startLocationUpdates();
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();

    _controller.dispose();
    _controllerFade.dispose();
    _mapCategoryHint.dispose();
    _focusNode.dispose();
    _textEditingController.dispose();
    _locationSubscription?.cancel();
    super.dispose();
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    int? circleId = prefs.getInt('circle');

    if (userId != null) {
      setState(() {
        _userId = userId;
      });

      // Only call FetchMembersEvent if circleId is not null or 0
      if (circleId != null) {
        context.read<CircleBloc>().add(FetchMembersEvent(circleId: circleId));
      }
    }

    // Listen for the CircleBloc state changes
    context.read<CircleBloc>().stream.listen((state) {
      if (state is CircleMembersLoadedState) {
        context.read<MapBloc>().add(FetchMapData());

        context
            .read<MapBloc>()
            .add(ListenForMemberLocations(state.members, _userId!));
      }
    });
  }

  void _changeHintText() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_focusNode.hasFocus && _textEditingController.text.isEmpty) {
        _controller.forward().then((_) {
          if (mounted) {
            setState(() {
              _currentHintIndex = (_currentHintIndex + 1) % hints.length;
            });
          }
          _controller.reverse().then((_) {
            if (mounted) {
              _changeHintText();
            }
          });
        });
      } else {
        if (mounted) {
          _changeHintText();
        }
      }
    });
  }

  Future<void> _checkFirstRun() async {
    if (await FirstRunService.isFirstRun()) {
      await _createTutorial();
      await FirstRunService.setFirstRunCompleted();
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await getCurrentLocation();
      if (googleMapController != null) {
        googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(position.latitude, position.longitude),
            zoom: 14.0,
          ),
        ));

        setState(() {
          _currentUserLocation = LatLng(position.latitude, position.longitude);
          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId("My Location"),
            position: _currentUserLocation!,
            icon: customMarker ?? BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'My Location'),
          ));
        });

        await updateLocation(position.latitude, position.longitude);
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();
    return position;
  }

  Future<void> updateLocation(double latitude, double longitude) async {
    try {
      var response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/profile/update-location'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'user_id': _userId.toString(),
          'latitude': latitude.toString(),
          'longitude': longitude.toString(),
        }),
      );

      if (response.statusCode == 200) {
        print('Location updated successfully!');
        print('$latitude');
        print('$longitude');
      } else {
        print('Failed to update location');
      }
    } catch (e) {
      print(_userId);
      print('$latitude');
      print('$longitude');
      print('Error updating location: $e');
    }
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((Position position) async {
      print(
          "Location updated: Latitude: ${position.latitude}, Longitude: ${position.longitude}");

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      if (googleMapController != null) {
        googleMapController!.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
            target: userLocation,
            zoom: 14.0,
          ),
        ));

        setState(() {
          _currentUserLocation = userLocation;
          markers.clear();
          markers.add(Marker(
            markerId: const MarkerId("My Location"),
            position: _currentUserLocation!,
            icon: customMarker ?? BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'My Location'),
          ));
        });

        updateLocation(position.latitude, position.longitude);

        bool isInsideSafeZone = _isInsideZone(
            userLocation,
            circles
                .where((circle) =>
                    circle.fillColor == Colors.green.withOpacity(0.1))
                .toList());
        bool isInsideDangerZone = _isInsideZone(
            userLocation,
            circles
                .where(
                    (circle) => circle.fillColor == Colors.red.withOpacity(0.1))
                .toList());

        if (isInsideSafeZone && !_wasInsideSafeZone) {
          _showZoneDialog("Safe Zone", "You have entered a safe zone.");
          _sendBroadcastNotification("Group member - Safe Zone", " has entered a safe zone.");
          _wasInsideSafeZone = true;
        } else if (isInsideDangerZone && !_wasInsideDangerZone) {
          _showZoneDialog("Danger Zone",
              "You have entered a danger zone. Please be cautious.");
          _sendBroadcastNotification(
              "Group member - Danger Zone", " has entered a danger zone. Please be cautious.");
          _wasInsideDangerZone = true;
        }

        if (!isInsideSafeZone && _wasInsideSafeZone) {
          _showZoneDialog("Safe Zone", "You have exited the safe zone.");
          _sendBroadcastNotification("Group member - Safe Zone", " has exited the safe zone.");
          _wasInsideSafeZone = false;
        } else if (!isInsideDangerZone && _wasInsideDangerZone) {
          _showZoneDialog("Danger Zone", "You have exited the danger zone.");
          _sendBroadcastNotification(
              "Group member - Danger Zone", " has exited the danger zone.");
          _wasInsideDangerZone = false;
        }
      }
    });
  }

  Future<void> _sendBroadcastNotification(String title, String message) async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;
    String firstName = prefs.getString('first_name') ?? "User";
    String lastName = prefs.getString('last_name') ?? "";

    final formattedFirstName = firstName.isNotEmpty
        ? firstName[0].toUpperCase() + firstName.substring(1).toLowerCase()
        : '';
    final formattedLastName = lastName.isNotEmpty
        ? lastName[0].toUpperCase() + lastName.substring(1).toLowerCase()
        : '';
    String fullName = "$formattedFirstName $formattedLastName".trim();

    if (userId != 0) {
      context.read<NotificationBloc>().add(
            BroadcastNotification(
              userId,
              title,
              "$fullName $message",
              "Zone Alert",
            ),
          );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error: User ID not found!")),
      );
    }
  }

  // MARKERS

  Future<void> _createCustomMarker() async {
    try {
      customMarker =
          await MarkerUtils.createCustomMarker(context, widgetPricolor);
      customDangerZoneMarker = await MarkerUtils.resizeMarker(
        'lib/resources/images/dangerzonee.png',
        58,
        86,
      );
      customSafeZoneMarker = await MarkerUtils.resizeMarker(
        'lib/resources/images/safezone.png',
        58,
        86,
      );

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print("Error loading markers: $e");
    }
  }

  Future<void> _preloadMemberMarkers(List<Map<String, dynamic>> members) async {
    for (var member in members) {
      String userId = member['user_id'].toString();

      if (userId == _userId.toString()) {
        continue;
      }

      BitmapDescriptor marker = await _loadCustomMemberMarker(userId);
      memberMarkers[userId] = marker;
    }
  }

  void _updateMemberMarker(
      String userId, double latitude, double longitude) async {
    if (userId == _userId.toString()) {
      return;
    }

    setState(() {
      markers.removeWhere((marker) => marker.markerId.value == "user_$userId");

      markers.add(
        Marker(
          markerId: MarkerId("user_$userId"),
          position: LatLng(latitude, longitude),
          icon: customMemberMarker!,
          infoWindow: InfoWindow(title: 'User $userId'),
        ),
      );
    });
  }

  Future<BitmapDescriptor> _loadCustomMemberMarker(String letter) async {
    ByteData data =
        await rootBundle.load('lib/resources/images/marker_member.png');
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: 100,
      targetHeight: 110,
    );
    ui.FrameInfo frameInfo = await codec.getNextFrame();
    ui.Image originalImage = frameInfo.image;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint();

    canvas.drawImage(originalImage, const Offset(0, 0), paint);

    final TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: const TextStyle(
          color: ui.Color.fromARGB(255, 71, 71, 71),
          fontSize: 100 * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();

    double dx = (100 - textPainter.width) / 2;
    double dy = (110 - textPainter.height) / 2 - (110 * 0.1);

    textPainter.paint(canvas, Offset(dx, dy));

    final ui.Image finalImage =
        await pictureRecorder.endRecording().toImage(100, 110);

    ByteData? byteData =
        await finalImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List resizedData = byteData!.buffer.asUint8List();

    return BitmapDescriptor.fromBytes(resizedData);
  }

  Set<Marker> _createMarkers(MapState state) {
    Set<Marker> markers = {};

    if (_currentUserLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("My Location"),
          position: _currentUserLocation!,
          icon: customMarker ?? BitmapDescriptor.defaultMarker,
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    if (state is MapDataLoaded) {
      for (var member in state.members) {
        String userId = member['user_id'].toString();
        double latitude = member['latitude'];
        double longitude = member['longitude'];

        BitmapDescriptor? memberMarker = memberMarkers[userId];

        if (userId == _userId.toString()) {
          continue;
        }

        markers.add(
          Marker(
            markerId: MarkerId(userId),
            position: LatLng(latitude, longitude),
            icon: memberMarker ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: 'User $userId'),
          ),
        );
      }

      for (var dangerZone in state.dangerZones) {
        markers.add(
          Marker(
            markerId: MarkerId(dangerZone.id.toString()),
            icon: customDangerZoneMarker ?? BitmapDescriptor.defaultMarker,
            position: LatLng(dangerZone.latitude, dangerZone.longitude),
            infoWindow: InfoWindow(
              title: dangerZone.name,
            ),
          ),
        );
        circles.add(
          Circle(
            circleId: CircleId(dangerZone.id.toString()),
            center: LatLng(dangerZone.latitude, dangerZone.longitude),
            radius: dangerZone.radius,
            strokeWidth: 1,
            strokeColor: Colors.transparent,
            fillColor: Colors.red.withOpacity(0.1),
          ),
        );
      }

      _safeZones = state.safeZones
          .map((safeZone) => LatLng(safeZone.latitude!, safeZone.longitude!))
          .toList();

      for (var safeZone in state.safeZones) {
        markers.add(
          Marker(
            markerId: MarkerId(safeZone.id.toString()),
            icon: customSafeZoneMarker ?? BitmapDescriptor.defaultMarker,
            position: LatLng(safeZone.latitude!, safeZone.longitude!),
            infoWindow: InfoWindow(
              title: safeZone.name,
              snippet: "${safeZone.radius}",
            ),
          ),
        );
        circles.add(
          Circle(
            circleId: CircleId(safeZone.id.toString()),
            center: LatLng(safeZone.latitude!, safeZone.longitude!),
            radius: safeZone.radius!,
            strokeWidth: 1,
            strokeColor: Colors.transparent,
            fillColor: Colors.green.withOpacity(0.1),
          ),
        );
      }
    }

    return markers;
  }

  // TRIGGERS WHEN USER ENTERS OR EXITS A ZONE :>

  bool _isInsideZone(LatLng userLocation, List<Circle> zones) {
    for (var zone in zones) {
      double distance = Geolocator.distanceBetween(
        userLocation.latitude,
        userLocation.longitude,
        zone.center.latitude,
        zone.center.longitude,
      );

      if (distance <= zone.radius) {
        return true;
      }
    }
    return false;
  }

  void _showZoneDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("Oki"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // FINDING ROUTE TO SAFEZONE

  void _updatePolylines(Set<Polyline> polylines) {
    setState(() {
      _polylines = polylines;
    });
  }

  void _findRoute() {
    if (!_isSafeZoneShown) {
      SafeZoneNavigator(
        googleMapController: googleMapController,
        currentUserLocation: _currentUserLocation,
        safeZones: _safeZones,
        onPolylinesUpdated: _updatePolylines,
        context: context,
      ).findNearestSafeZone();

      setState(() {
        _isSafeZoneShown = true;
      });
    } else {
      _resetMap();
      setState(() {
        _isSafeZoneShown = false;
      });
    }
  }

  void _resetMap() {
    setState(() {
      _polylines.clear();
    });

    googleMapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        const CameraPosition(
          target: sourceLocation,
          zoom: 14.0,
          tilt: 0.0,
          bearing: 0.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 216, 216, 216),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Stack(
          children: [
            MultiBlocListener(
              listeners: [
                BlocListener<MapBloc, MapState>(
                  listener: (context, state) {
                    if (state is MemberLocationUpdated) {
                      print("iz changingggggg");
                      _updateMemberMarker(
                          state.userId, state.latitude, state.longitude);
                    }
                  },
                ),
                BlocListener<NotificationBloc, NotificationState>(
                  listener: (context, state) {
                    if (state is NotificationBroadcasted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Zone notification broadcasted!")),
                      );
                    } else if (state is NotificationError) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Error: ${state.message}")),
                      );
                    }
                  },
                ),
              ],
              child: BlocBuilder<MapBloc, MapState>(
                builder: (context, state) {
                  if (state is MapLoading) {
                    return Expanded(
                      child: Center(
                        child: Transform.translate(
                            offset: const Offset(0, 0),
                            child: const LoadingState()),
                      ),
                    );
                  } else if (state is MapDataLoaded) {
                    _preloadMemberMarkers(state.members);
                  } else if (state is MapError) {
                    return Center(child: Text(state.message));
                  }
                  return GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: sourceLocation,
                      zoom: 16.0,
                    ),
                    mapType: _currentMapType,
                    markers: _showMarkers ? _createMarkers(state) : {},
                    circles: circles,
                    polylines: _polylines,
                    onMapCreated: (GoogleMapController controller) async {
                      googleMapController = controller;
                      String style = '''
                                          [
                                            {
                                              "featureType": "poi.business",
                                              "elementType": "labels",
                                              "stylers": [
                                                { "visibility": "off" }
                                              ]
                                            },
                                            {
                                              "featureType": "poi",
                                              "elementType": "labels.text",
                                              "stylers": [
                                                { "visibility": "off" }
                                              ]
                                            }
                                          ]
                                          ''';
                      controller.setMapStyle(style);
                      _mapController.complete(controller);

                      _fetchLocation();
                    },
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                  );
                },
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  toolbarHeight: 20,
                ),
                PreferredSize(
                  preferredSize: const Size.fromHeight(120.0),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.transparent,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: Container(
                            height: 40,
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2,
                                  offset: Offset(1, 1),
                                ),
                              ],
                            ),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                  child: TextField(
                                    controller: _textEditingController,
                                    focusNode: _focusNode,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.white,
                                      hintText: '',
                                      hintStyle: const TextStyle(
                                        color: Colors.transparent,
                                      ),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 12.0, vertical: 12.0),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        borderSide: const BorderSide(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 12,
                                  right: 12,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GestureDetector(
                                        key: _searchKey,
                                        onTap: () {
                                          FocusScope.of(context)
                                              .requestFocus(_focusNode);
                                        },
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 4),
                                          child: AnimatedBuilder(
                                            animation: _controllerFade,
                                            builder: (context, child) {
                                              return Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Transform.translate(
                                                      offset:
                                                          const Offset(-5, -10),
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        alignment:
                                                            Alignment.center,
                                                        color:
                                                            Colors.transparent,
                                                        child: SvgPicture.asset(
                                                          'lib/resources/svg/search.svg',
                                                          color: _colorAnimation
                                                              .value,
                                                          height: 20,
                                                          width: 20,
                                                          fit: BoxFit.contain,
                                                        ),
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                        offset:
                                                            const Offset(-5, 0),
                                                        child: Text(
                                                          "Search for near",
                                                          style: TextStyle(
                                                            color:
                                                                _colorAnimation
                                                                    .value,
                                                            fontSize: 13,
                                                          ),
                                                        ))
                                                  ]);
                                            },
                                          ),
                                        ),
                                      ),
                                      SlideTransition(
                                        position: _hintAnimation,
                                        child: AnimatedBuilder(
                                          animation: _hintColorAnimation,
                                          builder: (context, child) {
                                            return GestureDetector(
                                              onTap: () {
                                                FocusScope.of(context)
                                                    .requestFocus(_focusNode);
                                              },
                                              child: Text(
                                                hints[_currentHintIndex],
                                                style: TextStyle(
                                                  color:
                                                      _hintColorAnimation.value,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 0,
                                    right: 5,
                                    child: GestureDetector(
                                      onTap: () {},
                                      child: Container(
                                        height: 40,
                                        width: 40,
                                        alignment: Alignment.center,
                                        color: Colors.transparent,
                                        child: SvgPicture.asset(
                                          'lib/resources/svg/mic.svg',
                                          color: Colors.black87,
                                          height: 22,
                                          width: 22,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: _findRoute,
                    child: Container(
                      margin: const EdgeInsets.only(right: 20),
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _isSafeZoneShown
                            ? Colors.grey[300]
                            : Colors.white, // Toggle color
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 2,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Show nearest safe zone", // Keep the text constant
                          style: TextStyle(
                              color: labelFormFieldColor, fontSize: 11),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
            Positioned(
              bottom: 90,
              left: 15,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _showOptions = !_showOptions;
                      });
                    },
                    child: AnimatedRotation(
                      turns: _showOptions ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: _buildButton(Icons.keyboard_arrow_right),
                    ),
                  ),
                  const SizedBox(width: 7),
                  AnimatedOpacity(
                    opacity: _showOptions ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 200),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentMapType =
                                  _currentMapType == MapType.normal
                                      ? MapType.satellite
                                      : MapType.normal;
                            });
                          },
                          child: _buildButton(Icons.map),
                        ),
                        SizedBox(width: 7),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _showMarkers = !_showMarkers;
                            });
                          },
                          child: _buildButton(_showMarkers
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Floating buttons
            widget.UserToken == 'guess'
                ? const SizedBox()
                : Positioned(
                    right: 15,
                    bottom: 80,
                    child: SizedBox(
                      width: 60,
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            key: _circleKey,
                            onTap: () async {
                              final result = await context.push('/groups-list');
                              if (result == null) {
                                _loadUserId();
                              } else {
                                _loadUserId();
                              }
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                    "lib/resources/svg/connect.svg",
                                    color: Colors.blue),
                              ),
                            ),
                          ),
                          GestureDetector(
                            key: _reportKey,
                            onTap: () {
                              showCreateReportDialog(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                  "lib/resources/svg/dangerzone.svg",
                                  color: widgetPricolor,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            key: _safeKey,
                            onTap: () {
                              showMarkSafeDialog(context);
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                    10), // Square shape with rounded corners
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: SvgPicture.asset(
                                    "lib/resources/svg/safezone.svg",
                                    color: Colors.green),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  _createTutorial() {
    final targets = [
      TargetFocus(
        identify: "Circle",
        keyTarget: _circleKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add and see people in your circle',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This allows you to stay connected and ensure their safety.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Report",
        keyTarget: _reportKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Report any incidents or unsafe situations',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This helps warn others and ensures authorities are informed.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Safe",
        keyTarget: _safeKey,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'If you feel safe in a location, mark it as safe.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'This helps others find safe places nearby when they are in danger.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ],
      ),
      TargetFocus(
        identify: "Search",
        keyTarget: _searchKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                Text(
                  'Search for nearby locations.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Find safe zones, landmarks, and important places quickly.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    ];

    final tutorial = TutorialCoachMark(targets: targets);

    Future.delayed(const Duration(milliseconds: 500), () {
      tutorial.show(context: context);
    });
  }
}

Widget _buildButton(IconData icon) {
  return Container(
    width: 40,
    height: 40,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius:
          BorderRadius.circular(10), // Square shape with rounded corners
      boxShadow: const [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 2,
          offset: Offset(1, 1),
        ),
      ],
    ),
    child: Center(
      child: Icon(
        icon,
        color: labelFormFieldColor,
      ),
    ),
  );
}
