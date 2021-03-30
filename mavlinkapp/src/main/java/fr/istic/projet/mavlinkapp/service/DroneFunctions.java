package fr.istic.projet.mavlinkapp.service;

import fr.istic.projet.mavlinkapp.model.InterestPoint;
import fr.istic.projet.mavlinkapp.model.PositionDrone;
import io.mavsdk.System;
import io.mavsdk.mission.Mission;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public class DroneFunctions {
    public System drone;
    private static final Logger logger = LoggerFactory.getLogger(DroneFunctions.class);
    public DroneFunctions(){
        drone = new System();
    }

    public void go(List<InterestPoint> ListPosition) throws InterruptedException {
        List<Mission.MissionItem> missionItems = new ArrayList<>();
        for (InterestPoint pos:
                ListPosition) {
            missionItems.add(generateMissionItem(pos.getPosition().getLatitude(),pos.getPosition().getLongitude()));
        }
        Mission.MissionPlan missionPlan = new Mission.MissionPlan(missionItems);

        drone.getMission().setReturnToLaunchAfterMission(true)
                .andThen(drone.getMission().uploadMission(missionPlan)
                        .doOnComplete(() -> logger.debug("Upload succeeded")))
                .andThen(drone.getAction().arm())
                .andThen(drone.getMission().startMission().doOnComplete(() -> logger.debug("Mission started")))
                .subscribe();

        drone.getTelemetry().getPosition().subscribe(
                position -> java.lang.System.out.println(position.getLongitudeDeg() + " " +position.getLatitudeDeg()));
        /*drone.getMission().getMissionProgress()
                .subscribe(onNext -> publishImages(drone, missionmessage, missionItems.get(onNext.getCurrent())));
        */
        //https://istic-vpn.univ-rennes1.fr/sslvpn/portal.html#/


        CountDownLatch latch = new CountDownLatch(1);
        drone.getMission()
                .getMissionProgress()
                .filter(progress -> progress.getCurrent() == progress.getTotal())
                .take(1)
                .subscribe(ignored -> latch.countDown());
        try {
            latch.await();
        } catch (InterruptedException ignored) {
            // This is expected

        }
    }
    public static Mission.MissionItem generateMissionItem(double latitudeDeg, double longitudeDeg) {
        return new Mission.MissionItem(latitudeDeg, longitudeDeg, 10f, 10f, true, Float.NaN, Float.NaN,
                Mission.MissionItem.CameraAction.NONE, Float.NaN, 1.0);
    }

    public void Cancel(){
        drone.getMission().cancelMissionDownload();
        drone.getMission().cancelMissionUpload();
        drone.getMission().clearMission();
    }
}