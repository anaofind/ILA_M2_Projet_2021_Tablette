package fr.istic.projet.mavlinkapp.model;

public class CurrentPicture {
    String id;
    double latitude;
    double longitude;
    private Float absoluteAltitudeM;

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }
    public double getLatitude() {
        return latitude;
    }
    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }
    public double getLongitude() {
        return longitude;
    }
    public void setLongitude(double longitude) {
        this.longitude = longitude;
    }

    public void setAltitude(Float absoluteAltitudeM) {
        this.absoluteAltitudeM = absoluteAltitudeM;
    }
    public float getAltitude() {
        return absoluteAltitudeM;
    }
}
