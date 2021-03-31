package fr.istic.projet.mavlinkapp.model;

public class StateMission {
    private String idMission;
    private String state;

    public StateMission(String ident, String valEtat) {
        this.idMission = ident;
        this.state = valEtat;
    }
    public String getState() {
        return state;
    }

    public void setState(String etat) {
        this.state = etat;
    }
    public String getIdMission() {
        return idMission;
    }

    public void setIdMission(String id) {
        this.idMission = id;
    }
}
