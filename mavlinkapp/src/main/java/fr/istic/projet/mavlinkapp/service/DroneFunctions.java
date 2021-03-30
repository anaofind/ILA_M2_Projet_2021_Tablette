package fr.istic.projet.mavlinkapp.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import fr.istic.projet.mavlinkapp.model.CurrentPosition;
import fr.istic.projet.mavlinkapp.model.InterestPoint;
import fr.istic.projet.mavlinkapp.model.PositionDrone;
import io.mavsdk.System;
import io.mavsdk.mission.Mission;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;

public class DroneFunctions {
    public System drone;
    private CurrentPosition posCourante = new CurrentPosition();
    private static final Logger logger = LoggerFactory.getLogger(DroneFunctions.class);
    public DroneFunctions(){
        drone = new System();
    }

    public void go(List<InterestPoint> ListPosition) {
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
        drone.getTelemetry().setRatePosition(1000.0);
        ObjectMapper mapper = new ObjectMapper();

        drone.getTelemetry().getPosition().subscribe(
                position -> {
                    posCourante.setId("idIntervention");
                    posCourante.setLatitude(position.getLatitudeDeg());
                    posCourante.setLongitude(position.getLongitudeDeg());
                    String jsonRes = "";
                    try {
                        jsonRes = mapper.writeValueAsString(posCourante);
                    } catch (JsonProcessingException e) {
                        e.printStackTrace();
                    }
                    URL url = new URL("http://148.60.11.47:8080/api/updateDronePosition");
                    HttpURLConnection con = (HttpURLConnection)url.openConnection();
                    con.setRequestMethod("POST");
                    con.setRequestProperty("Content-Type", "application/json; utf-8");
                    con.setDoOutput(true);
                    try(OutputStream os = con.getOutputStream()) {
                        byte[] input = jsonRes.getBytes("utf-8");
                        os.write(input, 0, input.length);
                    }
                }
        );

        /*
        updateDronePosition chaque 1sec sur localhost:8080
        uploadFile
                drone.getMission().getMissionProgress()
                .subscribe(onNext -> publishImages(drone, missionmessage, missionItems.get(onNext.getCurrent())));
        */


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