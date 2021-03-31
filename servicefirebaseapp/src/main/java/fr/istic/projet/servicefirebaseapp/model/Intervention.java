package fr.istic.projet.servicefirebaseapp.model;

import java.util.List;

import com.google.cloud.Timestamp;

public class Intervention {
	private String id;
	private String nom;
	private String adresse;
	private String codeSinistre;
	private Timestamp date;
	private List<MoyenIntervention> moyens;
	private List<SymbolIntervention> symbols;
	private List<String> missions;
	private Mission futureMission = new Mission();
	private double latitudeDrone;
	private double longitudeDrone;
	
	public Intervention() {};
	
	public Intervention(String id, String nom, String adresse, String codeSinistre, Timestamp date,
			List<MoyenIntervention> moyens, List<SymbolIntervention> symbols, List<String> missions,
			Mission futureMission, double latitudeDrone, double longitudeDrone) {
		super();
		this.id = id;
		this.nom = nom;
		this.adresse = adresse;
		this.codeSinistre = codeSinistre;
		this.date = date;
		this.moyens = moyens;
		this.symbols = symbols;
		this.missions = missions;
		this.futureMission = futureMission;
		this.latitudeDrone = latitudeDrone;
		this.longitudeDrone = longitudeDrone;
	}

	public String getNom() {
		return nom;
	}
	public void setNom(String nom) {
		this.nom = nom;
	}
	public String getAdresse() {
		return adresse;
	}
	public void setAdresse(String adresse) {
		this.adresse = adresse;
	}
	public String getCodeSinistre() {
		return codeSinistre;
	}
	public void setCodeSinistre(String codeSinistre) {
		this.codeSinistre = codeSinistre;
	}
	public Timestamp getDate() {
		return date;
	}
	public void setDate(Timestamp date) {
		this.date = date;
	}
	public List<MoyenIntervention> getMoyens() {
		return moyens;
	}
	public void setMoyens(List<MoyenIntervention> moyens) {
		this.moyens = moyens;
	}
	public List<SymbolIntervention> getSymbols() {
		return symbols;
	}
	public void setSymbols(List<SymbolIntervention> symbols) {
		this.symbols = symbols;
	}
	public List<String> getMissions() {
		return missions;
	}
	public void setMissions(List<String> missions) {
		this.missions = missions;
	}
	public double getLatitudeDrone() {
		return latitudeDrone;
	}

	public void setLatitudeDrone(double latitudeDrone) {
		this.latitudeDrone = latitudeDrone;
	}

	public double getLongitudeDrone() {
		return longitudeDrone;
	}

	public void setLongitudeDrone(double longitudeDrone) {
		this.longitudeDrone = longitudeDrone;
	}

	public Mission getFutureMission() {
		return futureMission;
	}
	public void setFutureMission(Mission futureMission) {
		this.futureMission = futureMission;
	}
	
	public String getId() {
		return id;
	}
}
