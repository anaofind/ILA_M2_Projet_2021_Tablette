
class Position {
  double latitude;
  double longitude;

  Position(this.latitude, this.longitude);


  @override
  String toString() {
    return '( ${latitude.toStringAsFixed(6)} , ${longitude.toStringAsFixed(6)} )';
  }

}
