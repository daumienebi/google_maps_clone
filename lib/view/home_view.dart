import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_clone/utils/constants.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:developer' as dev;

class HomeView extends StatefulWidget{
  const HomeView({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeViewState();
  }
}

class _HomeViewState extends State<HomeView>
    with AutomaticKeepAliveClientMixin {

  // Google map's variable
  late var location;
  late LocationData? userLocation;
  final Set<Marker> _markerList = {};
  static const _initialCameraPosition =
  CameraPosition(target: LatLng(43.362343, -8.411540), zoom: 7.5);
  //Google Map stuffs
  CameraPosition _cameraPosition = _initialCameraPosition;
  bool _mapCreated = false;
  final bool _mapMoving = false;
  final bool _compasActivated = false;
  final bool _toolBarActivated = false;
  final CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  final MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  final MapType _mapType = MapType.normal;
  final bool _rotationActivated = true;
  final bool _scrollActivated = true;
  final bool _tiltActivated = true;
  final bool _zoomGestureActivated = true;
  final bool _zoomControlsActivated = false;
  final bool _interiorViewActivated = true;
  final bool _trafficActivated = false;
  final bool _localizationActivated = true;
  final bool _localizationButtonActivated = true;
  late GoogleMapController _mapController;
  final bool _nightMode = true;

  // Navigation bar variable
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    setUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
  }

  setUserLocation() async{
    location = Location().getLocation();
  }

  @override
  Widget build(BuildContext context) {
    //double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            heroTag: "heroTag1",
            onPressed: () => currentLocation(),
            child: const Icon(Icons.location_searching,color: Colors.black87,),
          ),
          const SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))
            ),
            backgroundColor: Constants.googleMapsBlue,
            heroTag: "heroTag2",
            onPressed: () => dev.log('yeh'),
            child: const Icon(Icons.directions),
          )
        ],
      ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index){
          setState(() {
            currentPageIndex = index;
          });
        },
        backgroundColor: Colors.grey[200],
        height: 60,
        indicatorColor: Colors.blue[100],
        selectedIndex: currentPageIndex,

        destinations: <Widget>[
          NavigationDestination(
              icon:
              const Icon(Icons.location_on_outlined,color: Colors.black54),
              label: 'Explore',
              selectedIcon: Icon(Icons.location_on,color: Constants.googleMapsBlue),
          ),
          NavigationDestination(
              icon: const Icon(Icons.directions_bus_outlined,color: Colors.black54),
              label: 'Go',
              selectedIcon: Icon(Icons.directions_bus,color: Constants.googleMapsBlue),
          ),
          NavigationDestination(
              icon: const Icon(Icons.archive_outlined,color: Colors.black54),
              label: 'Saved',
            selectedIcon: Icon(Icons.archive,color: Constants.googleMapsBlue),
          ),
          NavigationDestination(
              icon: const Icon(Icons.add_circle_outline,color: Colors.black54),
              label: 'Contribute',
            selectedIcon: Icon(Icons.add_circle,color: Constants.googleMapsBlue),
          ),
          NavigationDestination(
              icon: const Icon(Icons.notifications_none_outlined,color: Colors.black54),
              label: 'Update',
            selectedIcon: Icon(Icons.notifications,color: Constants.googleMapsBlue),
          ),
        ],

      ),

      body: Stack(
        children: [
          mapWidget(),
          positionedSearchBar(),
          positionedHorizontalListItems()

        ],
      ),
      );
  }

  Widget positionedSearchBar(){
    return Positioned(
      top: 30,
      left: 15,
      right: 15,
      child: InkWell(
        onTap: ()=> dev.log('Open search page'),
        child: Container(
          padding: const EdgeInsets.all(7.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                  color: Colors.black38,
                  blurRadius: 2,
                  offset: Offset(1,2),
                  blurStyle: BlurStyle.normal
              )
            ]
          ),

          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(FontAwesomeIcons.locationDot,color: Constants.googleMapsBlue,),
              const Text('Search here',style: TextStyle(fontSize: 15),textAlign: TextAlign.left),
              //using another row here to separate the last 2 items to the
              // end of the search bar
              Row(
                children: [
                  IconButton(
                      onPressed: (){
                        dev.log('Open mic dialog');
                      },
                      icon: const Icon(Icons.mic_rounded)
                  ),
                  IconButton(
                      onPressed: (){
                       dev.log('Open accounts dialog');
                      },
                      icon: const Icon(Icons.person_pin)
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  Widget positionedHorizontalListItems(){
    return Positioned(
      top: 90,
        left: 0,
        right: 0,
        child: Container(
          color: Colors.transparent,
          height: 55,
          child: ListView(
            padding: const EdgeInsets.all(5),
            scrollDirection: Axis.horizontal,
            children: [
              listItem(text:'Restaurants',
                  onPressed: ()=> {},
                  iconData: Icons.restaurant
              ),
              listItem(
                text:'Hotels',
                onPressed: () {

                },
                iconData: Icons.hotel_outlined
              ),
              listItem(
                text:'Groceries',
                onPressed: ()=> currentLocation(),
                iconData: Icons.local_grocery_store_outlined
              ),
              listItem(
                  text:'Gas',
                  onPressed: (){},
                  iconData: Icons.local_gas_station
              ),
              listItem(
                  text:'Bars',
                  onPressed: (){},
                  iconData: Icons.local_bar_sharp
              ),
              listItem(
                  text:'Attractions',
                  onPressed: (){},
                  iconData: Icons.attractions
              ),
              listItem(
                  text:'Shopping',
                  onPressed: (){},
                  iconData: Icons.shopping_bag_outlined
              ),
              listItem(
                  text:'More',
                  onPressed: (){},
                  iconData: Icons.more_horiz
              ),
            ],
          ),
        )
    );
  }

  Widget listItem({required String text,Function()? onPressed,IconData? iconData}){
    return Padding(
        padding: const EdgeInsets.all(7),
        child: ElevatedButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
          ),
          child: Row(
            children: [
              Icon(iconData,color: Colors.black87),
              const SizedBox(width: 5),
              Text(text,style: const TextStyle(color: Colors.black),)
            ],
          )

        )
    );
  }

  Widget getMap(double latitude, double longitude) {
    final GoogleMap googleMap = GoogleMap(
      initialCameraPosition:
      CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 1,
        tilt: 20,
      ),
      compassEnabled: _compasActivated,
      mapToolbarEnabled: _toolBarActivated,
      cameraTargetBounds: _cameraTargetBounds,
      minMaxZoomPreference: _minMaxZoomPreference,
      mapType: _mapType,
      rotateGesturesEnabled: _rotationActivated,
      scrollGesturesEnabled: _scrollActivated,
      tiltGesturesEnabled: _tiltActivated,
      zoomControlsEnabled: _zoomControlsActivated,
      zoomGesturesEnabled: _zoomGestureActivated,
      //myLocationButtonEnabled: _localizationButtonActivated,
      //myLocationEnabled: _localizationActivated,
      onMapCreated: onMapCreate,
      onCameraMove: _updateCameraPosition,
      trafficEnabled: _trafficActivated,
      markers: _markerList,
    );
    return googleMap;
  }

  /// method to navigate to the users current location
  void currentLocation() async {
    final GoogleMapController controller = _mapController;
    LocationData? currentLocation;
    var location = Location();
    try {
      currentLocation = await location.getLocation();
    } on Exception {
      currentLocation = null;
    }
    if (currentLocation != null) {
      controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 0,
          target: LatLng(currentLocation.latitude!, currentLocation.longitude!),
          zoom: 13.0,
        ),
      ));
    }
  }

  void moveToLocation(LatLng latLng) async {
    final GoogleMapController controller = _mapController;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        bearing: 0,
        target: LatLng(latLng.latitude, latLng.longitude),
        zoom: 14.0,
      ),
    ));
  }

  Widget mapWidget() {
    //the current location of the user has to be fetched
    return FutureBuilder(
        future: location,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            final position = snapshot.data;
            userLocation = snapshot.data;
            _mapCreated = true;
            //_userLocation = position;
            return getMap(position.latitude, position.longitude);
          } else {
            return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 100,
                      child: LoadingIndicator(
                        indicatorType: Indicator.ballPulseRise,
                        colors: [Colors.redAccent,Colors.white,Colors.blue],
                      ),
                    ),
                    Text('Loading map...')
                  ],
                )
            );
          }
        });
  }

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _cameraPosition = position;
    });
  }

  void onMapCreate(GoogleMapController mapController) {
    setState(() {
      _mapController = mapController;
    });
  }

  _launchUrl(Uri url) async{
    await launchUrl(url,mode:LaunchMode.externalApplication);
  }

  @override
  //https://stackoverflow.com/questions/56632225/google-maps-dequeuebuffer-bufferqueue-has-been-abandoned
  bool get wantKeepAlive => true;
}