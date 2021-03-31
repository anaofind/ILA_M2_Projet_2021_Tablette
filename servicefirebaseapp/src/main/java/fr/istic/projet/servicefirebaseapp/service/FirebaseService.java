package fr.istic.projet.servicefirebaseapp.service;

import java.io.FileInputStream;
import javax.annotation.PostConstruct;
import org.springframework.stereotype.Service;

import com.google.api.client.util.DateTime;
import com.google.api.core.ApiFuture;
import com.google.auth.oauth2.GoogleCredentials;
import com.google.cloud.ReadChannel;
import com.google.cloud.Timestamp;
import com.google.cloud.firestore.CollectionReference;
import com.google.cloud.firestore.DocumentReference;
import com.google.cloud.firestore.DocumentSnapshot;
import com.google.cloud.firestore.Firestore;
import com.google.cloud.firestore.QueryDocumentSnapshot;
import com.google.cloud.firestore.QuerySnapshot;
import com.google.cloud.firestore.WriteResult;
import com.google.cloud.storage.*;
import com.google.firebase.FirebaseApp;
import com.google.firebase.FirebaseOptions;
import com.google.firebase.cloud.FirestoreClient;

import fr.istic.projet.servicefirebaseapp.model.FileDTO;
import fr.istic.projet.servicefirebaseapp.model.Intervention;
import fr.istic.projet.servicefirebaseapp.model.Mission;
import fr.istic.projet.servicefirebaseapp.model.MissionInfos;
import fr.istic.projet.servicefirebaseapp.model.Position;
import fr.istic.projet.servicefirebaseapp.util.ParameterStringBuilder;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.RandomStringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.ProtocolException;
import java.net.URL;
import java.nio.channels.Channels;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.UUID;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.TimeUnit;

@Service
public class FirebaseService  {
	private final Logger log = LoggerFactory.getLogger(FirebaseService.class);
	private StorageOptions storageOptions;
    private String bucketName;
    private String projectId;
    private Firestore database;

    public FirebaseService() {}

    @PostConstruct
    private void initializeFirebase() throws Exception {
        bucketName = "projet-istic-ila.appspot.com";
        projectId = "projet-istic-ila";
        String serviceAccountKeyfile = "serviceAccountKey.json";
        String pathServiceAccountKeyFile="";
        ClassLoader classLoader = getClass().getClassLoader();
 
        File file = new File(classLoader.getResource(serviceAccountKeyfile).getFile());
        if(file.exists()) {
        	pathServiceAccountKeyFile = file.getAbsolutePath();
        }
        
        FileInputStream serviceAccount =
				  new FileInputStream(pathServiceAccountKeyFile);
        GoogleCredentials credentials = GoogleCredentials.fromStream(serviceAccount);

        this.storageOptions = StorageOptions.newBuilder()
                .setProjectId(projectId)
                .setCredentials(credentials)
                .build();
        
        
        FirebaseOptions options = new FirebaseOptions.Builder()
        	    .setCredentials(credentials)
        	    .build();
        	FirebaseApp.initializeApp(options);

        	this.database = FirestoreClient.getFirestore();


    }

    public MissionInfos getMissionById(String idMission) throws InterruptedException, ExecutionException {
    	CollectionReference missions = this.database.collection("missions");
    	String idDocumentMission=null;
    	Mission mission = null;
    	MissionInfos missionInfos;
    	
    	ApiFuture<QuerySnapshot> future =
    			missions.whereEqualTo("id", idMission).get();
    	// future.get() blocks on response
    	List<QueryDocumentSnapshot> documents = future.get().getDocuments();
    	
    	if(!documents.isEmpty())
    	{
    		idDocumentMission = documents.get(0).getId();
    		mission = documents.get(0).toObject(Mission.class);
    	}
    	return new MissionInfos(idDocumentMission, mission);
    }	
    
//    public void updatelastUpdateStorageMission(String idMission) throws InterruptedException, ExecutionException {
//    	MissionInfos missionInfos = getMissionById(idMission);
//    	CollectionReference missions = this.database.collection("missions");
//    	Mission mission = missionInfos.getMission();
//    	String idDocumentMission = missionInfos.getIdDocMission();
//    	if(mission!=null && idDocumentMission !=null) {
//    	mission.setLastUpdateStorage(Timestamp.now());
//    	ApiFuture<WriteResult> futureUpdate = missions.document(idDocumentMission)
//    			.set(mission);
//		 // block on response if required
//		log.info("Update lastUpdateStorage");
//    	}
//    }
    
    public byte[] getImageForPosition(double latitude, double longitude) throws IOException {
    	byte[] imageBytes = null;
    	String APIkey ="AIzaSyC35Y9W5C8Kmt09UsGOzp4nPucaJFraXIM";
    	String basePath = "https://maps.googleapis.com/maps/api/streetview?";
    	String size = "465";
    	String heading = "90";
    	String fov = "120";
    	String pitch = "-65";
    	String source = "outdoor";
    	
    	Map<String, String> parameters = new HashMap<>();
    	parameters.put("location", String.valueOf(latitude)+", "+String.valueOf(longitude));
    	parameters.put("size", size+"x"+size);
    	parameters.put("heading", heading);
    	parameters.put("fov", fov);
    	parameters.put("pitch", pitch);
    	parameters.put("source", source);
    	parameters.put("key", APIkey);
    	
    	log.info("URL to get image "+basePath+ParameterStringBuilder.getParamsString(parameters));
    	URL url = new URL(basePath+ParameterStringBuilder.getParamsString(parameters));
    	HttpURLConnection con = (HttpURLConnection) url.openConnection();
    	con.setRequestMethod("GET");
    	
    	con.setDoOutput(true);
    	
    	int status = con.getResponseCode();
    	if(status == 200) {
    		log.info("response code "+status);
    		InputStream stream = con.getInputStream();
    		imageBytes = stream.readAllBytes();
//    	    File targetFile = new File("/home/abdelkarim/Documents/file.jpg");
//    	    FileUtils.copyInputStreamToFile(stream, targetFile);
    	}
    	else {
    		log.info("response code "+status);
    	}
    	
    	con.disconnect();
    	return imageBytes;
    }
    
    public void addUrlPhotoMission(String idMission, String urlPhoto) throws InterruptedException, ExecutionException {
    	MissionInfos missionInfos = getMissionById(idMission);
    	CollectionReference missions = this.database.collection("missions");
    	Mission mission = missionInfos.getMission();
    	String idDocumentMission = missionInfos.getIdDocMission();
    	if(mission!=null && idDocumentMission !=null) {
    	mission.addPhoto(urlPhoto);
    	ApiFuture<WriteResult> futureUpdate = missions.document(idDocumentMission)
    			.set(mission);
		log.info("Update photos mission");
    	}
    }
    

    public void addUrlVideoMission(String idMission, String urlPhoto) throws InterruptedException, ExecutionException {
    	MissionInfos missionInfos = getMissionById(idMission);
    	CollectionReference missions = this.database.collection("missions");
    	Mission mission = missionInfos.getMission();
    	String idDocumentMission = missionInfos.getIdDocMission();
    	if(mission!=null && idDocumentMission !=null) {
    	mission.setVideo(urlPhoto);
    	ApiFuture<WriteResult> futureUpdate = missions.document(idDocumentMission)
    			.set(mission);
		log.info("Update video mission");
    	}
    }
    
    public FileDTO uploadFileFromBytes(String idMission, double latitude, double longitude, byte[] bytes, String imagesOrVideos) throws IOException, InterruptedException, ExecutionException {
    	String url ="";
    	String nomPhoto= RandomStringUtils.randomAlphabetic(8)+".png";
        String objectName = imagesOrVideos+"/"+idMission+"/"+nomPhoto;

        Storage storage = storageOptions.getService();

        BlobId blobId = BlobId.of(bucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/png")
        		.build();
        Blob blob = storage.create(blobInfo, bytes);
        
        log.info("File uploaded to bucket " + bucketName + " as " + objectName);
        String token = generateToken();
         //modifier la métadata après l'ajout du file
        setObjectMetadata(blob, latitude, longitude, token);
        
        url="https://firebasestorage.googleapis.com/v0/b/projet-istic-ila.appspot.com/o/"+imagesOrVideos+"%2F"+
        idMission+"%2F"+nomPhoto+
        "?alt=media&token="+token;
        if(imagesOrVideos.equals("images"))
        {addUrlPhotoMission(idMission, url);}
        else {addUrlVideoMission(idMission, url);}
        
        //update dans firestore lastUpdateStorageMission pour la mission
        //updatelastUpdateStorageMission(idMission);
        
        FileDTO fileDTO =  new FileDTO(objectName, blob.getContentType(), url);
        log.info(fileDTO.toString());
        return fileDTO;

    }
    
    public FileDTO uploadFileToImages(String idMission, double latitude, double longitude) throws IOException, InterruptedException, ExecutionException {
    	byte[] bytes = getImageForPosition(latitude, longitude); 
    	String url ="";
        String nomPhoto= RandomStringUtils.randomAlphabetic(8)+".png";
        String objectName = "images/"+idMission+"/"+nomPhoto;

        Storage storage = storageOptions.getService();

        BlobId blobId = BlobId.of(bucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/png")
        		.build();
        Blob blob = storage.create(blobInfo, bytes);
        
        log.info("File uploaded to bucket " + bucketName + " as " + objectName);
        String token = generateToken();
         //modifier la métadata après l'ajout du file
        setObjectMetadata(blob, latitude, longitude, token);
        
        log.info("after setting metadata");
        url="https://firebasestorage.googleapis.com/v0/b/projet-istic-ila.appspot.com/o/images%2F"+
        idMission+"%2F"+nomPhoto+
        "?alt=media&token="+token;
        addUrlPhotoMission(idMission, url);
        
        //update dans firestore lastUpdateStorageMission pour la mission
        //updatelastUpdateStorageMission(idMission);
        
        FileDTO fileDTO =  new FileDTO(objectName, blob.getContentType(), url);
        log.info(fileDTO.toString());
        return fileDTO;

    }
    
    public FileDTO uploadFileToVideos(String idMission, double latitude, double longitude) throws IOException, InterruptedException, ExecutionException {
    	byte[] bytes = getImageForPosition(latitude, longitude); 
    	String url ="";
        String nomPhoto= RandomStringUtils.randomAlphabetic(8)+".png";
        String objectName = "videos/"+idMission+"/"+nomPhoto;

        Storage storage = storageOptions.getService();

        BlobId blobId = BlobId.of(bucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/png")
        		.build();
        Blob blob = storage.create(blobInfo, bytes);
        
        log.info("File uploaded to bucket " + bucketName + " as " + objectName);
        String token = generateToken();
         //modifier la métadata après l'ajout du file
        setObjectMetadata(blob, latitude, longitude, token);
        
        log.info("after setting metadata");
        url="https://firebasestorage.googleapis.com/v0/b/projet-istic-ila.appspot.com/o/videos%2F"+
        idMission+"%2F"+nomPhoto+
        "?alt=media&token="+token;
        addUrlVideoMission(idMission, url);
        
        //update dans firestore lastUpdateStorageMission pour la mission
        //updatelastUpdateStorageMission(idMission);
        
        FileDTO fileDTO =  new FileDTO(objectName, blob.getContentType(), url);
        log.info(fileDTO.toString());
        return fileDTO;

    }

    public void downloadFile(String objectName, String destFilePath) {

    	    Storage storage = storageOptions.getService();

    	    Blob blob = storage.get(BlobId.of(bucketName, objectName));
    	    if(blob!=null)
    	    {
    	    blob.downloadTo(Paths.get(destFilePath));
    	    log.info(
    	        "Downloaded object "
    	            + objectName
    	            + " from bucket name "
    	            + bucketName
    	            + " to "
    	            + destFilePath);}
    	    else{
	    	log.info(
	    	        "Object "
	    	            + objectName
	    	            + " from bucket name "
	    	            + bucketName
	    	            + " was not found ");
    	    }
    	  }


    public ResponseEntity<Object> downloadFileWithHttp(String fileName, HttpServletRequest request) throws Exception {
        Storage storage = storageOptions.getService();

        Blob blob = storage.get(BlobId.of(bucketName, fileName));
        ReadChannel reader = blob.reader();
        InputStream inputStream = Channels.newInputStream(reader);

        byte[] content = null;
        log.info("File downloaded successfully.");

        content = IOUtils.toByteArray(inputStream);

        final ByteArrayResource byteArrayResource = new ByteArrayResource(content);

        return ResponseEntity
                .ok()
                .contentLength(content.length)
                .header("Content-type", "application/octet-stream")
                .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"" + fileName + "\"")
                .body(byteArrayResource);

    }
    
    public void getObjectMetadata(String bucketName, String blobName)
    	      throws StorageException {

    	    Storage storage = storageOptions.getService();

    	    // Select all fields
    	    // Fields can be selected individually e.g. Storage.BlobField.CACHE_CONTROL
    	    Blob blob =
    	        storage.get(bucketName, blobName, Storage.BlobGetOption.fields(Storage.BlobField.values()));

    	    // Print blob metadata
    	    log.info("Bucket: " + blob.getBucket());
    	    log.info("CacheControl: " + blob.getCacheControl());
    	    log.info("ComponentCount: " + blob.getComponentCount());
    	    log.info("ContentDisposition: " + blob.getContentDisposition());
    	    log.info("ContentEncoding: " + blob.getContentEncoding());
    	    log.info("ContentLanguage: " + blob.getContentLanguage());
    	    log.info("ContentType: " + blob.getContentType());
    	    log.info("Crc32c: " + blob.getCrc32c());
    	    log.info("Crc32cHexString: " + blob.getCrc32cToHexString());
    	    log.info("ETag: " + blob.getEtag());
    	    log.info("Generation: " + blob.getGeneration());
    	    log.info("Id: " + blob.getBlobId());
    	    log.info("KmsKeyName: " + blob.getKmsKeyName());
    	    log.info("Md5Hash: " + blob.getMd5());
    	    log.info("Md5HexString: " + blob.getMd5ToHexString());
    	    log.info("MediaLink: " + blob.getMediaLink());
    	    log.info("Metageneration: " + blob.getMetageneration());
    	    log.info("Name: " + blob.getName());
    	    log.info("Size: " + blob.getSize());
    	    log.info("StorageClass: " + blob.getStorageClass());
    	    log.info("TimeCreated: " + new Date(blob.getCreateTime()));
    	    log.info("Last Metadata Update: " + new Date(blob.getUpdateTime()));
    	    Boolean temporaryHoldIsEnabled = (blob.getTemporaryHold() != null && blob.getTemporaryHold());
    	    log.info("temporaryHold: " + (temporaryHoldIsEnabled ? "enabled" : "disabled"));
    	    Boolean eventBasedHoldIsEnabled =
    	        (blob.getEventBasedHold() != null && blob.getEventBasedHold());
    	    log.info("eventBasedHold: " + (eventBasedHoldIsEnabled ? "enabled" : "disabled"));
    	    if (blob.getRetentionExpirationTime() != null) {
    	      log.info("retentionExpirationTime: " + new Date(blob.getRetentionExpirationTime()));
    	    }
    	    if (blob.getMetadata() != null) {
    	    	log.info("\n\n\nUser metadata:");
    	      for (Map.Entry<String, String> userMetadata : blob.getMetadata().entrySet()) {
    	    	  log.info(userMetadata.getKey() + "=" + userMetadata.getValue());
    	      }
    	    }
    	  }

    public String generateToken() {
    	String token ="";
    	UUID uuid = UUID.randomUUID();
        token = uuid.toString();
        return token;
    }

    public void setObjectMetadata(Blob blob, double latitude, double longitude, String token) {

        Map<String, String> newMetadata = new HashMap<>();
        newMetadata.put("firebaseStorageDownloadTokens", token);
        newMetadata.put("latitude", String.valueOf(latitude));
        newMetadata.put("longitude", String.valueOf(longitude));
        // Does an upsert operation, if the key already exists it's replaced by the new value, otherwise
        // it's added.
        blob.toBuilder().setMetadata(newMetadata).build().update();

        log.info(
            "Updated custom metadata for object " + " in bucket " + bucketName);
      }

  public void updateDronePositionIntervention(String idIntervention, double latitude, double longitude) throws InterruptedException, ExecutionException {
	CollectionReference interventions = this.database.collection("interventions");
	DocumentReference docRef = interventions.document(idIntervention);
	
	ApiFuture<DocumentSnapshot> future = docRef.get();
	DocumentSnapshot document = future.get();
	if (document.exists()) {
	// (async) Update one field
	ApiFuture<WriteResult> futurelat = docRef.update("latitudeDrone", latitude);
	ApiFuture<WriteResult> futurelon = docRef.update("longitudeDrone", longitude);
	
	log.info("Position drone updated");
	} else {
	 log.info("document not found");
	}
//	ApiFuture<DocumentSnapshot> future = docRef.get();
//	DocumentSnapshot document = future.get();
//	Intervention intervention= null;
//	if (document.exists()) {
//	  intervention = document.toObject(Intervention.class);
//	  intervention.setLatitudeDrone(latitude);
//	  intervention.setLongitudeDrone(longitude);
//
//	  ApiFuture<WriteResult> futureUpdate = interventions.document(idIntervention)
//				.set(intervention);
//		log.info("Position drone updated");
//	} else {
//	 log.info("document not found");
//	}
	
}

}
