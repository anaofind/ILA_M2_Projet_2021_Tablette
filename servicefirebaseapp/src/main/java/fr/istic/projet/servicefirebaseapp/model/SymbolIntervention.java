package fr.istic.projet.servicefirebaseapp.model;

public class SymbolIntervention {
	  private String id;
	  private String nomSymbol;
	  private String couleur;
	  private String etat;
	  private Position position;
	  private String basePath;
	  
	  public SymbolIntervention() {};
	  
	public SymbolIntervention(String id, String nomSymbol, String couleur, String etat, Position position,
			String basePath) {
		super();
		this.id = id;
		this.nomSymbol = nomSymbol;
		this.couleur = couleur;
		this.etat = etat;
		this.position = position;
		this.basePath = basePath;
	}
	public String getNomSymbol() {
		return nomSymbol;
	}
	public void setNomSymbol(String nomSymbol) {
		this.nomSymbol = nomSymbol;
	}
	public String getCouleur() {
		return couleur;
	}
	public void setCouleur(String couleur) {
		this.couleur = couleur;
	}
	public String getEtat() {
		return etat;
	}
	public void setEtat(String etat) {
		this.etat = etat;
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
