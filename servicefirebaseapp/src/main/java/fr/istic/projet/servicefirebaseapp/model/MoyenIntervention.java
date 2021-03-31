package fr.istic.projet.servicefirebaseapp.model;

import com.google.cloud.Timestamp;


public class MoyenIntervention {
	private Moyen moyen;
	private String id;
	private String etat;
	private Timestamp demandeA;
	private Timestamp departA;
	private Timestamp arriveA;
	private Timestamp retourneA;
	private String  couleur;
	private Position position;
	private String basePath;
	
	public MoyenIntervention() {};
	
	public MoyenIntervention(Moyen moyen, String id, String etat, Timestamp demandeA, Timestamp departA,
			Timestamp arriveA, Timestamp retourneA, String couleur, Position position, String basePath) {
		super();
		this.moyen = moyen;
		this.id = id;
		this.etat = etat;
		this.demandeA = demandeA;
		this.departA = departA;
		this.arriveA = arriveA;
		this.retourneA = retourneA;
		this.couleur = couleur;
		this.position = position;
		this.basePath = basePath;
	}

	public Moyen getMoyen() {
		return moyen;
	}
	public void setMoyen(Moyen moyen) {
		this.moyen = moyen;
	}
	public String getEtat() {
		return etat;
	}
	public void setEtat(String etat) {
		this.etat = etat;
	}
	public Timestamp getDemandeA() {
		return demandeA;
	}
	public void setDemandeA(Timestamp demandeA) {
		this.demandeA = demandeA;
	}
	public Timestamp getDepartA() {
		return departA;
	}
	public void setDepartA(Timestamp departA) {
		this.departA = departA;
	}
	public Timestamp getArriveA() {
		return arriveA;
	}
	public void setArriveA(Timestamp arriveA) {
		this.arriveA = arriveA;
	}
	public Timestamp getRetourneA() {
		return retourneA;
	}
	public void setRetourneA(Timestamp retourneA) {
		this.retourneA = retourneA;
	}
	public String getCouleur() {
		return couleur;
	}
	public void setCouleur(String couleur) {
		this.couleur = couleur;
	}
	public Position getPosition() {
		return position;
	}
	public void setPosition(Position position) {
		this.position = position;
	}
	public String getBasePath() {
		return basePath;
	}
	public void setBasePath(String basePath) {
		this.basePath = basePath;
	}
	public String getId() {
		return id;
	}
}
