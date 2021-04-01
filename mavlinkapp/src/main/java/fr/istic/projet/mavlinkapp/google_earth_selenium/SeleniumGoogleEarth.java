package fr.istic.projet.mavlinkapp.google_earth_selenium;//import
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.concurrent.TimeUnit;

import org.openqa.selenium.*;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.support.ui.ExpectedCondition;
import org.openqa.selenium.support.ui.WebDriverWait;


public class SeleniumGoogleEarth {
    double latitude;
    double longitude;

    public SeleniumGoogleEarth(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public byte[] takePic() throws InterruptedException, IOException {
        byte[] pic;
        String baseUrl = "https://earth.google.com/web/@"+ latitude +","+longitude+",51.36728919a,193.00421567d,35y,64.91670241h,77.70282258t,0r";
        System.setProperty("webdriver.gecko.driver", "./geckodriver");

/*
*

String serviceAccountKeyfile = "serviceAccountKey.json";





String pathServiceAccountKeyFile="";





ClassLoader classLoader = getClass().getClassLoader();











File file = new File(classLoader.getResource(serviceAccountKeyfile).getFile());





if(file.exists()) {





pathServiceAccountKeyFile = file.getAbsolutePath();





}











FileInputStream serviceAccount =



new FileInputStream(pathServiceAccountKeyFile);
* */
        // Initiating your driver
        WebDriver driver = new FirefoxDriver();

        // Applied wait time
        driver.manage().timeouts().implicitlyWait(20, TimeUnit.SECONDS);
        // maximize window
        driver.manage().window().maximize();
        driver.manage().window().fullscreen();
        driver.get(baseUrl);
        System.out.println("AVVV");
        waitForPageToLoad(driver);
        Thread.sleep(30000);
        waitForPageToLoad(driver);
        System.out.println("APPP");
        // ScreenShot
        File scrFile = ((TakesScreenshot) driver).getScreenshotAs(OutputType.FILE);

        try {
            com.google.common.io.Files.copy(scrFile, new File("src/main/java/fr/istic/projet/mavlinkapp/google_earth_selenium/resources/screen/screen.png"));
        } catch (IOException e) {
            e.printStackTrace();
        }

        // closing the browser
        driver.close();
        return ScreenShotAsByte(scrFile);
    }
    public void waitForPageToLoad(WebDriver driver) throws InterruptedException {
        ExpectedCondition<Boolean> javascriptDone = new ExpectedCondition<Boolean>() {
            public Boolean apply(WebDriver d) {
                try {
                    return ((JavascriptExecutor) driver).executeScript("return document.readyState").equals("complete");
                } catch (Exception e) {
                    return Boolean.FALSE;
                }
            }
        };

        WebDriverWait wait_page = new WebDriverWait(driver, 60);
        wait_page.until(javascriptDone);
    }

    private static byte[] ScreenShotAsByte(File file) throws IOException {
        FileInputStream fis = new FileInputStream(file);
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        byte[] buf = new byte[1024];

        for (int readNum; (readNum = fis.read(buf)) != -1; ) {
            bos.write(buf, 0, readNum);
        }
        return bos.toByteArray();

    }

    public static void main(String[] args) throws InterruptedException, IOException {
        SeleniumGoogleEarth sge = new SeleniumGoogleEarth(48.0,-1.12);
        sge.takePic();
    }
}


/* String jsonRes = "";
        HttpClient client = new DefaultHttpClient();
        HttpPost post = new HttpPost("http://localhost:8080/api/uploadFile");
        ObjectMapper mapper = new ObjectMapper();
        try {
            jsonRes = mapper.writeValueAsString(posCourante);
            StringEntity se = new StringEntity(jsonRes);
            se.setContentType(new BasicHeader(HTTP.CONTENT_TYPE, "application/json"));
            post.setEntity(se);
            client.execute(post);
        } catch (IOException e) {
            e.printStackTrace();
        }*/
