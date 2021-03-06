package fr.istic.projet.mavlinkapp.model;

import java.util.ArrayList;
import java.util.List;

public class MissionDrone {
    String id;
    String idIntervention;
    String name;
    List<InterestPoint> interestPoints = new ArrayList<>();
    List<String> photos = new ArrayList<>();
    String video;
    boolean segment = true;
    boolean streamVideo = false;
    String state;

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public List<InterestPoint> getInterestPoints() {
        return interestPoints;
    }

    public void setInterestPoints(List<InterestPoint> interestPoints) {
        this.interestPoints = interestPoints;
    }

    public List<String> getPhotos() {
        return photos;
    }

    public void addPhoto(String photo) {
        this.photos.add(photo);
    }

    public String getVideo() {
        return video;
    }

    public void setVideo(String video) {
        this.video = video;
    }

    public boolean isSegment() {
        return segment;
    }

    public void setSegment(boolean segment) {
        this.segment = segment;
    }

    public boolean isStreamVideo() {
        return streamVideo;
    }

    public void setStreamVideo(boolean streamVideo) {
        this.streamVideo = streamVideo;
    }

    public String getIdIntervention() {
        return idIntervention;
    }

    public void setIdIntervention(String idIntervention) {
        this.idIntervention = idIntervention;
    }

    public void setPhotos(List<String> photos) {
        this.photos = photos;
    }

    public String getState() {
        return state;
    }

    public void setState(String state) {
        this.state = state;
    }
}
