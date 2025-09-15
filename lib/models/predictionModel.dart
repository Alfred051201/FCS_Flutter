class Predictionmodel {
  String? placeId;
  String? mainText;
  String? secondaryText;

  Predictionmodel({
    this.placeId,
    this.mainText,
    this.secondaryText
  });

  

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'place_id': placeId,
      'main_text': mainText,
      'secondary_text': secondaryText,
    };
  }

  Predictionmodel.fromJson(Map<String, dynamic> json) {
   placeId = json["place_id"];
   mainText = json["structuredFormat"]["mainText"];
   secondaryText = json["structuredFormat"]["secondaryText"]; 
  }

  Predictionmodel.fromPredictJson(Map<String, dynamic> json) {
   placeId = json["place_id"];
   mainText = json["structuredFormat"]["mainText"]["text"];
   secondaryText = json["structuredFormat"]["secondaryText"]["text"]; 
  }
}
