package fr.istic.projet.servicefirebaseapp.model;

public class InterestPoint {
	private String latitude;
	private String longitude;
    public InterestPoint(String latitude, String longitude, boolean photo) {
		super();
		this.latitude = latitude;
		this.longitude = longitude;
		this.photo = photo;
	}

	private boolean photo = false;

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

	public InterestPoint() {
    }
    

    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
    }
}
