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
import java.io.UnsupportedEncodingException;
import java.net.*;
import java.time.Instant;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.atomic.AtomicLong;

public class DroneFunctions {
    public System drone;
    private static final Logger logger = LoggerFactory.getLogger(DroneFunctions.class);
    private static long epochPicture = Instant.now().getEpochSecond();

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


        AtomicLong currT = new AtomicLong(Instant.now().getEpochSecond());
        drone.getTelemetry().getPosition().subscribe(
                position -> {
                    currT.set(Instant.now().getEpochSecond());
                    if (((currT.get() - epochPicture))>=1) {
                        epochPicture = currT.get();

                        java.lang.System.out.println(position.getLatitudeDeg() + "---" + position.getLongitudeDeg());
                        CurrentPosition posCourante = new CurrentPosition();
                        posCourante.setId(idIntervention);
                        posCourante.setLatitude(position.getLatitudeDeg());
                        posCourante.setLongitude(position.getLongitudeDeg());
                        if(sendPostitionToWebservice(posCourante, "http://148.60.11.47:8080/api/updateDronePosition")) {
                            java.lang.System.out.println("envoi position courante : ok");
                            CurrentPicture cpic = new CurrentPicture();
                            cpic.setId(idMission);
                            cpic.setLatitude(position.getLatitudeDeg());
                            cpic.setLongitude(position.getLongitudeDeg());
                            cpic.setAltitude(position.getAbsoluteAltitudeM());
                            if(sendPostitionPicToWebservice(cpic,"http://86.229.200.137:8888/")){
                                java.lang.System.out.println("envoi Picture : ok");
                            }
                        } else {
                            java.lang.System.out.println("echec envoi Picture : nok");
                        }
                    } else {
                        java.lang.System.out.println("AHAHAHAH"+ epochPicture+" TTT "+ currT + "R=>" + (long) ((currT.get() -epochPicture)));
                    }
                }
        );

        /*
                updateDronePosition chaque 1sec sur localhost:8080
                uploadFile
        */


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

    //http://86.229.200.137:8888/?lat=654,lng=31,ele=332,idm=qsdqd
    private boolean sendPostitionPicToWebservice(CurrentPicture cpic, String urlWS) throws IOException {

        Map<String, String> parameters = new HashMap<>();
        parameters.put("lat", "" + String.valueOf(cpic.getLatitude()));
        parameters.put("lng", "" + cpic.getLongitude());
        parameters.put("ele", "" + cpic.getAltitude());
        parameters.put("idm", cpic.getId());

        URL url = new URL(urlWS+ getParamsString(parameters));
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("GET");

        con.setDoOutput(true);

        int status = con.getResponseCode();
        return  false;
    }


    String getParamsString(Map<String, String> params)
            throws UnsupportedEncodingException {
        StringBuilder result = new StringBuilder();


        result.append("?");
        for (Map.Entry<String, String> entry : params.entrySet()) {
            result.append(URLEncoder.encode(entry.getKey(), "UTF-8"));
            result.append("=");
            result.append(URLEncoder.encode(entry.getValue(), "UTF-8"));
            result.append("&");
        }


        String resultString = result.toString();
        return resultString.length() > 0
                ? resultString.substring(0, resultString.length() - 1)
                : resultString;
    }

    public static Mission.MissionItem generateMissionItem(double latitudeDeg, double longitudeDeg) {
        return new Mission.MissionItem(latitudeDeg, longitudeDeg, 10f, 10f, true, Float.NaN, Float.NaN,
                Mission.MissionItem.CameraAction.NONE, Float.NaN, 1.0);
    }

    public void Cancel(){
        drone.getMission().cancelMissionDownload();
        drone.getMission().cancelMissionUpload();
        drone.getAction().returnToLaunch();
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
}
