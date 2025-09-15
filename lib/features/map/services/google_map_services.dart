import 'dart:convert';

import 'package:fcs_flutter/models/addressModel.dart';
import 'package:fcs_flutter/providers/address_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class GoogleMapServices 
{
  static sendRequestToApi(String apiUrl) async {
    http.Response responseFromAPI = await http.get(Uri.parse(apiUrl));

    try 
    {
      if (responseFromAPI.statusCode == 200) {
        String dataFromApi = responseFromAPI.body;
        var dataDecoded = jsonDecode(dataFromApi);
        return dataDecoded;
      } else {
        return "error";
      } 
    }
    catch (errorMessage) {
      print("\n\nError occurred::\n$errorMessage\n\n");
      return "error";
    }
  }

  static autoCompleteApi(String input) async {
    const apiKey = 'AIzaSyAu6kHkvkqn6gL-2XSS4_m--TpQbP3ZDTM';
    const url = 'https://places.googleapis.com/v1/places:autocomplete';

    final body = jsonEncode({
      "input": input,
      "regionCode": "MY",
    });

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
      },
      body: body,
    );

    print(response);

    if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data;
  } else {
    throw Exception('Failed to load autocomplete suggestions');
  }
  }


  static Future<String> convertGeoGraphicCoordinatesToAddress(
      Position position,
      BuildContext context
  ) async {
    String humanReadableAddress = '';
    String geoCodingApiUrl = 'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=AIzaSyAu6kHkvkqn6gL-2XSS4_m--TpQbP3ZDTM';

    var responseFromAPI = await sendRequestToApi(geoCodingApiUrl);

    print(responseFromAPI);

    if (responseFromAPI != "error") {
      humanReadableAddress = responseFromAPI["results"][0]["formatted_address"];

      print("humanReadableAddress = " + humanReadableAddress);

      Addressmodel addressmodel = Addressmodel();
      addressmodel.humanReadableAddress = humanReadableAddress;
      addressmodel.placeName = humanReadableAddress;
      addressmodel.placeId = responseFromAPI["results"][0]["place_id"];
      addressmodel.latitudePosition = position.latitude;
      addressmodel.longitudePosition = position.longitude;

      Provider.of<AddressProvider>(context, listen: false)
          .updateCurrentLocation(addressmodel);
    }
    return humanReadableAddress;
  }
}