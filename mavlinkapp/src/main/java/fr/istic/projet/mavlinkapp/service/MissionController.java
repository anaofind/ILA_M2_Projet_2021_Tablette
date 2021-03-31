package fr.istic.projet.mavlinkapp.service;

import fr.istic.projet.mavlinkapp.model.MissionDrone;
import fr.istic.projet.mavlinkapp.model.StateMission;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import io.mavsdk.System;
import io.mavsdk.mission.Mission.MissionItem;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

@RestController
@RequestMapping("/api/mission")
public class MissionController {
    private final Logger logger = LoggerFactory.getLogger(MissionController.class);
    DroneFunctions drone = new DroneFunctions();

    MissionDrone laMission = new MissionDrone();
    ExecutorService service = Executors.newFixedThreadPool(1);

    @PostMapping
    public MissionDrone sendMissionCoordonates(@Validated @RequestBody MissionDrone mission) {
        laMission = mission;

        java.lang.System.out.println(laMission.getId());
        java.lang.System.out.println(laMission.getIdIntervention());
        java.lang.System.out.println(laMission.getInterestPoints().get(0).getLatitude());
        java.lang.System.out.println(laMission.getInterestPoints().get(0).getLongitude());
        java.lang.System.out.println(laMission.getInterestPoints().get(1).getLatitude());
        java.lang.System.out.println(laMission.getInterestPoints().get(1).getLongitude());
        java.lang.System.out.println(laMission.getInterestPoints().get(2).getLatitude());
        java.lang.System.out.println(laMission.getInterestPoints().get(2).getLongitude());

        MyRunnable myRunnable = new MyRunnable(drone);
        service.submit(myRunnable);

        //Thread.sleep(500);

        //send images took by drone in rest's meth to app java which will store image in firebase*/
        return laMission;
    }

    public class MyRunnable implements Runnable {

        private DroneFunctions drone;

        public MyRunnable(DroneFunctions drone) {
            this.drone = drone;
        }

        public void run() {
            // code in the other thread, can reference "var" variable

          try {
                StateMission debut = new StateMission(laMission.getId(), "StateMission.Running");
                if(drone.sendEtatToWebservice(debut, "http://148.60.11.47:8080/api/updateMissionState")) {
                    Thread.sleep(500);
                    drone.go(laMission.getIdIntervention(), laMission.getId(), laMission.getInterestPoints());
                    StateMission fin = new StateMission(laMission.getId(), "StateMission.Ending");
                    if(drone.sendEtatToWebservice(fin, "http://148.60.11.47:8080/api/updateMissionState")) {
                        java.lang.System.out.println("Mission finished");
                    }
                } else {
                    java.lang.System.out.println("Error");
                }
                 } catch (InterruptedException e) {
                e.printStackTrace();
            }


        }


    }


    public static void publishImages(System drone, MissionDrone mission, MissionItem missionItem) {
        //right code to take photo here
        BufferedImage image = null;
        try {
            image = ImageIO.read(new File("res/chat.jpg"));
        } catch (IOException e) {
        }
        mission.addPhoto("path/to/img/");
        mission.getInterestPoints().get(mission.getPhotos().size()-1).setPhoto(true);
    }
}