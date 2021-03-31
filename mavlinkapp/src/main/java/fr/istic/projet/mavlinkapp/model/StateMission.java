package fr.istic.projet.mavlinkapp.model;

public class StateMission {
    private String idMission;
    private String etat;

    public StateMission(String ident, String valEtat) {
        this.idMission = ident;
        this.etat = valEtat;
    }
    public String getEtat() {
        return etat;
    }

    public void setEtat(String etat) {
        this.etat = etat;
    }
    public String getIdMission() {
        return idMission;
    }

    public void setIdMission(String id) {
        this.idMission = id;
    }
}
