package fr.istic.projet.servicefirebaseapp.service;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import fr.istic.projet.servicefirebaseapp.model.DroneInfosBody;
import fr.istic.projet.servicefirebaseapp.model.FileDTO;
import fr.istic.projet.servicefirebaseapp.model.MissionBody;
import fr.istic.projet.servicefirebaseapp.model.StateMission;

import javax.servlet.http.HttpServletRequest;

@RestController
@RequestMapping("/api")
public class FirebaseController {

    private final Logger log = LoggerFactory.getLogger(FirebaseController.class);
    private FirebaseService firebaseService;

    public FirebaseController(FirebaseService firebaseService) {
        this.firebaseService = firebaseService;
    }
    
    @PostMapping("/uploadFile")
	  public ResponseEntity<FileDTO> uploadFile(@Validated @RequestBody MissionBody missionInfos) throws Exception {
	  log.info("REST request to upload file image");
      //upload file
	  
      FileDTO fileDTO = firebaseService.uploadFileFromBytes(missionInfos.getId(), 
    		  missionInfos.getLatitude(), missionInfos.getLongitude(), missionInfos.getBytes(), "images");
      return new ResponseEntity<>(fileDTO, null, HttpStatus.OK);
  }
    
    @PostMapping("/streamVideo")
	  public ResponseEntity<FileDTO> streamVideo(@Validated @RequestBody MissionBody missionInfos) throws Exception {
	  log.info("REST request to upload file video");
    //upload file
	 
    FileDTO fileDTO = firebaseService.uploadFileFromBytes(missionInfos.getId(), 
  		  missionInfos.getLatitude(), missionInfos.getLongitude(), missionInfos.getBytes(), "videos");
    return new ResponseEntity<>(fileDTO, null, HttpStatus.OK);
}
    
    @PostMapping("/updateDronePosition")
	  public ResponseEntity<DroneInfosBody> updateDronePositionIntervention(@Validated @RequestBody DroneInfosBody droneInfos) throws Exception {
	  log.info("REST request to update drone position");
     firebaseService.updateDronePositionIntervention(droneInfos.getId(), 
    		droneInfos.getLatitude(), droneInfos.getLongitude());
    return new ResponseEntity<>(droneInfos, null, HttpStatus.OK);
}
    
    @PostMapping("/updateMissionState")
	  public ResponseEntity<StateMission> updateMissionState(@Validated @RequestBody StateMission missionState) throws Exception {
	  log.info("REST request to update mission state");
   firebaseService.setMissionState(missionState.getIdMission(), missionState.getState());
  return new ResponseEntity<>(missionState, null, HttpStatus.OK);
}

}