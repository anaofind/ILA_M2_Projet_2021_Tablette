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
import fr.istic.projet.servicefirebaseapp.model.Mission;
import fr.istic.projet.servicefirebaseapp.model.MissionInfos;

import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletRequest;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
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
    	
    	//asynchronously retrieve multiple documents
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
    
    public void addUrlPhotoMission(String idMission, String urlPhoto) throws InterruptedException, ExecutionException {
    	MissionInfos missionInfos = getMissionById(idMission);
    	CollectionReference missions = this.database.collection("missions");
    	Mission mission = missionInfos.getMission();
    	String idDocumentMission = missionInfos.getIdDocMission();
    	if(mission!=null && idDocumentMission !=null) {
    	mission.addPhoto(urlPhoto);
    	ApiFuture<WriteResult> futureUpdate = missions.document(idDocumentMission)
    			.set(mission);
		 // block on response if required
		log.info("Update photos mission");
    	}
    }
    	
    	//for (DocumentSnapshot document : documents) {
    	//  log.info(document.getId() + " => " + document.toObject(Mission.class));
    	//}
    	
//    	DocumentReference docRef = missions.document("ApXYK2lm9ZN3EMlaoyRH");
//    	//DocumentReference docRef = db.collection("cities").document("SF");
//    	// asynchronously retrieve the document
//    	ApiFuture<DocumentSnapshot> f = docRef.get();
//    	// ...
//    	// future.get() blocks on response
//    	DocumentSnapshot document = f.get();
//    	if (document.exists()) {
//    	  log.info("Document data: " + document.getData());
//    	} else {
//    	  log.info("No such document!");
//    	}
    
    public String generateV4GetObjectSignedUrl(Storage storage, BlobInfo blobInfo) throws StorageException {
        // String projectId = "my-project-id";
        // String bucketName = "my-bucket";
        // String objectName = "my-object";
        URL url =
            storage.signUrl(blobInfo, 7, TimeUnit.DAYS, Storage.SignUrlOption.withV4Signature());

        System.out.println("Generated GET signed URL:");
        System.out.println(url);
        System.out.println("You can use this URL with any user agent, for example:");
        System.out.println("curl '" + url + "'");
        log.info("mon URLLLLLL "+url.toString());
        return url.toString();
      }

    
    public FileDTO uploadFile(String idMission, double latitude, double longitude) throws IOException, InterruptedException, ExecutionException {
    	 // filename 
    	 String fileName = "angular.png";
         String pathFile="";
         String url ="";
         String nomPhoto= "photo100.png";
         ClassLoader classLoader = getClass().getClassLoader();
  
         File file = new File(classLoader.getResource(fileName).getFile());
         if(file.exists()) {
        	 pathFile = file.getAbsolutePath();
         }
         
        Path filePath = file.toPath();
        String objectName = "images/"+idMission+"/"+nomPhoto;

        Storage storage = storageOptions.getService();

        BlobId blobId = BlobId.of(bucketName, objectName);
        BlobInfo blobInfo = BlobInfo.newBuilder(blobId).setContentType("image/png")
        		.build();
        Blob blob = storage.create(blobInfo, Files.readAllBytes(filePath));
        
        log.info("File " + filePath + " uploaded to bucket " + bucketName + " as " + objectName);
        String token = generateToken();
         //modifier la métadata après l'ajout du file
        setObjectMetadata(blob, latitude, longitude, token);
        
        log.info("after setting metadata");
        url="https://firebasestorage.googleapis.com/v0/b/projet-istic-ila.appspot.com/o/images%2F"+
        idMission+"%2F"+nomPhoto+
        "?alt=media&token="+token;
        addUrlPhotoMission(idMission, url);
        
        //generateV4GetObjectSignedUrl(storage, blobInfo);
        
         //update dans firestore lastUpdateStorageMission pour la mission
        //updatelastUpdateStorageMission(idMission);
        
        //
        //getObjectMetadata(bucketName, objectName);
        //
        
        FileDTO fileDTO =  new FileDTO(objectName, blob.getContentType(), url);
        log.info(fileDTO.toString());
        return fileDTO;
    }

    public void downloadFile(String objectName, String destFilePath) {
    	    // The ID of your GCP project
    	    // String projectId = "your-project-id";

    	    // The ID of your GCS bucket
    	    // String bucketName = "your-unique-bucket-name";

    	    // The ID of your GCS object
    	    // String objectName = "your-object-name";

    	    // The path to which the file should be downloaded
    	    // String destFilePath = "/local/path/to/file.txt";

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
    	    // The ID of your GCP project
    	    // String projectId = "your-project-id";

    	    // The ID of your GCS bucket
    	    // String bucketName = "your-unique-bucket-name";

    	    // The ID of your GCS object
    	    // String objectName = "your-object-name";

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
        // The ID of your GCP project
        // String projectId = "your-project-id";

        // The ID of your GCS bucket
        // String bucketName = "your-unique-bucket-name";

        // The ID of your GCS object
        // String objectName = "your-object-name";

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

    
    
    private File convertMultiPartToFile(MultipartFile file) throws IOException {
        File convertedFile = new File(Objects.requireNonNull(file.getOriginalFilename()));
        FileOutputStream fos = new FileOutputStream(convertedFile);
        fos.write(file.getBytes());
        fos.close();
        return convertedFile;
    }

    private String generateFileName(MultipartFile multiPart) {
        return Objects.requireNonNull(multiPart.getOriginalFilename()).replace(" ", "_");
    }

}
