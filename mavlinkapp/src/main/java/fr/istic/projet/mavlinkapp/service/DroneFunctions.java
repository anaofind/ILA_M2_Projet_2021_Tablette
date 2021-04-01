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

public class DroneFunctions {
    public System drone;
    private static final Logger logger = LoggerFactory.getLogger(DroneFunctions.class);
    private static long epochPicture = Instant.now().getEpochSecond();
    private static long currT = Instant.now().getEpochSecond();

    public DroneFunctions(){
        drone = new System();
    }

    public void go(String idIntervention, String idMission,List<InterestPoint> ListPosition) throws IOException {

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


        currT = Instant.now().getEpochSecond();

        drone.getMission()
                .getMissionProgress()
                .filter(progress -> progress.getCurrent() != progress.getTotal())
                .subscribe(
                        progress -> {
                            //Mission.MissionItem mi = missionItems.get(progress.getCurrent());
                            if(ListPosition.get(progress.getCurrent()).isPhoto()){
                                java.lang.System.out.println(progress.getCurrent());
                                CurrentPicture picture  = new CurrentPicture();
                                picture.setId(idMission);
                                picture.setLatitude(ListPosition.get(progress.getCurrent()).getLatitude());
                                picture.setLongitude(ListPosition.get(progress.getCurrent()).getLongitude());
                                picture.setBytes(new byte[0]);
                                sendPic(picture, "http://148.60.11.47:8080/api/uploadFile");
                            }
                        }
                );


        //int[] cmp = new int[0];
        drone.getTelemetry().getPosition()
                .subscribe(
                        position -> {
                            currT = Instant.now().getEpochSecond();

                            // java.lang.System.out.println("BAHABAHABAH"+ epochPicture+" TTT "+ currT + "R=>" + (long) ((currT -epochPicture)));

                            if (((currT - epochPicture))>=1) {
                                epochPicture = currT;
                                //   java.lang.System.out.println("CACAKKCAH"+ epochPicture+" TTT "+ currT + "R=>" + (long) ((currT -epochPicture)));

                                java.lang.System.out.println(position.getLatitudeDeg() + "---" + position.getLongitudeDeg());
                                CurrentPosition posCourante = new CurrentPosition();
                                posCourante.setId(idIntervention);
                                posCourante.setLatitude(position.getLatitudeDeg());
                                posCourante.setLongitude(position.getLongitudeDeg());
                                if(sendPostitionToWebservice(posCourante, "http://148.60.11.47:8080/api/updateDronePosition")) {
                                    java.lang.System.out.println("envoi position courante : ok");

/*
                                    if(ListPosition.contains(posCourante)getLatitude() == position.getLatitudeDeg() && ListPosition.get(cmp[1]).getLongitude()==position.getLongitudeDeg()) {
                                     */


                                     /*   cmp[1]++;
                                    }*/

                                    CurrentPicture cpic = new CurrentPicture();
                                    cpic.setId(idMission);
                                    cpic.setLatitude(position.getLatitudeDeg());
                                    cpic.setLongitude(position.getLongitudeDeg());
                                    cpic.setBytes(new byte[100]);
                                    //  cpic.setAltitude(position.getAbsoluteAltitudeM());
                                    if(sendPic(cpic,"http://148.60.11.47:8080/api/streamVideo")){
                                        java.lang.System.out.println("envoi Picture : ok");
                                    }
                                } else {
                                    java.lang.System.out.println("echec envoi Picture : nok");
                                }
                            }
                    /*else {
                        java.lang.System.out.println("AHAHAHAH"+ epochPicture+" TTT "+ currT + "R=>" + (long) ((currT -epochPicture)));
                    }*/
                        }
                );
        //}
        //);

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
                    this.Cancel();
                    latch.countDown();
                });
        try {
            latch.await();
        } catch (InterruptedException ignored) {
            // This is expected
        }
    }

    //http://86.229.200.137:8888/?lat=654,lng=31,ele=332,idm=qsdqd
    //http://86.229.200.137:8888?lat=654&lng=31&ele=332&idm=qsdqd
    private boolean sendPic(CurrentPicture cpic, String urlWS) throws IOException {

        String jsonRes = "";
        HttpClient client = new DefaultHttpClient();
        HttpPost post = new HttpPost(urlWS);
        ObjectMapper mapper = new ObjectMapper();
        try {
            jsonRes = mapper.writeValueAsString(cpic);
            java.lang.System.out.println("---jsonPic : " + jsonRes);
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
        drone.getAction().returnToLaunch().subscribe();
        drone.getMission().cancelMissionDownload().subscribe();
        drone.getMission().cancelMissionUpload().subscribe();
        drone.getMission().clearMission().subscribe();
        java.lang.System.out.println("CANCEL");
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
