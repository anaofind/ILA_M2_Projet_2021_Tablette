package fr.istic.projet.mavlinkapp.model;

import javax.swing.text.Position;

public class InterestPoint {
    Position position;
    boolean photo = false;

    public Position getPosition() {
        return position;
    }

    public void setPosition(Position position) {
        this.position = position;
    }

    public boolean isPhoto() {
        return photo;
    }

    public void setPhoto(boolean photo) {
        this.photo = photo;
    }
}
