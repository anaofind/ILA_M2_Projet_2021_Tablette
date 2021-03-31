package fr.istic.projet.servicefirebaseapp.model;

public class StateMission {
	private String idMission;
	private String state;
	
	public StateMission() {};
	
	public StateMission(String idMission, String state) {
		super();
		this.idMission = idMission;
		this.state = state;
	}
	public String getState() {
		return state;
	}
	public void setState(String state) {
		this.state = state;
	}
	public String getIdMission() {
		return idMission;
	}

}