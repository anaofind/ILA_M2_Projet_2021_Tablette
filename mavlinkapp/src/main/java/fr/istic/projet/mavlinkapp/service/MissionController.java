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
    private System drone = new System();
    MissionDrone laMission = new MissionDrone();
    @PostMapping
    public MissionDrone sendMissionCoordonates(@Validated @RequestBody MissionDrone mission) {
        laMission = mission;
        //launch drone to explore mission's intersts point
        this.missionGo(mission.getInterestPoints());
        //send images took by drone in rest's meth to app java which will store image in firebase
        return mission;
    }

    @GetMapping
    public List<Mission> findAllMission() {
        return new ArrayList<>();
    }

    private void missionGo(List<InterestPoint> mission) {

        List<Mission.MissionItem> missionItems = new ArrayList<>();
        for (InterestPoint val : mission) {
            missionItems.add(generateMissionItem(((PositionDrone) val.getPosition()).getLatitude(), ((PositionDrone) val.getPosition()).getLongitude()));
        }
        Mission.MissionPlan missionPlan = new Mission.MissionPlan(missionItems);

        drone.getMission().getMissionProgress()
                .subscribe(onNext -> publishImages(drone, laMission, missionItems.get(onNext.getCurrent())));

        drone.getMission().setReturnToLaunchAfterMission(true)
                .andThen(drone.getMission().uploadMission(missionPlan)
                        .doOnComplete(() -> logger.debug("Upload succeeded")))
                .andThen(drone.getAction().arm())
                .andThen(drone.getMission().startMission().doOnComplete(() -> logger.debug("Mission started")))
                .subscribe();

    }

    public static Mission.MissionItem generateMissionItem(double latitudeDeg, double longitudeDeg) {
        return new Mission.MissionItem(latitudeDeg, longitudeDeg, 10f, 10f, true, Float.NaN, Float.NaN,
                Mission.MissionItem.CameraAction.NONE, Float.NaN, 1.0);
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
