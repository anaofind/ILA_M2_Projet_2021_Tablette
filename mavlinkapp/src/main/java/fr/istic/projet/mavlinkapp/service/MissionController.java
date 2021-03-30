package fr.istic.projet.mavlinkapp.service;

import fr.istic.projet.mavlinkapp.model.InterestPoint;
import fr.istic.projet.mavlinkapp.model.MissionDrone;
import fr.istic.projet.mavlinkapp.model.PositionDrone;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import io.mavsdk.System;
import io.mavsdk.mission.Mission;
import io.mavsdk.mission.Mission.MissionItem;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api/mission")
public class MissionController {
    private final Logger logger = LoggerFactory.getLogger(MissionController.class);
    List<PositionDrone> points = new ArrayList<PositionDrone>();
    DroneFunctions drone = new DroneFunctions();

    MissionDrone laMission = new MissionDrone();
    @PostMapping
    public MissionDrone sendMissionCoordonates(@Validated @RequestBody MissionDrone mission) throws InterruptedException {
        laMission = mission;
        //launch drone to explore mission's intersts point
       /* for (InterestPoint ip:
             laMission.getInterestPoints()) {
            java.lang.System.out.println(ip.getPosition().getLatitude() + " - " + ip.getPosition().getLongitude()+" !!!!!");
        }*/
        MyRunnable myRunnable = new MyRunnable(drone);
        Thread t = new Thread(myRunnable);
        t.start();
        Thread.sleep(500);

        //send images took by drone in rest's meth to app java which will store image in firebase
        return laMission;
    }

    @GetMapping
    public List<Mission> findAllMission() {
        return new ArrayList<>();
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
    public class MyRunnable implements Runnable {

        private DroneFunctions drone;

        public MyRunnable(DroneFunctions drone) {
            this.drone = drone;
        }

        public void run() {
            // code in the other thread, can reference "var" variable
            try {
                drone.go(laMission.getInterestPoints());
                Thread.sleep(500);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }


    }
}
