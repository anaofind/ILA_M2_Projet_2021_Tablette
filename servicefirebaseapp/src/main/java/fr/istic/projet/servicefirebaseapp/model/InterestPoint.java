package fr.istic.projet.servicefirebaseapp.model;

public class InterestPoint {
    private boolean photo = false;
    private String latitude;
    private String longitude;
    public InterestPoint(boolean photo, String latitude, String longitude) {
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



	public String getLatitude() {
		return latitude;
	}



	public void setLatitude(String latitude) {
		this.latitude = latitude;
	}



	public String getLongitude() {
		return longitude;
	}



	public void setLongitude(String longitude) {
		this.longitude = longitude;
	}
}
