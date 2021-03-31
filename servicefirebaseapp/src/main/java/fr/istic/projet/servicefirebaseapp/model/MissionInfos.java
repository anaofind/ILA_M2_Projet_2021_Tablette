package fr.istic.projet.servicefirebaseapp.model;

public class MissionInfos {
	private String idDocMission; 
	private Mission mission;
	public MissionInfos(String idDocMission, Mission mission) {
		super();
		this.idDocMission = idDocMission;
		this.mission = mission;
	}
	public String getIdDocMission() {
		return idDocMission;
	}
	public void setIdDocMission(String idDocMission) {
		this.idDocMission = idDocMission;
	}
	public Mission getMission() {
		return mission;
	}
	public void setMission(Mission mission) {
		this.mission = mission;
	}

}
