package fr.istic.projet.servicefirebaseapp.model;

public class Position{
    private double latitude;
    private double longitude;

    public Position() {
	}
    
    public Position(double latitude, double longitude) {
		super();
		this.latitude = latitude;
		this.longitude = longitude;
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

    public void setLongitude(double longititude) {
        this.longitude = longititude;
    }
}
