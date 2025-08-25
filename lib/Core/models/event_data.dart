
class EventData {
  static const String collectionName = 'events';
  String? id;
  final String enentTitle;
  final String eventDescription;
  final DateTime eventDate;
  final String eventTime;
  final String categoricalImg;
  final String categoricalImgID;
   bool isFavorite;
  String location = '';
   double latitude;
   double longitude;

  EventData({
    this.id,
    required this.enentTitle,
    required this.eventDescription,
    required this.eventDate,
    required this.eventTime,
    required this.categoricalImg,
    required this.categoricalImgID,
    this.latitude =0.0,
    this.longitude = 0.0,
    this.isFavorite = false,
    this.location = '',
  });

  factory EventData.formFirestore(Map<String, dynamic> data) {
    return EventData(
      id: data['id'] as String?,
      enentTitle: data['enentTitle'] as String? ?? '',
      eventDescription: data['eventDescription'] as String? ?? '',
      eventDate:  DateTime.fromMillisecondsSinceEpoch(data['eventDate'] as int? ?? 0),   
      eventTime: data['eventTime'] as String? ?? '',
      categoricalImg: data['categoricalImg'] as String? ?? '',
      categoricalImgID: data['categoricalImgID'] as String? ?? '',
      isFavorite: data['isFavorite'] as bool? ?? false,
      location: data['location'] as String? ?? '',
      latitude: (data['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (data['longitude'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'enentTitle': enentTitle,
      'eventDescription': eventDescription,
      'eventDate': eventDate.millisecondsSinceEpoch,
      'eventTime': eventTime,
      'categoricalImg': categoricalImg,
      'categoricalImgID': categoricalImgID,
      'isFavorite': isFavorite,
      'location': location,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}