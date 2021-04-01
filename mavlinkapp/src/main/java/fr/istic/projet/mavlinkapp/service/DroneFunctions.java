package fr.istic.projet.mavlinkapp.service;

import com.fasterxml.jackson.databind.ObjectMapper;
import fr.istic.projet.mavlinkapp.model.CurrentPicture;
import fr.istic.projet.mavlinkapp.model.CurrentPosition;
import fr.istic.projet.mavlinkapp.model.InterestPoint;
import fr.istic.projet.mavlinkapp.model.StateMission;
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
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicInteger;

public class DroneFunctions {
    public System drone;
    private int i = 1;
    private static final Logger logger = LoggerFactory.getLogger(DroneFunctions.class);
    public DroneFunctions(){
        drone = new System();
    }

    public void go(String idIntervention, String idMission,List<InterestPoint> ListPosition) {
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

        int[] cmp = {0};
        drone.getTelemetry().getPosition().subscribe(
                position -> {
                    if (cmp[0] == 150) {
                        java.lang.System.out.println(position.getLatitudeDeg() + "---" + position.getLongitudeDeg());
                        cmp[0] = 0;
                        CurrentPosition posCourante = new CurrentPosition();
                        posCourante.setId(idIntervention);
                        posCourante.setLatitude(position.getLatitudeDeg());
                        posCourante.setLongitude(position.getLongitudeDeg());
                        if(sendPostitionToWebservice(posCourante, "http://148.60.11.47:8080/api/updateDronePosition")) {
                            java.lang.System.out.println("envoi position courante : ok");
                           // sendVid(idMission,posCourante.getLatitude(),posCourante.getLongitude());
                        } else {
                            java.lang.System.out.println("echec envoi position courante");
                        }
                    } else {
                        cmp[0]++;
                    }
                }
        );

        /*
                updateDronePosition chaque 1sec sur localhost:8080
                uploadFile
        */
       /* drone.getMission()
                .getMissionProgress().subscribe(
                        onNext -> sendPic();
        );*/

        CountDownLatch latch = new CountDownLatch(1);
        drone.getMission()
                .getMissionProgress()
                .filter(progress -> progress.getCurrent() == progress.getTotal())
                .take(1)
                .subscribe(ignored ->
                {
                    drone.getAction().disarm();
                    latch.countDown();
                });
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

    public boolean sendPostitionToWebservice(CurrentPosition toSend, String urlWS) {
        String jsonRes = "";
        HttpClient client = new DefaultHttpClient();
        HttpPost post = new HttpPost(urlWS);
        ObjectMapper mapper = new ObjectMapper();
        try {
            jsonRes = mapper.writeValueAsString(toSend);
            java.lang.System.out.println("---jsonPosition : " + jsonRes);
            StringEntity se = new StringEntity(jsonRes);
            se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
            post.setEntity(se);
            client.execute(post);
            return  true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return  false;
    }

    public boolean sendEtatToWebservice(StateMission toSend, String urlWS) {
        String jsonRes = "";
        HttpClient client = new DefaultHttpClient();
        HttpPost post = new HttpPost(urlWS);
        ObjectMapper mapper = new ObjectMapper();
        try {
            jsonRes = mapper.writeValueAsString(toSend);
            StringEntity se = new StringEntity(jsonRes);
            java.lang.System.out.println("---jsonEtat : " + jsonRes);
            se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
            post.setEntity(se);
            client.execute(post);
            return  true;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return  false;
    }
    //---------Pictures---------

    public boolean sendPic(String idMission, double latitude, double longitude) throws IOException, InterruptedException {
        byte[] bb = Files.readAllBytes(Paths.get("./pic"+i+".png"));
        if(i==3){
            i=1;
        }else{
            i++;
        }
        CurrentPicture cpp = new CurrentPicture();
        cpp.setId(idMission);
        cpp.setLatitude(latitude);
        cpp.setLongitude(longitude);
        cpp.setBytes(bb);
        return sendPicorStreamToWebservice(cpp,"http://148.60.11.47:8080/api/uploadFile");
    }

    private boolean sendPicorStreamToWebservice(CurrentPicture toSend, String urlWS) {
            String jsonRes = "";
            HttpClient client = new DefaultHttpClient();
            HttpPost post = new HttpPost(urlWS);
            ObjectMapper mapper = new ObjectMapper();
            try {
                jsonRes = mapper.writeValueAsString(toSend);
                StringEntity se = new StringEntity(jsonRes);
                //java.lang.System.out.println("---jsonEtat : " + jsonRes);
                se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
                post.setEntity(se);
                client.execute(post);
                return  true;
            } catch (IOException e) {
                e.printStackTrace();
            }
            return  false;
        }

    public boolean sendVid(String idMission, double latitude, double longitude) throws IOException, InterruptedException {
        byte[] bb = Files.readAllBytes(Paths.get("./pic"+i+".png"));
        if(i==3){
            i=1;
        }else{
            i++;
        }
        CurrentPicture cpp = new CurrentPicture();
        cpp.setId(idMission);
        cpp.setLatitude(latitude);
        cpp.setLongitude(longitude);
        cpp.setBytes(bb);
        return sendPicorStreamToWebservice(cpp,"http://148.60.11.47:8080/api/streamVideo");
    }

}
