package fr.istic.projet.mavlinkapp.model;

public class InterestPoint {
    boolean photo = false;
    double latitude, longitude;

    public double getLatitude() {
        return latitude;
    }

    public void setLatitude(double latitude) {
        this.latitude = latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public void setLongitude(double longititude) {
        this.longitude = longititude;
    }

    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
    }
}
