package fr.istic.projet.mavlinkapp.model;

public class InterestPoint {
    PositionDrone position;
    boolean photo = false;

    public PositionDrone getPosition() {
        return position;
    }

    public void setPosition(PositionDrone position) {
        this.position = position;
    }

    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
    }
}
