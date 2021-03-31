package fr.istic.projet.mavlinkapp.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import fr.istic.projet.mavlinkapp.model.CurrentPosition;
import fr.istic.projet.mavlinkapp.model.InterestPoint;
import io.mavsdk.System;
import io.mavsdk.mission.Mission;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
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

    public void go(String idIntervention, List<InterestPoint> ListPosition) {
        List<Mission.MissionItem> missionItems = new ArrayList<>();
        for (InterestPoint pos:
                ListPosition) {
            missionItems.add(generateMissionItem(pos.getLatitude(),pos.getLongitude()));
        }
        Mission.MissionPlan missionPlan = new Mission.MissionPlan(missionItems);

        drone.getMission().setReturnToLaunchAfterMission(true)
                .andThen(drone.getMission().uploadMission(missionPlan)
                        .doOnComplete(() -> logger.debug("Upload succeeded")))
                .andThen(drone.getAction().arm())
                .andThen(drone.getMission().startMission().doOnComplete(() -> logger.debug("Mission started")))
                .subscribe();
        drone.getTelemetry().setRatePosition(1000.0);
        drone.getTelemetry().getPosition().subscribe(
                position -> {
                    java.lang.System.out.println(position.getLatitudeDeg() + "---" + position.getLongitudeDeg());
                    posCourante.setId(idIntervention);
                    posCourante.setLatitude(position.getLatitudeDeg());
                    posCourante.setLongitude(position.getLongitudeDeg());
                    String jsonRes = "";
                    HttpClient client = new DefaultHttpClient();
                    HttpPost post = new HttpPost("http://localhost:8080/api/updateDronePosition");
                    ObjectMapper mapper = new ObjectMapper();
                    try {
                        jsonRes = mapper.writeValueAsString(posCourante);
                        StringEntity se = new StringEntity(jsonRes);
                        se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
                        post.setEntity(se);
                        client.execute(post);
                    } catch (IOException e) {
                        e.printStackTrace();
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