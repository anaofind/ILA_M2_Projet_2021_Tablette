package fr.istic.projet.servicefirebaseapp.model;

public class Moyen {
	  private String codeMoyen;
	  private String description;
	  private String couleurDefaut;
	  
	public Moyen()	{};
	public Moyen(String codeMoyen, String description, String couleurDefaut) {
		super();
		
		this.codeMoyen = codeMoyen;
		this.description = description;
		this.couleurDefaut = couleurDefaut;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCouleurDefaut() {
		return couleurDefaut;
	}
	public void setCouleurDefaut(String couleurDefaut) {
		this.couleurDefaut = couleurDefaut;
	}
	
}
