import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_bloc.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_event.dart';
import 'package:safezone/backend/architecture/bloc/circleBloc/circle_state.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_bloc.dart';
import 'package:safezone/backend/architecture/bloc/dangerzoneBloc/dangerzone_event.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_bloc.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_event.dart';
import 'package:safezone/backend/architecture/bloc/mapBloc/map_state.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_bloc.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_event.dart';
import 'package:safezone/backend/architecture/bloc/notificationBloc/notification_state.dart';
import 'package:safezone/backend/models/safezoneModel/safezone_model.dart';
import 'package:safezone/backend/models/userModel/circle_model.dart';
import 'package:safezone/backend/properties/properties.dart';
import 'package:safezone/backend/services/first_run_service.dart';
import 'package:safezone/frontend/platforms/mobile/pages/authentication/account_details.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/Dialogs/dialogs.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/bottomsheet/map/dangerzone_bottom_sheet.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/bottomsheet/map/member_bottom_sheet.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/bottomsheet/map/safezone_bottom_sheet.dart';
import 'package:safezone/frontend/platforms/mobile/widgets/loading/loadingstate.dart';
import 'package:safezone/frontend/utils/marker_utils.dart';
import 'package:safezone/frontend/utils/safezone_navigator.dart';
import 'package:safezone/resource/schema/colors.dart';
import 'package:safezone/resource/schema/texts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:location/location.dart' as locs;

import '../../../widgets/cards/users.dart';

class Maps extends StatefulWidget {
  final String UserToken;

  const Maps({super.key, required this.UserToken});

  @override
  State<Maps> createState() => _MapsState();
}

class _MapsState extends State<Maps> with TickerProviderStateMixin {
  final sharedController = SharedProperties();

  Map<String, BitmapDescriptor> memberMarkers = {};
  List<SafeZoneModel> policeStations = [];
  Set<Marker> markers = {};
  Set<Marker> membersMarkers = {};

  List<LatLng> _safeZones = [];
  List<LatLng> _dangerZones = [];
  final locs.Location location = locs.Location();
  static const LatLng sourceLocation = LatLng(16.0433, 120.3333);
  LatLng _initialPosition = const LatLng(37.7749, -122.4194);
  final apiKey = dotenv.env['GOOGLE_API_KEY'];
  final GlobalKey _safeKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _circleKey = GlobalKey();
  final GlobalKey _reportKey = GlobalKey();

  bool _isAllZoneShown = false;
  bool _isSafeZoneShown = false;
  bool _isDangerZoneShown = false;
  bool _isRefreshing = false;
  Timer? _refreshTimer;

  BitmapDescriptor? customMyLocationMarker;
  BitmapDescriptor? customPendingDangerZoneMarker;
  BitmapDescriptor? customDangerZoneMarker;
  BitmapDescriptor? customSafeZoneMarker;
  BitmapDescriptor? customMemberMarker;

  late FocusNode _focusNode;
  late FocusNode _focusNodeText;
  late FocusNode _focusNodeCircles;
  late stt.SpeechToText _speech;

  bool _isListening = false;
  bool _isExpanded = false;
  bool _circleHeight = false;

  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;
  late AnimationController _controllerFade;

  late Animation<Offset> _hintAnimation;
  late Animation<Color?> _hintColorAnimation;

  late AnimationController _mapCategoryHint;
  late SharedPreferences _prefs;

  final List<String> hints = [
    'Barangay',
    'Hospital',
    'Police Station',
    'Municipal',
  ];

  List<Map<String, dynamic>> _currentMembers = [];

  bool get _areCustomMarkersLoaded {
    return customMyLocationMarker != null &&
        customDangerZoneMarker != null &&
        customPendingDangerZoneMarker != null &&
        customSafeZoneMarker != null;
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (!_isExpanded) {
        sharedController.mapSearchTE.clear();
        _focusNode.unfocus();
      }
    });
  }

  void _toggleCircles() {
    setState(() {
      _circleHeight = !_circleHeight;
      if (!_circleHeight && _focusNodeCircles.hasFocus) {
        _focusNodeCircles.unfocus();
      }
    });
  }

  bool _showTitle = false;
  double _appBarHeight = 0;
  Color _appBarColor = Colors.transparent;

  List<CircleModel> _circles = [];
  int? _userId;
  String profilePictureUrl = '';
  int _currentHintIndex = 0;
  LatLng? _currentUserLocation;
  StreamSubscription? _locationSubscription;
  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription? _membersSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadUserId();
  }

  @override
  void initState() {
    super.initState();

    _loadUserId();
    _loadMapType();
    _checkIfShown();
    _checkFirstRun();
    _getCurrentLocation();

    _initSharedPreferences();
    _runInitLogicOnce();

    _speech = stt.SpeechToText();

    _mapCategoryHint = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _mapCategoryHint.repeat();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _controllerFade = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _hintAnimation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(0, -2),
    ).animate(_controller);

    _hintColorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.transparent,
    ).animate(_controller);

    _colorAnimation = ColorTween(
      begin: Colors.black,
      end: Colors.transparent,
    ).animate(_controllerFade);

    _focusNode = FocusNode();
    _focusNodeText = FocusNode();
    _focusNodeCircles = FocusNode();
    _changeHintText();

    _focusNodeText.addListener(() {
      if (_focusNodeText.hasFocus &&
          sharedController.mapSearchTE.text.isEmpty) {
        _controllerFade.forward();
        _controller.forward();
      } else if (!_focusNodeText.hasFocus &&
          sharedController.mapSearchTE.text.isEmpty) {
        _controller.reverse();
        _controllerFade.reverse();
      }
    });

    _startLocationUpdates();
    _startPeriodicRefresh();
  }

  Future<void> _refreshMapData() async {
    print("it is refreshing");
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      await Future.wait([
        _fetchLocation().timeout(Duration(seconds: 10)),
        Future.delayed(Duration.zero, () {
          context.read<MapBloc>().add(FetchMapData());
        }).timeout(Duration(seconds: 10)),
      ]).timeout(Duration(seconds: 15));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Data updated!"),
            duration: Duration(seconds: 1),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      print('Light refresh failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (mounted && !_isRefreshing) {
        _refreshMapData();
      }
    });
  }

  void _stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Widget _buildRefreshButton() {
    return GestureDetector(
      onTap: _isRefreshing ? null : _refreshMapData,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: _isRefreshing ? Colors.grey[300] : Colors.white,
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
          child: _isRefreshing
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(widgetPricolor),
                  ),
                )
              : Icon(
                  Icons.refresh,
                  color: widgetPricolor,
                  size: 20,
                ),
        ),
      ),
    );
  }

  void _runInitLogicOnce() async {
    final prefs = await SharedPreferences.getInstance();

    bool hasRunBefore = prefs.getBool('mapsHasInitialized') ?? false;
    context.read<MapBloc>().add(FetchMapData());
    context.read<DangerZoneBloc>().add(FetchDangerZones());

    if (!hasRunBefore) {
      await prefs.setBool('mapsHasInitialized', true);
      print("✅ Maps init logic executed");
    } else {
      print("⏭️ Maps init logic already executed, skipping...");
    }
  }

  Future<void> _checkIfShown() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasShownBefore = prefs.getBool('appBarShown') ?? false;

    if (widget.UserToken != 'guest' && !hasShownBefore) {
      prefs.setBool('appBarShown', true);
      Future.delayed(const Duration(milliseconds: 200), () {
        if (mounted) {
          setState(() {
            _appBarHeight = 40;
            _appBarColor = Colors.green;
            _showTitle = true;
          });
        }

        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) {
            setState(() {
              _appBarHeight = 0;
              _appBarColor = Colors.transparent;
              _showTitle = false;
            });
          }
        });
      });
    }
  }

  Future<void> _initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _loadMapType() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int? mapTypeIndex = prefs.getInt('mapType');

    if (mapTypeIndex != null) {
      sharedController.currentMapType.value = mapTypeIndex;
    }
  }

  @override
  void dispose() {
    _positionStreamSubscription?.cancel();
    _controller.dispose();
    _controllerFade.dispose();
    _mapCategoryHint.dispose();
    _focusNode.dispose();
    _focusNodeCircles.dispose();
    _focusNodeText.dispose();
    _locationSubscription?.cancel();
    _membersSubscription?.cancel();
    _refreshTimer?.cancel();
    super.dispose();
  }

  MapType _mapTypeFromIndex(int index) {
    switch (index) {
      case 1:
        return MapType.satellite;
      case 2:
        return MapType.terrain;
      case 3:
        return MapType.hybrid;
      default:
        return MapType.normal;
    }
  }

  void _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id');
    int? circleId = prefs.getInt('circle');
    profilePictureUrl = prefs.getString('profile_picture_url') ??
        'https://storage.googleapis.com/safezone-11724.firebasestorage.app/profile_pictures/2.jpg';

    await _createCustomMarker();

    _fetchLocation();

    if (userId != null) {
      setState(() {
        _userId = userId;
      });
      context.read<CircleBloc>().add(FetchCirclesEvent(userId: userId));
      if (circleId != null) {
        context.read<CircleBloc>().add(FetchMembersEvent(circleId: circleId));
      }
    }
    if (_userId != null && circleId != null) {
      _listenForMembers(circleId);
    }

    context.read<CircleBloc>().stream.listen((state) {
      if (state is CircleMembersLoadedState) {
        context.read<MapBloc>().add(FetchMapData());
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        print("CIRCLEMEMBERLOADEDSTATE IS CALLED");
        if (mounted && _userId != null) {}
        context
            .read<MapBloc>()
            .add(ListenForMemberLocations(state.members, _userId!));
        print(
            "🚀 ListenForMemberLocations dispatched with ${state.members.length} members");
      }
      if (state is CircleLoadedState) {
        _circles = state.circles;
      }
    });
  }

  void _changeHintText() {
    Future.delayed(const Duration(seconds: 2), () {
      if (!_focusNodeText.hasFocus &&
          sharedController.mapSearchTE.text.isEmpty) {
        _controller.forward().then((_) {
          setState(() {
            _currentHintIndex = (_currentHintIndex + 1) % hints.length;
          });
          _controller.reverse().then((_) {
            _changeHintText();
          });
        });
      } else {
        _changeHintText();
      }
    });
  }

  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('id') ?? 0;

    if (await FirstRunService.getFirstRunFlag(userId)) {
      await _createTutorial();
      await FirstRunService.setFirstRunFlag(userId, false);
    }
  }

  Future<void> _fetchLocation() async {
    try {
      Position position = await getCurrentLocation();
      if (sharedController.googleMapController != null) {
        sharedController.googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(
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
            icon: customMyLocationMarker != null
                ? customMyLocationMarker!
                : BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'My Location'),
          ));
        });

        await updateLocation(position.latitude, position.longitude);

        String? currentAddress = await getAddressFromCoordinates(
            position.latitude, position.longitude);
        if (currentAddress != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setDouble('latitude', position.latitude);
          prefs.setDouble('longitude', position.longitude);
          prefs.setString('currentAddress', currentAddress);
          print('User address: $currentAddress');
        }
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
      serviceEnabled = await location.requestService();
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Unknown Location");
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
      // ✅ Update to your API (already existing)
      var response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/profile/update-location'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': _userId.toString(),
          'latitude': latitude,
          'longitude': longitude,
        }),
      );

      if (response.statusCode == 200) {
        print('✅ Location updated successfully to API!');
      } else {
        print('❌ Failed to update location to API');
      }

      // ✅ Also update Firestore
      await FirebaseFirestore.instance
          .collection("locations")
          .doc(_userId.toString())
          .set({
        "latitude": latitude,
        "longitude": longitude,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("📍 Firestore location updated: $latitude, $longitude");
    } catch (e) {
      print('Error updating location: $e');
    }

    findNearestSafezone();
  }

  Future<String?> getAddressFromCoordinates(
      double latitude, double longitude) async {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      if (data['status'] == 'OK') {
        return data['results'][0]['formatted_address'];
      } else {
        print('Failed to get address: ${data['status']}');
        return null;
      }
    } catch (e) {
      print('Error fetching address: $e');
      return null;
    }
  }

  void _startLocationUpdates() {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5,
      ),
    ).listen((Position position) async {
      LatLng userLocation = LatLng(position.latitude, position.longitude);

      if (sharedController.googleMapController != null) {
        sharedController.googleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(
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
            icon: customMyLocationMarker ?? BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'My Location'),
          ));
        });

        await updateLocation(position.latitude, position.longitude);
      }

      bool isInsideSafeZone = _isInsideZone(
          userLocation,
          sharedController.circles
              .where(
                  (circle) => circle.fillColor == Colors.green.withOpacity(0.1))
              .toList());
      bool isInsideDangerZone = _isInsideZone(
          userLocation,
          sharedController.circles
              .where(
                  (circle) => circle.fillColor == Colors.red.withOpacity(0.1))
              .toList());

      bool wasInsideSafeZone = _prefs.getBool('wasInsideSafeZone') ?? false;
      bool wasInsideDangerZone = _prefs.getBool('wasInsideDangerZone') ?? false;

      if (isInsideSafeZone && !wasInsideSafeZone) {
        _showZoneDialog("Safe Zone", "You have entered a safe zone.");
        _sendBroadcastNotification(
            "Group member - Safe Zone", "has entered a safe zone.");
        await _prefs.setBool('wasInsideSafeZone', true);
      } else if (!isInsideSafeZone && wasInsideSafeZone) {
        _showZoneDialog("Safe Zone", "You have exited the safe zone.");
        _sendBroadcastNotification(
            "Group member - Safe Zone", "has exited the safe zone.");
        await _prefs.setBool('wasInsideSafeZone', false);
      }

      if (isInsideDangerZone && !wasInsideDangerZone) {
        _showZoneDialog("Danger Zone",
            "You have entered a danger zone. Please be cautious.");
        _sendBroadcastNotification("Group member - Danger Zone",
            "has entered a danger zone. Please be cautious.");
        await _prefs.setBool('wasInsideDangerZone', true);
      } else if (!isInsideDangerZone && wasInsideDangerZone) {
        _showZoneDialog("Danger Zone", "You have exited the danger zone.");
        _sendBroadcastNotification(
            "Group member - Danger Zone", "has exited the danger zone.");
        await _prefs.setBool('wasInsideDangerZone', false);
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

  Future<void> _createCustomMarker() async {
    try {
      customMyLocationMarker = await MarkerUtils.createCustomUserMarker(
          context, widgetPricolor, profilePictureUrl);

      customPendingDangerZoneMarker = await MarkerUtils.resizeMarker(
        'lib/resource/image/png/marker_danger_pending.png',
        70,
        77,
      );

      customDangerZoneMarker = await MarkerUtils.resizeMarker(
        'lib/resource/image/png/dangerzone.png',
        70,
        77,
      );

      customSafeZoneMarker = await MarkerUtils.resizeMarker(
        'lib/resource/image/png/safezone.png',
        70,
        77,
      );

      if (mounted) {
        setState(() {});
      }

      print("✅ All custom markers loaded successfully");
    } catch (e) {
      print("Error loading markers: $e");
    }
  }

  Set<Marker> _createMarkers(MapState state) {
    Set<Marker> markers = {};

    if (!_areCustomMarkersLoaded) {
      print("Custom markers not yet loaded, showing minimal markers");
      if (_currentUserLocation != null) {
        markers.add(
          Marker(
            markerId: const MarkerId("My Location"),
            position: _currentUserLocation!,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: const InfoWindow(title: 'My Location'),
          ),
        );
      }
      return markers;
    }

    if (_currentUserLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId("My Location"),
          position: _currentUserLocation!,
          icon: customMyLocationMarker!,
          infoWindow: const InfoWindow(title: 'My Location'),
        ),
      );
    }

    if (state is MapDataLoaded) {
      for (var member in _currentMembers) {
        String userId = member['user_id'].toString();
        String firstName = member['first_name'];
        String lastName = member['last_name'];
        double latitude = member['latitude'];
        double longitude = member['longitude'];
        String profile = member['profile_picture'];

        BitmapDescriptor? memberMarker = memberMarkers[userId];

        if (userId == _userId.toString()) {
          continue;
        }

        markers.add(
          Marker(
            markerId: MarkerId(userId),
            position: LatLng(latitude, longitude),
            icon: memberMarker ?? BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: '$firstName $lastName'),
            onTap: () {
              showMemberBottomSheet(userId, firstName, lastName, longitude,
                  latitude, profile, context);
            },
          ),
        );
      }

      for (var dangerZone in state.dangerZones) {
        final dangerZoneIcon = dangerZone.isVerified
            ? customDangerZoneMarker!
            : customPendingDangerZoneMarker!;

        markers.add(
          Marker(
            markerId: MarkerId(dangerZone.id.toString()),
            icon: dangerZoneIcon,
            position: LatLng(dangerZone.latitude!, dangerZone.longitude!),
            infoWindow: InfoWindow(title: dangerZone.name),
            onTap: () {
              showDangerZoneBottomSheet(dangerZone, context);
            },
          ),
        );

        final circleColor = dangerZone.isVerified
            ? Colors.red.withOpacity(0.1)
            : Colors.yellow.withOpacity(0.2);

        sharedController.circles.add(
          Circle(
            circleId: CircleId('danger_${dangerZone.id}'),
            center: LatLng(dangerZone.latitude!, dangerZone.longitude!),
            radius: dangerZone.radius ?? 100.0,
            strokeWidth: 1,
            strokeColor: circleColor.withOpacity(0.6),
            fillColor: circleColor,
          ),
        );
      }

      for (var safeZone in state.safeZones) {
        markers.add(
          Marker(
            markerId: MarkerId(safeZone.id.toString()),
            icon: customSafeZoneMarker!,
            position: LatLng(safeZone.latitude!, safeZone.longitude!),
            infoWindow: InfoWindow(title: safeZone.name),
            onTap: () {
              showSafeZoneBottomSheet(safeZone, context);
            },
          ),
        );

        sharedController.circles.add(
          Circle(
            circleId: CircleId('safe_${safeZone.id}'),
            center: LatLng(safeZone.latitude!, safeZone.longitude!),
            radius: safeZone.radius ?? 100.0,
            strokeWidth: 1,
            strokeColor: Colors.green.withOpacity(0.6),
            fillColor: Colors.green.withOpacity(0.1),
          ),
        );
      }
    }

    return markers;
  }

  Future<SafeZoneModel?> getNearestStation(LatLng currentPosition) async {
    double minDistance = double.infinity;
    SafeZoneModel? nearest;

    for (var station in policeStations) {
      if (station.latitude == null || station.longitude == null) continue;
      double distance = Geolocator.distanceBetween(
        currentPosition.latitude,
        currentPosition.longitude,
        station.latitude!,
        station.longitude!,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = station;
      }
    }

    return nearest;
  }

  Future<void> findNearestSafezone() async {
    SafeZoneModel? nearest = await getNearestStation(_currentUserLocation!);

    if (nearest != null) {
      print("Nearest Police Station: ${nearest.name}");
    } else {
      print("No valid stations found.");
    }
  }

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
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePolylines(Set<Polyline> updatedPolylines) {
    setState(() {
      sharedController.polylines = updatedPolylines;
    });
  }

  void _findAllRoute() {
    if (!_isAllZoneShown) {
      ZoneNavigator(
        googleMapController: sharedController.googleMapController,
        currentUserLocation: _currentUserLocation,
        safeZones: _safeZones,
        dangerZones: _dangerZones,
        onPolylinesUpdated: _updatePolylines,
        context: context,
      ).findNearestZones();

      setState(() {
        _isAllZoneShown = true;
        _isDangerZoneShown = false;
        _isSafeZoneShown = false;
      });
    } else {
      _resetMap();
      setState(() {
        _isAllZoneShown = false;
      });
    }
  }

  void _findSafeRoute() {
    if (!_isSafeZoneShown) {
      ZoneNavigator(
        googleMapController: sharedController.googleMapController,
        currentUserLocation: _currentUserLocation,
        safeZones: _safeZones,
        onPolylinesUpdated: _updatePolylines,
        context: context,
      ).findNearestSafeZone();

      setState(() {
        _isSafeZoneShown = true;
        _isAllZoneShown = false;
        _isDangerZoneShown = false;
      });
    } else {
      _resetMap();
      setState(() {
        _isSafeZoneShown = false;
      });
    }
  }

  void _findDangerRoute() {
    if (!_isDangerZoneShown) {
      ZoneNavigator(
        googleMapController: sharedController.googleMapController,
        currentUserLocation: _currentUserLocation,
        dangerZones: _dangerZones,
        onPolylinesUpdated: _updatePolylines,
        context: context,
      ).findNearestDangerZone();

      setState(() {
        _isDangerZoneShown = true;
        _isAllZoneShown = false;
        _isSafeZoneShown = false;
      });
    } else {
      _resetMap();
      setState(() {
        _isDangerZoneShown = false;
      });
    }
  }

  void _resetMap() {
    setState(() {
      sharedController.polylines.clear();
    });

    sharedController.googleMapController?.animateCamera(
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

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    _updateMapPosition(LatLng(position.latitude, position.longitude));
  }

  void _updateMapPosition(LatLng newPosition) async {
    setState(() {
      _initialPosition = newPosition;
    });

    final GoogleMapController controller =
        await sharedController.mapController.future;
    controller
        .animateCamera(CameraUpdate.newLatLngZoom(_initialPosition, 14.0));
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  void _searchLocation() async {
    if (sharedController.mapSearchTE.text.isNotEmpty) {
      String location = sharedController.mapSearchTE.text;
      String url =
          "https://maps.googleapis.com/maps/api/geocode/json?address=$location&key=$apiKey";

      try {
        final response = await http.get(Uri.parse(url));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);

          if (data["status"] == "OK") {
            double lat = data["results"][0]["geometry"]["location"]["lat"];
            double lng = data["results"][0]["geometry"]["location"]["lng"];

            _updateMapPosition(LatLng(lat, lng));
          }
        }
      } catch (e) {
        _showSnackBar("Network error: Unable to fetch location.");
      }
    } else {
      _showSnackBar("Please enter a location to search.");
    }
  }

  void _listenForMembers(int circleId) {
    // Cancel any existing subscription
    _membersSubscription?.cancel();
    print("🔔 Starting Firestore listener for circle $circleId");

    // Listen to members in this circle who are sharing their location
    _membersSubscription = FirebaseFirestore.instance
        .collection("locations")
        .where("circleSharing.$circleId", isEqualTo: true)
        .snapshots()
        .listen((snapshot) async {
      print("📄 Firestore snapshot received: ${snapshot.docs.length} docs");

      List<Map<String, dynamic>> members = [];

      for (var doc in snapshot.docs) {
        var data = doc.data();

        // Directly get latitude and longitude from top-level fields
        double? lat = (data['latitude'] != null)
            ? (data['latitude'] as num).toDouble()
            : null;
        double? lng = (data['longitude'] != null)
            ? (data['longitude'] as num).toDouble()
            : null;

        if (lat != null && lng != null) {
          members.add({
            'user_id': doc.id,
            'first_name': data['first_name'] ?? 'User',
            'last_name': data['last_name'] ?? '',
            'profile_picture': data['profile_picture'] ?? '',
            'latitude': lat,
            'longitude': lng,
          });

          print(
              "👤 Member added: ${data['first_name']} ${data['last_name']} at ($lat, $lng)");
        } else {
          print("⚠️ Member ${doc.id} skipped: no valid location");
        }
      }
      context.read<MapBloc>().add(ListenForMemberLocations(members, _userId!));

      print("✅ Total valid members fetched: ${members.length}");
      _currentMembers = members;

      print("⏳ Preloading custom member markers...");
      await _preloadMemberMarkers(members);

      print("🗺 Updating member markers on map...");
      _updateMemberMarkersOnMap();
    });
  }

  void _updateMemberMarkersOnMap() {
    if (!mounted) return;

    setState(() {
      // Remove old member markers
      markers.removeWhere((marker) => _currentMembers
          .any((member) => member['user_id'] == marker.markerId.value));

      // Add updated member markers
      markers.addAll(_createMemberMarkers(_currentMembers));
      print("Member markers updated on map: ${_currentMembers.length}");
    });
  }

  Set<Marker> _createMemberMarkers(List<Map<String, dynamic>> members) {
    Set<Marker> memberMarkersSet = {};

    for (var member in members) {
      String userId = member['user_id'].toString();
      String firstName = member['first_name'] ?? 'User';
      String lastName = member['last_name'] ?? '';
      double latitude = member['latitude'];
      double longitude = member['longitude'];
      String profile = member['profile_picture'] ?? '';

      if (userId == _userId.toString()) continue;

      BitmapDescriptor? markerIcon = memberMarkers[userId];

      print(
          "📌 Creating marker for $firstName $lastName at ($latitude, $longitude) with icon ${markerIcon != null ? 'custom' : 'default'}");

      memberMarkersSet.add(
        Marker(
          markerId: MarkerId(userId),
          position: LatLng(latitude, longitude),
          icon: markerIcon ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(title: '$firstName $lastName'),
          onTap: () {
            showMemberBottomSheet(userId, firstName, lastName, longitude,
                latitude, profile, context);
          },
        ),
      );
    }

    print("🎯 Total member markers created: ${memberMarkersSet.length}");
    return memberMarkersSet;
  }

  void _updateMemberMarker(
      String userId, double latitude, double longitude) async {
    if (userId == _userId.toString()) {
      print("⏩ Skipped updating own marker for userId: $userId");
      return;
    }

    BitmapDescriptor? memberMarker = memberMarkers[userId];

    var memberData = _currentMembers.firstWhere(
      (member) => member['user_id'] == userId,
      orElse: () => {},
    );

    if (memberData.isEmpty) {
      print("⚠️ No member data found for userId: $userId");
      return;
    }

    setState(() {
      int before = markers.length;
      markers.removeWhere((marker) => marker.markerId.value == userId);
      int afterRemove = markers.length;

      if (before != afterRemove) {
        print("🗑 Removed old marker for $userId");
      } else {
        print("ℹ️ No existing marker found for $userId (adding new one)");
      }

      markers.add(
        Marker(
          markerId: MarkerId(userId),
          position: LatLng(latitude, longitude),
          icon: memberMarker ?? BitmapDescriptor.defaultMarker,
          infoWindow: InfoWindow(
            title: '${memberData['first_name']} ${memberData['last_name']}',
          ),
          onTap: () {
            print("👆 Marker tapped for $userId: "
                "${memberData['first_name']} ${memberData['last_name']}");
            showMemberBottomSheet(
              userId,
              memberData['first_name'],
              memberData['last_name'],
              longitude,
              latitude,
              memberData['profile_picture'],
              context,
            );
          },
        ),
      );

      print("✅ Added/Updated marker for $userId "
          "(${memberData['first_name']} ${memberData['last_name']}) "
          "@ ($latitude, $longitude) | Total markers: ${markers.length}");
    });
  }

  Future<void> _preloadMemberMarkers(List<Map<String, dynamic>> members) async {
    for (var member in members) {
      String userId = member['user_id'];
      if (userId == _userId.toString()) continue;

      String? profileUrl = member['profile_picture'];
      if (!memberMarkers.containsKey(userId)) {
        BitmapDescriptor marker =
            await MarkerUtils.loadMemberProfileMarker(profileUrl);
        memberMarkers[userId] = marker;
        print("🖼 Marker preloaded for member $userId (profile: $profileUrl)");
      }
    }
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
            Positioned.fill(
                child: MultiBlocListener(
              listeners: [
                BlocListener<MapBloc, MapState>(
                  listener: (context, state) {
                    if (state is MemberLocationUpdated) {
                      print(
                          "}}}}}}}}}}}}}}}}}}}}}}}}}}MemberLocationUpdated received for user: ${state.userId}");
                      _updateMemberMarker(
                        state.userId,
                        state.latitude,
                        state.longitude,
                      );
                      print(state.userId);
                      print(
                        state.latitude,
                      );
                      print(state.longitude);
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
                        child: Container(
                      color: ui.Color.fromARGB(199, 250, 250, 250),
                      child: Center(
                        child: Transform.translate(
                            offset: const Offset(-40, 0),
                            child: const LoadingState()),
                      ),
                    ));
                  } else if (state is MapDataLoaded) {
                    //_currentMembers = state.members;
      
                    // WidgetsBinding.instance.addPostFrameCallback((_) async {
                    //   await _preloadMemberMarkers(state.members);
                    //   setState(() {});
                    // });
                  } else if (state is MapError) {
                    return Center(child: Text(state.message));
                  }
                  return ValueListenableBuilder<int>(
                    valueListenable: sharedController.currentMapType,
                    builder: (context, mapTypeIndex, _) {
                      final mapType = mapTypeIndex == 0 ? MapType.normal : MapType.satellite;

                      return GoogleMap(
                        initialCameraPosition: const CameraPosition(
                          target: sourceLocation,
                          zoom: 14.0,
                        ),
                        mapType: mapType,
                        markers: sharedController.showMarkers ? _createMarkers(state) : {},
                        circles: sharedController.circles,
                        polylines: sharedController.polylines,
                        onMapCreated: (GoogleMapController controller) async {
                          sharedController.googleMapController = controller;
                          String style = '''
                            [
                              {
                                "featureType": "administrative",
                                "elementType": "labels.text",
                                "stylers": [
                                  { "visibility": "off" }
                                ]
                              },
                              {
                                "featureType": "administrative.locality",
                                "elementType": "labels.text",
                                "stylers": [
                                  { "visibility": "on" }
                                ]
                              },
                              {
                                "featureType": "administrative.neighborhood",
                                "elementType": "labels.text",
                                "stylers": [
                                  { "visibility": "on" }
                                ]
                              },
                              {
                                "featureType": "poi",
                                "elementType": "labels.text",
                                "stylers": [
                                  { "visibility": "off" }
                                ]
                              },
                              {
                                "featureType": "poi.business",
                                "elementType": "labels",
                                "stylers": [
                                  { "visibility": "off" }
                                ]
                              },
                              {
                                "featureType": "poi.government",
                                "elementType": "labels",
                                "stylers": [
                                  { "visibility": "on" }
                                ]
                              },
                              {
                                "featureType": "poi.medical",
                                "elementType": "labels",
                                "stylers": [
                                  { "visibility": "on" }
                                ]
                              },
                              {
                                "featureType": "transit.station.bus",
                                "elementType": "labels",
                                "stylers": [
                                  { "visibility": "off" }
                                ]
                              },
                              {
                                "featureType": "road",
                                "elementType": "labels",
                                "stylers": [
                                  { "visibility": "off" }
                                ]
                              }
                            ]
                            ''';
                          controller.setMapStyle(style);
                        },
                        mapToolbarEnabled: false,
                        zoomControlsEnabled: false,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                      );
                    },
                  );
                },
              ),
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppBar(
                  toolbarHeight: 0,
                  automaticallyImplyLeading: false,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _appBarHeight,
                  color: _appBarColor,
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: _showTitle
                      ? const CategoryDescripText(
                          text: "you are already signed in.",
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(height: 10),
                widget.UserToken == 'guest'
                    ? Container()
                    : PreferredSize(
                        preferredSize: const Size.fromHeight(120.0),
                        child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Column(children: [
                              Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                            child: const AccountDetails(),
                                            type: PageTransitionType.fade,
                                            duration: const Duration(
                                                milliseconds: 300),
                                          ),
                                        );
                                      },
                                      child: Container(
                                          width: 40,
                                          height: 40,
                                          padding: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                                offset: Offset(1, 1),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: profilePictureUrl
                                                      .isNotEmpty
                                                  ? SizedBox(
                                                      width: 35,
                                                      height: 35,
                                                      child: Image.network(
                                                        profilePictureUrl,
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (context, error,
                                                                stackTrace) {
                                                          return Image.asset(
                                                            'lib/resource/image/jpg/profile.jpg',
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    )
                                                  : Image.asset(
                                                      'lib/resource/image/jpg/profile.jpg',
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ))),
                                  const SizedBox(width: 10),
                                  Expanded(
                                      child: GestureDetector(
                                          onTap: _toggleCircles,
                                          child: Container(
                                              height: 40,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    blurRadius: 2,
                                                    offset: Offset(1, 1),
                                                  ),
                                                ],
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Row(children: [
                                                _circles.isEmpty
                                                    ? const Center(
                                                        child: SizedBox(
                                                        child: Text(
                                                            "No Circle",
                                                            style: TextStyle(
                                                                fontSize: 11,
                                                                color: Colors
                                                                    .black54)),
                                                      ))
                                                    : Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: _circles
                                                            .where((circle) =>
                                                                circle
                                                                    .isActive)
                                                            .map((circle) =>
                                                                CategoryDescripText(
                                                                  text: circle
                                                                      .name,
                                                                  color: Colors
                                                                      .black,
                                                                ))
                                                            .toList(),
                                                      ),
                                                // SizedBox(width: 40),
                                                // LimitedImageCircles(
                                                //   imageUrls: [
                                                //     "lib/resource/image/jpg/profile.jpg",
                                                //     "lib/resource/image/jpg/profile.jpg",
                                                //     "lib/resource/image/jpg/profile.jpg",
                                                //     "lib/resource/image/jpg/profile.jpg",
                                                //   ],
                                                // ),
                                                const Spacer(),
                                                // Icon(Icons.keyboard_arrow_down,
                                                //     color: Colors.black38),
                                              ])))),
                                  const SizedBox(width: 10),
                                  for (var circle in _circles
                                      .where((circle) => circle.isActive))
                                    circle.code.isEmpty
                                        ? Container()
                                        : GestureDetector(
                                            onTap: () {
                                              bool hasActiveCircle =
                                                  _circles.any((circle) =>
                                                      circle.isActive);
                                              if (hasActiveCircle) {
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape:
                                                      const RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.vertical(
                                                            top: Radius
                                                                .circular(
                                                                    10)),
                                                  ),
                                                  builder:
                                                      (BuildContext context) {
                                                    return FractionallySizedBox(
                                                        heightFactor: 0.3,
                                                        child: Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.vertical(
                                                                    top: Radius
                                                                        .circular(
                                                                            10)),
                                                            color:
                                                                Colors.white,
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 50,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  color: Colors
                                                                      .white,
                                                                  boxShadow: [
                                                                    BoxShadow(
                                                                      color: Colors
                                                                          .grey,
                                                                      blurRadius:
                                                                          2,
                                                                      offset: Offset(
                                                                          1,
                                                                          1),
                                                                    ),
                                                                  ],
                                                                  borderRadius:
                                                                      BorderRadius.vertical(
                                                                          top:
                                                                              Radius.circular(10)),
                                                                ),
                                                                child: Row(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                        child:
                                                                            SizedBox()),
                                                                    CategoryText(
                                                                        text:
                                                                            'Invite Code'),
                                                                    Expanded(
                                                                      child: Align(
                                                                          alignment: Alignment.centerRight,
                                                                          child: Container(
                                                                              margin: EdgeInsets.only(right: 15),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: CategoryDescripText(text: 'Done', color: widgetPricolor),
                                                                              ))),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              Container(
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          15,
                                                                      vertical:
                                                                          15),
                                                                  width: double
                                                                      .infinity,
                                                                  child:
                                                                      Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      for (var circle in _circles.where((circle) =>
                                                                          circle
                                                                              .isActive))
                                                                        Container(
                                                                            margin: const EdgeInsets.symmetric(vertical: 30),
                                                                            child: Text(circle.code, style: const TextStyle(fontWeight: FontWeight.bold, color: widgetPricolor, fontSize: 30))),
                                                                      const CategoryText(
                                                                          text:
                                                                              'Share this invite code with the\n people you want in your Circle: ',
                                                                          alignment:
                                                                              'center',
                                                                          color:
                                                                              Colors.black),
                                                                    ],
                                                                  ))
                                                            ],
                                                          ),
                                                        ));
                                                  },
                                                );
                                              }
                                            },
                                            child: Container(
                                                width: 40,
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2,
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: const Center(
                                                    child: Icon(
                                                  Icons.person_add,
                                                  size: 20,
                                                  color: widgetPricolor,
                                                ))))
                                ],
                              )
                            ]))),
                const SizedBox(height: 10),
                // Container(
                //     height: _circleHeight ? 400 : 0,
                //     width: double.infinity,
                //     decoration: BoxDecoration(
                //       color: Colors.white,
                //       borderRadius: BorderRadius.circular(5),
                //       boxShadow: const [
                //         BoxShadow(
                //           color: Colors.grey,
                //           blurRadius: 2,
                //           offset: Offset(1, 1),
                //         ),
                //       ],
                //     ),
                //     margin: EdgeInsets.only(
                //         bottom: _circleHeight ? 10 : 0, left: 15, right: 15),
                //     padding: EdgeInsets.all(15),
                //     child: SingleChildScrollView(
                //       physics: const AlwaysScrollableScrollPhysics(),
                //       child: Column(
                //         children: [
                //           for (var circle
                //               in _circles.where((circle) => circle.isActive))
                //             ListTile(
                //               title: Text(circle.name),
                //               subtitle: Column(
                //                 crossAxisAlignment: CrossAxisAlignment.start,
                //                 children: [
                //                   Text("Status: Active"),
                //                   Text("Code: ${circle.code}"),
                //                 ],
                //               ),
                //             ),
                //         ],
                //       ),
                //     )),
                widget.UserToken == 'guest'
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 40,
                                child: Center(
                                  child: Container(
                                      height: 40,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 2,
                                            offset: Offset(1, 1),
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Stack(
                                              children: [
                                                Positioned.fill(
                                                  child: TextField(
                                                    controller:
                                                        sharedController
                                                            .mapSearchTE,
                                                    focusNode: _focusNodeText,
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize: 9,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    ),
                                                    decoration:
                                                        InputDecoration(
                                                      filled: true,
                                                      fillColor: Colors.white,
                                                      hintText: '',
                                                      hintStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .transparent),
                                                      contentPadding:
                                                          const EdgeInsets
                                                              .only(
                                                              left: 35,
                                                              right: 40,
                                                              bottom: 8),
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    widgetPricolor),
                                                      ),
                                                      focusedBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    widgetPricolor),
                                                      ),
                                                      enabledBorder:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    20.0),
                                                        borderSide:
                                                            const BorderSide(
                                                                color:
                                                                    widgetPricolor),
                                                      ),
                                                    ),
                                                    onSubmitted: (value) {
                                                      _searchLocation();
                                                    },
                                                  ),
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      color:
                                                          Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'lib/resource/svg/search.svg',
                                                        color: Colors.black,
                                                        height: 20,
                                                        width: 20,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                    GestureDetector(
                                                      key: _searchKey,
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                _focusNodeText);
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                right: 4),
                                                        child:
                                                            AnimatedBuilder(
                                                          animation:
                                                              _controllerFade,
                                                          builder: (context,
                                                              child) {
                                                            return Row(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Transform
                                                                    .translate(
                                                                  offset:
                                                                      const Offset(
                                                                          -5,
                                                                          0),
                                                                  child:
                                                                      CategoryDescripText(
                                                                    text:
                                                                        "Search for nearest",
                                                                    color: _colorAnimation
                                                                        .value,
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ),
                                                    Transform.translate(
                                                        offset: const Offset(
                                                            -5, 0),
                                                        child: SlideTransition(
                                                            position: _hintAnimation,
                                                            child: AnimatedBuilder(
                                                                animation: _hintColorAnimation,
                                                                builder: (context, child) {
                                                                  return GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        FocusScope.of(context)
                                                                            .requestFocus(_focusNode);
                                                                      },
                                                                      child:
                                                                          CategoryDescripText(
                                                                        text:
                                                                            hints[_currentHintIndex],
                                                                        color: _hintAnimation.isCompleted
                                                                            ? Colors.transparent
                                                                            : _hintColorAnimation.value,
                                                                      ));
                                                                })))
                                                  ],
                                                ),
                                                Positioned(
                                                  top: 0,
                                                  right: _isExpanded ? 5 : 5,
                                                  child: GestureDetector(
                                                    onTap: () async {
                                                      if (!_isListening) {
                                                        bool available =
                                                            await _speech
                                                                .initialize();
                                                        if (available) {
                                                          setState(() =>
                                                              _isListening =
                                                                  true);
                                                          _speech.listen(
                                                            onResult:
                                                                (result) {
                                                              setState(() {
                                                                sharedController
                                                                        .mapSearchTE
                                                                        .text =
                                                                    result
                                                                        .recognizedWords;
                                                              });
                                                            },
                                                            listenFor:
                                                                const Duration(
                                                                    seconds:
                                                                        5),
                                                          );
                                                        }
                                                      } else {
                                                        setState(() =>
                                                            _isListening =
                                                                false);
                                                        _speech.stop();
                                                      }
                                                    },
                                                    child: Container(
                                                      height: 40,
                                                      width: 40,
                                                      alignment:
                                                          Alignment.center,
                                                      color:
                                                          Colors.transparent,
                                                      child: SvgPicture.asset(
                                                        'lib/resource/svg/mic.svg',
                                                        color: Colors.black87,
                                                        height: 22,
                                                        width: 22,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (sharedController
                                                    .mapSearchTE
                                                    .text
                                                    .isNotEmpty) {
                                                  _searchLocation();
                                                } else {
                                                  _isExpanded = false;
                                                  sharedController.mapSearchTE
                                                      .clear();
                                                  _focusNodeText.unfocus();
                                                }
                                              });
                                            },
                                            child: Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius:
                                                    BorderRadius.only(
                                                        bottomRight:
                                                            Radius.circular(
                                                                20),
                                                        topRight:
                                                            Radius.circular(
                                                                20)),
                                              ),
                                              child: const Center(
                                                child: Icon(Icons.send,
                                                    color: Colors.white,
                                                    size: 18),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )),
                                ),
                              ),
                              const SizedBox(height: 10),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _findAllRoute();
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            width: 60,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _isAllZoneShown
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 5),
                                                Icon(Icons.safety_check,
                                                    color: Colors.blue),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: CategoryDescripText(
                                                    text: "All",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: _findSafeRoute,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 10),
                                            width: 160,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _isSafeZoneShown
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 5),
                                                Icon(Icons.safety_check,
                                                    color: Colors.green),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: CategoryDescripText(
                                                    text:
                                                        "Show nearest safe zone",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _findDangerRoute();
                                          },
                                          child: Container(
                                            width: 170,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: _isDangerZoneShown
                                                  ? Colors.grey[300]
                                                  : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.grey,
                                                  blurRadius: 2,
                                                  offset: Offset(1, 1),
                                                ),
                                              ],
                                            ),
                                            child: const Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SizedBox(width: 5),
                                                Icon(Icons.safety_check,
                                                    color: Colors.red),
                                                SizedBox(width: 5),
                                                Expanded(
                                                  child: CategoryDescripText(
                                                    text:
                                                        "Show nearest danger zone",
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ]))
                            ]))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 15),
                            GestureDetector(onTap: () {
                              if (!_isExpanded) {
                                setState(() {
                                  _isExpanded = true;
                                });
                              }
                            }, child: LayoutBuilder(
                                builder: (context, constraints) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin: const EdgeInsets.only(right: 10),
                                width: _isExpanded ? 330 : 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                      _isExpanded ? 20 : 50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: _isExpanded
                                    ? Center(
                                        child: SizedBox(
                                            height: 40,
                                            child: Container(
                                                height: 40,
                                                width: double.infinity,
                                                decoration:
                                                    const BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              20)),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      blurRadius: 2,
                                                      offset: Offset(1, 1),
                                                    ),
                                                  ],
                                                ),
                                                child: Row(children: [
                                                  Expanded(
                                                    child: Stack(
                                                      children: [
                                                        Positioned.fill(
                                                          child: TextField(
                                                            controller:
                                                                sharedController
                                                                    .mapSearchTE,
                                                            focusNode:
                                                                _focusNodeText,
                                                            style: GoogleFonts
                                                                .poppins(
                                                              fontSize: 9,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Colors
                                                                  .black,
                                                            ),
                                                            decoration:
                                                                InputDecoration(
                                                              filled: true,
                                                              fillColor:
                                                                  Colors
                                                                      .white,
                                                              hintText: '',
                                                              hintStyle: const TextStyle(
                                                                  color: Colors
                                                                      .transparent),
                                                              contentPadding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          35,
                                                                      right:
                                                                          40,
                                                                      bottom:
                                                                          8),
                                                              border:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color:
                                                                            widgetPricolor),
                                                              ),
                                                              focusedBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color:
                                                                            widgetPricolor),
                                                              ),
                                                              enabledBorder:
                                                                  OutlineInputBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            20.0),
                                                                borderSide:
                                                                    const BorderSide(
                                                                        color:
                                                                            widgetPricolor),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        Row(
                                                          children: [
                                                            Container(
                                                              height: 40,
                                                              width: 40,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  SvgPicture
                                                                      .asset(
                                                                'lib/resource/svg/search.svg',
                                                                color: Colors
                                                                    .black,
                                                                height: 20,
                                                                width: 20,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right:
                                                                          4),
                                                              child:
                                                                  AnimatedBuilder(
                                                                animation:
                                                                    _controllerFade,
                                                                builder:
                                                                    (context,
                                                                        child) {
                                                                  return Transform
                                                                      .translate(
                                                                    offset:
                                                                        const Offset(
                                                                            -5,
                                                                            0),
                                                                    child:
                                                                        CategoryDescripText(
                                                                      text:
                                                                          "Search for nearest",
                                                                      color: _colorAnimation
                                                                          .value,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                            Transform
                                                                .translate(
                                                              offset:
                                                                  const Offset(
                                                                      -5, 0),
                                                              child:
                                                                  SlideTransition(
                                                                position:
                                                                    _hintAnimation,
                                                                child:
                                                                    AnimatedBuilder(
                                                                  animation:
                                                                      _hintColorAnimation,
                                                                  builder:
                                                                      (context,
                                                                          child) {
                                                                    return CategoryDescripText(
                                                                      text: hints[
                                                                          _currentHintIndex],
                                                                      color: _hintAnimation.isCompleted
                                                                          ? Colors.transparent
                                                                          : _hintColorAnimation.value,
                                                                    );
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        Positioned(
                                                          top: 0,
                                                          right: 5,
                                                          child:
                                                              GestureDetector(
                                                            onTap: () async {
                                                              _focusNodeText
                                                                  .requestFocus();
                                                              if (!_isListening) {
                                                                bool
                                                                    available =
                                                                    await _speech
                                                                        .initialize();
                                                                if (available) {
                                                                  setState(() =>
                                                                      _isListening =
                                                                          true);
                                                                  _speech
                                                                      .listen(
                                                                    onResult:
                                                                        (result) {
                                                                      setState(
                                                                          () {
                                                                        sharedController
                                                                            .mapSearchTE
                                                                            .text = result.recognizedWords;
                                                                      });
                                                                    },
                                                                    listenFor:
                                                                        const Duration(
                                                                            seconds: 5),
                                                                  );
                                                                }
                                                              } else {
                                                                setState(() =>
                                                                    _isListening =
                                                                        false);
                                                                _speech
                                                                    .stop();
                                                              }
                                                            },
                                                            child: Container(
                                                              height: 40,
                                                              width: 40,
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              child:
                                                                  SvgPicture
                                                                      .asset(
                                                                'lib/resource/svg/mic.svg',
                                                                color: Colors
                                                                    .black87,
                                                                height: 22,
                                                                width: 22,
                                                                fit: BoxFit
                                                                    .contain,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          if (sharedController
                                                              .mapSearchTE
                                                              .text
                                                              .isNotEmpty) {
                                                            _searchLocation();
                                                          } else {
                                                            _isExpanded =
                                                                false;
                                                            sharedController
                                                                .mapSearchTE
                                                                .clear();
                                                            _focusNodeText
                                                                .unfocus();
                                                          }
                                                        });
                                                      },
                                                      child: Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration:
                                                              const BoxDecoration(
                                                            color:
                                                                Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          20),
                                                              topRight: Radius
                                                                  .circular(
                                                                      20),
                                                            ),
                                                          ),
                                                          child: Center(
                                                              child: ValueListenableBuilder<
                                                                  TextEditingValue>(
                                                            valueListenable:
                                                                sharedController
                                                                    .mapSearchTE,
                                                            builder: (context,
                                                                value,
                                                                child) {
                                                              return Transform
                                                                  .translate(
                                                                      offset: const Offset(
                                                                          -3.2,
                                                                          0),
                                                                      child:
                                                                          Icon(
                                                                        value.text.isNotEmpty
                                                                            ? Icons.send
                                                                            : Icons.close,
                                                                        color:
                                                                            Colors.white,
                                                                        size:
                                                                            18,
                                                                      ));
                                                            },
                                                          ))))
                                                ]))))
                                    : const Icon(Icons.search,
                                        color: Colors.black, size: 20),
                              );
                            })),
                            GestureDetector(
                              onTap: _findAllRoute,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 60,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isAllZoneShown
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.safety_check,
                                        color: Colors.blue),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: CategoryDescripText(
                                        text: "All",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _findSafeRoute,
                              child: Container(
                                margin: const EdgeInsets.only(right: 10),
                                width: 160,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isSafeZoneShown
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.safety_check,
                                        color: Colors.green),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: CategoryDescripText(
                                        text: "Show nearest safe zone",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: _findDangerRoute,
                              child: Container(
                                width: 170,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: _isDangerZoneShown
                                      ? Colors.grey[300]
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 2,
                                      offset: Offset(1, 1),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(width: 5),
                                    Icon(Icons.safety_check,
                                        color: Colors.red),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: CategoryDescripText(
                                        text: "Show nearest danger zone",
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
              ],
            ),
            widget.UserToken == 'guest'
                ? SizedBox(
                    width: double.infinity,
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: 15,
                          left: 15,
                          child: _buildRefreshButton(),
                        )
                      ],
                    ),
                  )
                : Positioned(
                    bottom: 15,
                    left: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRefreshButton(),
                            ])
                      ],
                    )),
            widget.UserToken == 'guest'
                ? const SizedBox()
                : Positioned(
                    right: 15,
                    bottom: 10,
                    child: SizedBox(
                      width: 60,
                      height: 160,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            key: _circleKey,
                            onTap: () async {
                              final result =
                                  await context.push('/groups-list');
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
                                    "lib/resource/svg/connect.svg",
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
                                  "lib/resource/svg/dangerzone.svg",
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
                                    "lib/resource/svg/safezone.svg",
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
      child: Icon(
        icon,
        color: labelFormFieldColor,
      ),
    ),
  );
}
