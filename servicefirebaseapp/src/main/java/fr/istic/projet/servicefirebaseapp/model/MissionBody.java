package fr.istic.projet.servicefirebaseapp.model;

public class MissionBody {
	private String id;
	private double latitude;
	private double longitude;
	private byte[] bytes;
	
	
	public MissionBody(String id, double latitude, double longitude, byte[] bytes) {
		super();
		this.id = id;
		this.latitude = latitude;
		this.longitude = longitude;
		this.bytes = bytes;
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
	public byte[] getBytes() {
		return bytes;
	}
	public void setBytes(byte[] bytes) {
		this.bytes = bytes;
	}
}
