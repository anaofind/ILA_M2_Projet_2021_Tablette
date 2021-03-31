package fr.istic.projet.mavlinkapp.model;

public class CurrentPicture {
    CurrentPosition currentPosition;
    byte[] currentPicture;

    public CurrentPicture(CurrentPosition currentPosition, byte[] currentPicture) {
        this.currentPosition = currentPosition;
        this.currentPicture = currentPicture;
    }

    public CurrentPosition getCurrentPosition() {
        return currentPosition;
    }

    public void setCurrentPosition(CurrentPosition currentPosition) {
        this.currentPosition = currentPosition;
    }

    public byte[] getCurrentPicture() {
        return currentPicture;
    }

    public void setCurrentPicture(byte[] currentPicture) {
        this.currentPicture = currentPicture;
    }
}
