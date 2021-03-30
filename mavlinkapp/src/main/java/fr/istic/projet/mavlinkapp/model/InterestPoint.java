package fr.istic.projet.mavlinkapp.model;

public class InterestPoint {
    PositionDrone posDrone = new PositionDrone();
    boolean photo = false;

    public PositionDrone getPosition() {
        return posDrone;
    }

    public void setPosition(PositionDrone position) {
        this.posDrone = position;
    }

    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
    }
}
