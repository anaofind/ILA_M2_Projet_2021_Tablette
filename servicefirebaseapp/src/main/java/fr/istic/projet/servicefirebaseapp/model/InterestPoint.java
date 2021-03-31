package fr.istic.projet.servicefirebaseapp.model;

public class InterestPoint {
    private boolean photo = false;
    private double latitude;
    private double longitude;
    public InterestPoint(boolean photo, double latitude, double longitude) {
		super();
		this.photo = photo;
		this.latitude = latitude;
		this.longitude = longitude;
	}



	public InterestPoint() {
    }
    


    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
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
}
