package fr.istic.projet.servicefirebaseapp.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.google.api.client.util.DateTime;
import com.google.cloud.Timestamp;

public class Mission {
    String id;
    String name;
    List<InterestPoint> interestPoints = new ArrayList<>();
    List<HashMap<String, String>> photos = new ArrayList<HashMap<String, String>>();
    String video;
    boolean segment = true;
    boolean streamVideo = false;
    String state;
    String idIntervention;
    
    public Mission(){};
    
 
    public Mission(String id, String name, List<InterestPoint> interestPoints, List<HashMap<String, String>> photos, 
    		String video, boolean segment, boolean streamVideo, String state, String idIntervention) {
		super();
		this.id = id;
		this.name = name;
		this.interestPoints = interestPoints;
		this.photos = photos;
		this.video = video;
		this.segment = segment;
		this.streamVideo = streamVideo;
		this.state = state;
		this.idIntervention = idIntervention;
	}

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

    public String getIdIntervention() {
		return idIntervention;
	}


	public void setIdIntervention(String idIntervention) {
		this.idIntervention = idIntervention;
	}


	public List<InterestPoint> getInterestPoints() {
        return interestPoints;
    }

    public void setInterestPoints(List<InterestPoint> interestPoints) {
        this.interestPoints = interestPoints;
    }

    public List<HashMap<String, String>> getPhotos() {
        return photos;
    }

    public String getState() {
		return state;
	}


	public void setState(String state) {
		this.state = state;
	}


	public void addPhoto(String photo) {
    	HashMap<String, String> map = new HashMap<>();
    	map.put("url", photo);
        this.photos.add(map);
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

}
