package fr.istic.projet.servicefirebaseapp.model;

public class DroneInfosBody {
	private String id;
	private double latitude;
	private double longitude;

	
	
	public DroneInfosBody(String id, double latitude, double longitude) {
		super();
		this.id = id;
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
	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
	public String getId() {
		return id;
	}
}
