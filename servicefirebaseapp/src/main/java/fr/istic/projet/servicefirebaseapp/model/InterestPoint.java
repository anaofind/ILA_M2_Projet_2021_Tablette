package fr.istic.projet.servicefirebaseapp.model;

public class InterestPoint {
    private Position position;
    private boolean photo = false;

    public InterestPoint() {
    }
    
    public InterestPoint(Position position, boolean photo) {
		super();
		this.position = position;
		this.photo = photo;
	}

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
