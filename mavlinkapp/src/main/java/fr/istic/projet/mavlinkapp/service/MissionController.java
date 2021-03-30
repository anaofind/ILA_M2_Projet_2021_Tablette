package fr.istic.projet.mavlinkapp.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import fr.istic.projet.mavlinkapp.model.CurrentPosition;
import fr.istic.projet.mavlinkapp.model.MissionDrone;
import fr.istic.projet.mavlinkapp.model.PositionDrone;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicHeader;
import org.apache.http.protocol.HTTP;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.validation.DefaultBindingErrorProcessor;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import io.mavsdk.System;
import io.mavsdk.mission.Mission;
import io.mavsdk.mission.Mission.MissionItem;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.net.http.HttpResponse;
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
    public MissionDrone sendMissionCoordonates(@Validated @RequestBody MissionDrone mission) {
        java.lang.System.out.println("submit ip");
        HttpClient client = new DefaultHttpClient();
        CurrentPosition cp = new CurrentPosition();
        cp.setId("TcBJNzRWH9GYOEyKd4OJ");
        cp.setLongitude(4.2565535);
        cp.setLatitude(7.2585204);
        HttpResponse response;
        HttpPost post = new HttpPost("http://148.60.11.47:8080/api/updateDronePosition");
        ObjectMapper mapper = new ObjectMapper();
        String jsonRes = "";
        try {

            java.lang.System.out.println("t1");
            jsonRes = mapper.writeValueAsString(cp);
            StringEntity se = new StringEntity(jsonRes);
            se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
            post.setEntity(se);
            response = (HttpResponse) client.execute(post);
            java.lang.System.out.println("done");

        } catch (IOException e) {
            e.printStackTrace();
        }

        /*HttpURLConnection con = null;
        try {
            java.lang.System.out.println("t2");
            URL url = new URL("http://148.60.11.47:8080/api/updateDronePosition");
            con = (HttpURLConnection)url.openConnection();
            con.setRequestMethod("POST");
            con.setRequestProperty("Content-Type", "application/json; utf-8");
            con.setDoOutput(true);
        } catch (ProtocolException e) {
            e.printStackTrace();
        } catch (MalformedURLException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }

        try {
            java.lang.System.out.println("t3");
            OutputStream os = con.getOutputStream();
            byte[] input = jsonRes.getBytes("utf-8");
            os.write(input, 0, input.length);
            java.lang.System.out.println("done");
        }  catch (UnsupportedEncodingException e) {
            e.printStackTrace();
            java.lang.System.out.println("e1");
        } catch (IOException e) {
            e.printStackTrace();
            java.lang.System.out.println("e2");
        }*/

        /*laMission = mission;
        MyRunnable myRunnable = new MyRunnable(drone);
        Thread t = new Thread(myRunnable);
        t.start();
        //Thread.sleep(500);

        //send images took by drone in rest's meth to app java which will store image in firebase*/
        return laMission;
    }

    @PostMapping("/update")
    public MissionDrone updateDronePosition(@Validated @RequestBody CurrentPosition pos) throws InterruptedException {
        java.lang.System.out.println("called");

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

