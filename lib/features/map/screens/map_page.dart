import 'dart:async';

import 'package:fcs_flutter/features/map/services/google_map_services.dart';
import 'package:fcs_flutter/models/predictionModel.dart';
import 'package:fcs_flutter/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:provider/provider.dart';

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({Key? key}) : super(key: key);

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {

  final String googleApiKey = 'AIzaSyAu6kHkvkqn6gL-2XSS4_m--TpQbP3ZDTM';

  double bottomMapPadding = 0;
  final Completer<GoogleMapController> googleMapCompleterController = Completer<GoogleMapController>();
  GoogleMapController? controllerGoogleMap;
  Position? currentPosition;
  double searchContainerHeight = 220;

  TextEditingController destinationTextEditingController = TextEditingController();
  List<Predictionmodel> dropOffPredictionsPlacesList = [];
  
  searchPlace(String userInput) async {
    if (userInput.length > 1) 
    {
      var responseFromPlacesAPI = await GoogleMapServices.autoCompleteApi(userInput);

      if (responseFromPlacesAPI == "error") {
        return ;
      }

      var predictionResultInJson = responseFromPlacesAPI["suggestions"];

      print(predictionResultInJson);

      var predictionResultInNormalFormat = (predictionResultInJson as List).map((eachPredictedPlace) => Predictionmodel.fromPredictJson(eachPredictedPlace['placePrediction'])).toList();

      setState(() {
        dropOffPredictionsPlacesList = predictionResultInNormalFormat;
      });
    }
  }
  

  CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796, -122.08574),
    zoom: 14,
  );

  getCurrentLocation() async {
    Position userPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.bestForNavigation
    );
    currentPosition = userPosition;

    LatLng userLatLng = LatLng(currentPosition!.latitude, currentPosition!.longitude);

    CameraPosition positionCamera = CameraPosition(target: userLatLng, zoom: 15);
    controllerGoogleMap!.animateCamera(CameraUpdate.newCameraPosition(positionCamera));

    await GoogleMapServices.convertGeoGraphicCoordinatesToAddress(
      currentPosition!,
      context
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: initialCameraPosition,
            onMapCreated: (GoogleMapController mapController)
            {
              controllerGoogleMap = mapController;
          
              googleMapCompleterController.complete(controllerGoogleMap);
          
              getCurrentLocation();
            },
          ),

          Positioned(
            top: 40,
            right: 20,
            left: 20,
            child: AnimatedSize(
              curve: Curves.easeInOut,
              duration: const Duration(milliseconds: 120),
              child: Container(
                height: searchContainerHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(21),
                    topLeft: Radius.circular(21),
                  )
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.add_location_alt_outlined, color: Colors.grey,),
                          const SizedBox(width: 13.0),
                          Expanded(
                            child: Column(
                              children: [
                                Material(
                                  elevation: 4,
                                  borderRadius: BorderRadius.circular(12),
                                  child: TextField(
                                    controller: destinationTextEditingController,
                                    onChanged: (userInput) {
                                        searchPlace(userInput);
                                      },
                                    decoration: InputDecoration(
                                      hintText: 'Search location',
                                      prefixIcon: const Icon(Icons.search),
                                      suffixIcon: (destinationTextEditingController.text.isEmpty)
                                          ? null
                                          : IconButton(
                                              icon: const Icon(Icons.clear),
                                              onPressed: () {
                                                destinationTextEditingController.clear();
                                                setState(() => dropOffPredictionsPlacesList.clear());
                                              },
                                            ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                        borderSide: BorderSide.none,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    ),
                                  ),
                                ),
                                // (dropOffPredictionsPlacesList.length > 0)
                                // ? 

                          //       (dropOffPredictionsPlacesList.length > 0)
                          //         ? Expanded(
                          //           child: Padding(
                          //             padding: const EdgeInsets.symmetric(horizontal: 16),
                          //             child: ListView.separated(
                          //               physics: const AlwaysScrollableScrollPhysics(),
                          //               itemBuilder: (context, index) {
                          //                 print(dropOffPredictionsPlacesList[index].mainText.toString());
                          //                 return ElevatedButton(
                          //                   onPressed: () {}, 
                          //                   style: ElevatedButton.styleFrom(
                          //                     backgroundColor: Colors.white,
                                    
                          //                   ),
                          //                   child: SizedBox(
                          //                     child: Column(
                          //                       children: [
                          //                         const SizedBox(height: 10,),
                          //                         Row(
                          //                           children: [
                          //                             const Icon(Icons.share_location, color: Colors.grey),
                          //                             // const SizedBox(width: 13,),
                          //                             Expanded(
                          //                               child: Column(
                          //                                 mainAxisAlignment: MainAxisAlignment.start,
                          //                                 children: [
                          //                                   Text(
                          //                                     dropOffPredictionsPlacesList[index].mainText.toString(),
                          //                                     overflow: TextOverflow.ellipsis,
                          //                                     style: const TextStyle(
                          //                                       fontSize: 12,
                          //                                       color: Colors.black,
                          //                                     ),
                          //                                   )
                          //                                 ],
                          //                               )
                          //                             ),
                          //                           ],
                          //                         )
                          //                       ],
                          //                     ),
                          //                   )
                          //                 );
                          //               }, 
                          //               separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 8.0), 
                          //               itemCount: dropOffPredictionsPlacesList.length
                          //             ),
                          //           ),
                          //         )
                                  // : Container(),
                              ],
                            )
                          )
                        ],
                      ),
                       
                      // const Divider(height: 1, thickness: 1, color: Colors.grey), 
                    ],
                  ),
                ),
              ),
            )
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 120.0, vertical: 8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {},
                child: const Text(
                  'Select Destination',
                )
              ),
            )
          )
        ],
      )
    );
  }
}



// import 'dart:async';

// import 'package:fcs_flutter/common/widgets/loader.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_connect/http/src/utils/utils.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as loc;
// import 'package:location/location.dart';

// class MapPage extends StatefulWidget {
//   const MapPage({super.key});

//   @override
//   State<MapPage> createState() => _MapPageState();
// }

// class _MapPageState extends State<MapPage> {

//   LatLng? destLocation = LatLng(37.3161, -121.9195);
//   Location location = Location();
//   loc.LocationData? _currentPosition;
//   final Completer<GoogleMapController?> _controller = Completer();
//   String? _address;

//   // Location _locationController = new Location();

//   // final Completer<GoogleMapController> _mapController = Completer<GoogleMapController>();

//   // static const LatLng _pGooglePlex = LatLng(37.7749, -122.4194);
//   // static const LatLng _pApplePark = LatLng(37.3346, -122.0890);
//   // LatLng? _currentP = null;

//   @override
//   void initState() {
//     super.initState();
//     // getLocationUpdates();
//     getCurrentLocation();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             zoomControlsEnabled: false,
//             initialCameraPosition: CameraPosition(target: destLocation!, zoom: 16),
//             onCameraMove: (CameraPosition? position) {
//               if (destLocation != position!.target) {
//                 setState(() {
//                   destLocation = position.target;
//                 });
//               }
//             },
//             onCameraIdle: () {
//               print('camera idle');
//             },
//             onTap: (latLng) {
//               print(latLng);
//             },
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//           ),
//           Align(
//             alignment: Alignment.center,
//             child: Padding(
//               padding: const EdgeInsets.only(bottom: 35.0),
//               child: Icon(
//                 Icons.location_pin
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             right: 20,
//             left: 20,
//             child: Container(
//               decoration: BoxDecoration(
//                 border: Border.all(color: Colors.black),
//                 color: Colors.white
//               ),
//               padding: EdgeInsets.all(20),
//               child: Text(
//                 _address ?? 'Pick your destination address',
//                 overflow: TextOverflow.visible,
//                 softWrap: true,
//               ),
//             ),
//           )
//         ],
//       ),
      // body: _currentP == null ? const Loader()
      //   : GoogleMap(
      //     onMapCreated: ((GoogleMapController controller) => _mapController.complete(controller)),
      //     initialCameraPosition: CameraPosition(
      //       target: _currentP!, 
      //       zoom: 13,
      //     ),
      //     markers: {
      //       Marker(
      //         markerId: MarkerId("_currentLocation"),
      //         icon: BitmapDescriptor.defaultMarker, 
      //         position: _currentP!
      //       ),
            // Marker(
            //   markerId: MarkerId("_sourceLocation"),
            //   icon: BitmapDescriptor.defaultMarker, 
            //   position: _pGooglePlex
            // ),
            // Marker(
            //   markerId: MarkerId("_destinationLocation"),
            //   icon: BitmapDescriptor.defaultMarker, 
            //   position: _pApplePark
            // ),
      //     },
      // ),
  //   );
  // }

  // Future<void> _cameraToPosition(LatLng pos) async {
  //   final GoogleMapController controller = await _mapController.future;
  //   CameraPosition _newCameraPosition = CameraPosition(
  //     target: pos,
  //     zoom: 13,
  //   );

  //   await controller.animateCamera(
  //     CameraUpdate.newCameraPosition(_newCameraPosition),
  //   );
  // }

  // Future<void> getLocationUpdates() async {
  //   bool _serviceEnabled;
  //   PermissionStatus _permissionGranted;

  //   _serviceEnabled = await _locationController.serviceEnabled();
  //   if (_serviceEnabled) {
  //     _serviceEnabled = await _locationController.requestService();
  //   } else {
  //     return;
  //   }

  //   _permissionGranted = await _locationController.hasPermission();
  //   if (_permissionGranted == PermissionStatus.denied) {
  //     _permissionGranted = await _locationController.requestPermission();
  //     if (_permissionGranted != PermissionStatus.granted) {
  //       return ;
  //     }
  //   }

  //   _locationController.onLocationChanged.listen((LocationData currentLocation) {
  //     if (currentLocation.latitude != null && currentLocation.longitude != null) {
  //       setState(() {
  //         _currentP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
  //       });
  //       _cameraToPosition(_currentP!);
  //     }
  //   }); 
  // }

  // getAddressFromLatLng(LatLng latLng) async {
  //   try {
  //     GeoData data = await GeoCoder2.getDataFromCoordinates(
  //       latitude: destLocation!.latitude,
  //       longitude: destLocation!.longitude,
  //       googleMapApiKey: 
  //       se
  //     );
  //   }
  //   setState(() {
  //     _address = "Sample Address"; // Replace with actual address
  //   });
  // }

  
// }